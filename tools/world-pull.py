#!/usr/bin/env python3
"""Pull Menerio's World down into the hub's world/ folder as markdown.

One way only, and it never writes to Menerio. What this buys is insurance, not
ability: if Menerio disappeared tomorrow the facts would still be in git.

The ownership rule is the whole design, and this script is written so it cannot
break it by accident:

  origin: hub      this side wrote it. Never overwritten. Never deleted.
  origin: menerio  Menerio wrote it and this is a copy. Rewritten every run.

A file with no origin line at all is treated as origin: hub, because the twelve
files that existed before this script have no origin line and losing one of them
is worse than keeping a stale copy.

Usage:
    python3 scripts/world_pull.py                      # dry run, prints the plan
    python3 scripts/world_pull.py --apply              # write the files
    python3 scripts/world_pull.py --apply --self-slug michael
"""
import argparse
import dataclasses
import json
import os
import pathlib
import re
import sys
import urllib.error
import urllib.request

DEFAULT_BASE_URL = "https://tjeapelvjlmbxafsmjef.supabase.co/functions/v1"

HUB = "hub"
MENERIO = "menerio"

# A claim's confidence in hub words, decided by who wrote it. A machine's guess
# is never "certain", however sure the machine sounded.
CONFIDENCE_BY_AUTHOR = {"human": "certain", "machine": "likely"}


# --- frontmatter ------------------------------------------------------------

FRONTMATTER = re.compile(r"^---\r?\n(.*?)\r?\n---\r?\n?(.*)$", re.S)


def parse_frontmatter(text):
    """Return (fields, body). A file with no frontmatter has no fields."""
    match = FRONTMATTER.match(text or "")
    if not match:
        return {}, (text or "")
    fields = {}
    for line in match.group(1).splitlines():
        if not line.strip() or line.lstrip().startswith("#"):
            continue
        if ":" not in line:
            continue
        key, _, value = line.partition(":")
        fields[key.strip()] = value.strip()
    return fields, match.group(2)


def origin_of(text):
    """Who owns this file. Anything that is not explicitly Menerio's is ours."""
    fields, _ = parse_frontmatter(text)
    return MENERIO if fields.get("origin", "").strip().lower() == MENERIO else HUB


def parse_list(value):
    """`[a, b]` or `a, b` into a list. Frontmatter here is not real YAML."""
    text = (value or "").strip()
    if text.startswith("[") and text.endswith("]"):
        text = text[1:-1]
    return [item.strip() for item in text.split(",") if item.strip()]


def render_list(items):
    return "[" + ", ".join(items) + "]"


# --- documents --------------------------------------------------------------


@dataclasses.dataclass
class PulledFile:
    path: str          # repo relative
    text: str
    record_id: str
    kind: str          # entity | event | claim


def slugify(name):
    """Must agree with slugify() in Menerio's _shared/world-records.ts."""
    import unicodedata

    stripped = unicodedata.normalize("NFKD", name or "")
    stripped = "".join(ch for ch in stripped if not unicodedata.combining(ch))
    slug = re.sub(r"[^a-z0-9]+", "-", stripped.lower())
    return slug.strip("-")


def render_entity(record, existing_text=None):
    """A Menerio entity as a hub entity file.

    When the hub already has a file for this thing, only one line is added to
    it: menerio_id. Everything the hub wrote stays exactly as it was, because
    that file is a file a human may have edited.
    """
    if existing_text is not None:
        fields, body = parse_frontmatter(existing_text)
        if fields.get("menerio_id", "").strip() == record["id"]:
            return existing_text
        fields["menerio_id"] = record["id"]
        lines = ["---"]
        for key, value in fields.items():
            lines.append("{}: {}".format(key, value))
        lines.append("---")
        return "\n".join(lines) + "\n" + body

    lines = [
        "---",
        "slug: {}".format(record["slug"]),
        "name: {}".format(record.get("name", "")),
        "type: {}".format(record.get("kind") or "other"),
    ]
    aliases = [a for a in (record.get("aliases") or []) if a]
    if aliases:
        lines.append("aliases: {}".format(render_list(aliases)))
    lines += [
        "origin: menerio",
        "menerio_id: {}".format(record["id"]),
        "---",
        "",
        (record.get("description") or "").strip(),
        "",
    ]
    return "\n".join(lines)


def render_event(record, participant_slugs):
    lines = ["---"]
    if record.get("date"):
        lines.append("date: {}".format(record["date"]))
    if record.get("end_date"):
        lines.append("end: {}".format(record["end_date"]))
    if participant_slugs:
        lines.append("participants: {}".format(render_list(participant_slugs)))
    lines += [
        "source: menerio moment",
        "origin: menerio",
        "menerio_id: {}".format(record["id"]),
        "---",
        "",
        (record.get("title") or "").strip(),
    ]
    description = (record.get("description") or "").strip()
    if description:
        lines += ["", description]
    lines.append("")
    return "\n".join(lines)


def render_claim(record, subject_slug, object_slug=None):
    author = record.get("written_by", "machine")
    lines = [
        "---",
        "subject: {}".format(subject_slug),
        "attribute: {}".format(record.get("attribute", "")),
        "value: {}".format(record.get("value", "")),
    ]
    if object_slug:
        lines.append("object: {}".format(object_slug))
    if record.get("valid_from"):
        lines.append("valid_from: {}".format(record["valid_from"]))
    if record.get("valid_to"):
        lines.append("valid_to: {}".format(record["valid_to"]))
    lines += [
        "confidence: {}".format(CONFIDENCE_BY_AUTHOR.get(author, "likely")),
        "source: menerio {}".format(record.get("origin", "unknown")),
        "written_by: {}".format(author),
        "rank: {}".format(record.get("rank", "normal")),
        "origin: menerio",
        "menerio_id: {}".format(record["id"]),
        "---",
        "",
    ]
    evidence = (record.get("evidence_quote") or "").strip()
    if evidence:
        lines += ["> {}".format(evidence), ""]
    return "\n".join(lines)


# --- matching ---------------------------------------------------------------


def read_existing(root, folder):
    """Every file already in one of the three folders, with its owner."""
    out = {}
    directory = root / "world" / folder
    if not directory.is_dir():
        return out
    for path in sorted(directory.glob("*.md")):
        text = path.read_text(encoding="utf-8")
        fields, _ = parse_frontmatter(text)
        out[path.name] = {
            "text": text,
            "fields": fields,
            "origin": origin_of(text),
        }
    return out


def match_entity_file(record, existing, claimed):
    """Find the hub's file for this Menerio entity, or None for a new one.

    Menerio calls him "Michael Zelbel" and the hub file is michael.md, so a slug
    comparison alone would write a second file for the same person. Name and
    alias are checked as well. A file already claimed by another record is never
    matched twice, so two Menerio duplicates cannot collapse into one file.
    """
    wanted_id = record["id"]
    for name, info in existing.items():
        if name in claimed:
            continue
        if info["fields"].get("menerio_id", "").strip() == wanted_id:
            return name

    record_name = (record.get("name") or "").strip().lower()
    if not record_name:
        return None

    for name, info in existing.items():
        if name in claimed or info["fields"].get("menerio_id"):
            continue
        if info["fields"].get("name", "").strip().lower() == record_name:
            return name

    for name, info in existing.items():
        if name in claimed or info["fields"].get("menerio_id"):
            continue
        if info["fields"].get("slug", "").strip().lower() == record["slug"]:
            return name
        aliases = [a.strip().lower() for a in parse_list(info["fields"].get("aliases", ""))]
        if record_name in aliases:
            return name

    return None


def unique_name(base, taken):
    """`a--b--undated.md`, then `a--b--undated-2.md`. Two true values of one
    attribute are normal here, so a collision is not an error."""
    if base not in taken:
        return base
    stem = base[:-3] if base.endswith(".md") else base
    for n in range(2, 100):
        candidate = "{}-{}.md".format(stem, n)
        if candidate not in taken:
            return candidate
    return "{}-{}.md".format(stem, os.urandom(3).hex())


# --- the plan ---------------------------------------------------------------


def plan_pull(world, root, self_slug="me"):
    """Work out every file to write and every file to remove.

    Nothing owned by the hub is ever in the remove list, and the only hub file
    that appears in the write list is an entity gaining its menerio_id line.
    """
    entities = world.get("entities") or []
    events = world.get("events") or []
    claims = world.get("claims") or []

    existing_entities = read_existing(root, "entities")
    existing_events = read_existing(root, "events")
    existing_claims = read_existing(root, "claims")

    writes = []
    slug_by_id = {}
    claimed = set()

    for record in sorted(entities, key=lambda r: r["id"]):
        match = match_entity_file(record, existing_entities, claimed)
        if match:
            claimed.add(match)
            info = existing_entities[match]
            slug_by_id[record["id"]] = info["fields"].get("slug", "") or match[:-3]
            text = render_entity(record, existing_text=info["text"])
            if text != info["text"]:
                writes.append(PulledFile("world/entities/" + match, text, record["id"], "entity"))
            continue
        name = unique_name(record["slug"] + ".md", set(existing_entities) | claimed)
        claimed.add(name)
        slug_by_id[record["id"]] = name[:-3]
        writes.append(PulledFile("world/entities/" + name, render_entity(record), record["id"], "entity"))

    def subject_slug(kind, subject_id):
        if kind == "self" or not subject_id:
            return self_slug
        return slug_by_id.get(subject_id, "unknown")

    event_names = set(existing_events)
    for record in sorted(events, key=lambda r: r["id"]):
        existing = next(
            (n for n, i in existing_events.items() if i["fields"].get("menerio_id") == record["id"]),
            None,
        )
        name = existing or unique_name(record["slug"] + ".md", event_names)
        event_names.add(name)
        if existing and existing_events[existing]["origin"] == HUB:
            continue
        participants = [slug_by_id[p] for p in (record.get("participants") or []) if p in slug_by_id]
        text = render_event(record, participants)
        if not existing or existing_events[existing]["text"] != text:
            writes.append(PulledFile("world/events/" + name, text, record["id"], "event"))

    claim_names = set(existing_claims)
    for record in sorted(claims, key=lambda r: r["id"]):
        existing = next(
            (n for n, i in existing_claims.items() if i["fields"].get("menerio_id") == record["id"]),
            None,
        )
        subject = subject_slug(record.get("subject_kind", "self"), record.get("subject_id"))
        obj = slug_by_id.get(record.get("object_id") or "")
        base = "{}--{}--{}.md".format(
            subject, slugify(record.get("attribute", "")) or "fact",
            record.get("valid_from") or "undated",
        )
        name = existing or unique_name(base, claim_names)
        claim_names.add(name)
        if existing and existing_claims[existing]["origin"] == HUB:
            continue
        text = render_claim(record, subject, obj)
        if not existing or existing_claims[existing]["text"] != text:
            writes.append(PulledFile("world/claims/" + name, text, record["id"], "claim"))

    # A record that is gone from Menerio takes its copy with it, but only its
    # copy. A hub-owned file is never in this list.
    seen_ids = {r["id"] for r in entities} | {r["id"] for r in events} | {r["id"] for r in claims}
    removals = []
    for folder, existing in (
        ("entities", existing_entities),
        ("events", existing_events),
        ("claims", existing_claims),
    ):
        for name, info in existing.items():
            if info["origin"] != MENERIO:
                continue
            menerio_id = info["fields"].get("menerio_id", "").strip()
            if menerio_id and menerio_id not in seen_ids:
                removals.append("world/{}/{}".format(folder, name))

    return {"write": writes, "remove": sorted(removals)}


# --- talking to Menerio -----------------------------------------------------


class WorldClient:
    def __init__(self, base_url, api_key):
        self.base_url = base_url.rstrip("/")
        self.api_key = api_key

    def fetch(self, updated_since=None, limit=2000):
        query = "?limit={}".format(limit)
        if updated_since:
            query += "&updated_since={}".format(updated_since)
        request = urllib.request.Request(
            "{}/hub-api-world{}".format(self.base_url, query),
            method="GET",
            headers={"Authorization": "Bearer {}".format(self.api_key)},
        )
        with urllib.request.urlopen(request, timeout=120) as response:
            payload = json.loads(response.read().decode("utf-8"))
        return payload.get("data") or {}


def run_pull(world, root, client_label, apply_changes, self_slug="me"):
    plan = plan_pull(world, root, self_slug=self_slug)
    print("{}: write {}  remove {}".format(client_label, len(plan["write"]), len(plan["remove"])))
    if not apply_changes:
        for item in plan["write"]:
            print("  would write  {}".format(item.path))
        for path in plan["remove"]:
            print("  would remove {}".format(path))
        return plan

    for item in plan["write"]:
        target = root / item.path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(item.text, encoding="utf-8")
        print("  wrote  {}".format(item.path))
    for path in plan["remove"]:
        target = root / path
        if target.is_file():
            target.unlink()
            print("  removed {}".format(path))
    return plan


def main(argv=None):
    parser = argparse.ArgumentParser(description="Pull Menerio's World into world/.")
    parser.add_argument("--apply", action="store_true",
                        help="write the files. Without it, print what would happen.")
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--self-slug", default="me",
                        help="the entity slug that means the owner of this hub")
    parser.add_argument("--updated-since", default=None,
                        help="only records changed since this date. Skips removals.")
    args = parser.parse_args(argv)

    api_key = os.environ.get("MENERIO_API_KEY")
    if not api_key:
        print("MENERIO_API_KEY is not set. Run scripts/secrets.ps1 -Persist "
              "(Windows) or . scripts/secrets.sh (Linux) first.", file=sys.stderr)
        return 2

    root = pathlib.Path(args.repo_root).resolve()
    client = WorldClient(os.environ.get("MENERIO_BASE_URL", DEFAULT_BASE_URL), api_key)
    try:
        world = client.fetch(updated_since=args.updated_since)
    except urllib.error.HTTPError as err:
        body = err.read().decode("utf-8", "replace")[:400]
        print("Menerio refused the request: HTTP {} {}".format(err.code, body), file=sys.stderr)
        return 1

    if args.updated_since:
        # A partial answer cannot tell a deleted record from an unchanged one.
        plan = plan_pull(world, root, self_slug=args.self_slug)
        plan["remove"] = []
        print("partial pull since {}: write {}".format(args.updated_since, len(plan["write"])))
        if args.apply:
            for item in plan["write"]:
                target = root / item.path
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(item.text, encoding="utf-8")
                print("  wrote  {}".format(item.path))
        else:
            for item in plan["write"]:
                print("  would write  {}".format(item.path))
        return 0

    run_pull(world, root, "world pull", args.apply, self_slug=args.self_slug)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
