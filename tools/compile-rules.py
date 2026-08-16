#!/usr/bin/env python3
"""compile-rules.py - write the short list of your rules into AGENTS.md.

WHAT THIS IS
------------
Your rules live in `rules/`, one file per rule, and each file holds the whole story: what the
rule is, why you gave it, and what its exceptions are. That is the version you edit.

Your assistant cannot read all of that every session. So this program takes the one-line version
of each rule (the `line:` in the file's header) and writes them all into `AGENTS.md`, between two
markers. That block is what your assistant actually reads, every time, before anything else.

You edit the files in `rules/`. You never edit the block. Run this and the block catches up.

WHY IT WORKS THIS WAY
---------------------
You cannot search for a rule you do not know exists. If a rule sits in a folder waiting to be
looked up, your assistant will break it without ever knowing it was there. So rules have to
arrive uninvited, which means they have to be in the file your assistant reads first.

But a rule with its whole story is a page long, and twenty of those would crowd out everything
else. Hence the split: the story stays in the file, one sentence goes in the block, and the block
names the file so your assistant can open it when it matters.

THE CEILING
-----------
The block has a size limit, and this program refuses to write past it. That refusal is the point.
Rules accumulate: every time something goes wrong you want to add one, and nothing ever removes
one. Past a certain size they start contradicting each other at the edges, and an assistant with
twenty overlapping rules obeys them worse than one with eight clear ones.

So when a new rule will not fit, this tells you which lines are longest and asks you to merge,
shorten, or drop one. Raising the number is the thing it exists to stop you doing.

USAGE
    python3 tools/compile-rules.py             rewrite the block in AGENTS.md
    python3 tools/compile-rules.py --check     say whether it is out of date, change nothing

Run it from your hub folder, or give it the folder:
    python3 tools/compile-rules.py --hub /path/to/hub
"""

import os
import re
import sys

BEGIN = "<!-- rules:begin"
END = "<!-- rules:end -->"

# How big the block may get, in characters. About 4,000 is fifteen to twenty rules, which is
# more than most people ever need and about as many as an assistant can hold at once.
MAX_CHARS = 4000

GROUPS = [("must", "**I must:**"), ("never", "**I must never:**"), ("how", "**How things work here:**")]

FOOTER = ("Each name in brackets is a file in `rules/` with the whole story behind that rule. "
          "Open it before deciding a rule does not apply.")


def read(path):
    with open(path, encoding="utf-8", errors="replace") as fh:
        return fh.read()


def header(text):
    """Read the `key: value` lines at the top of a rule file, between the two --- lines."""
    if not text.startswith("---"):
        return {}
    end = text.find("\n---", 3)
    if end == -1:
        return {}
    out = {}
    for raw in text[3:end].split("\n"):
        m = re.match(r'^([a-zA-Z_][a-zA-Z0-9_]*):\s*(.*)$', raw)
        if not m:
            continue
        val = m.group(2).strip()
        if val[:1] == '"' and val[-1:] == '"':
            val = val[1:-1].replace('\\"', '"')
        out[m.group(1)] = val
    return out


def main(argv):
    hub = os.getcwd()
    if "--hub" in argv:
        hub = os.path.abspath(argv[argv.index("--hub") + 1])
    check = "--check" in argv

    rules_dir = os.path.join(hub, "rules")
    agents = os.path.join(hub, "AGENTS.md")
    if not os.path.isdir(rules_dir):
        sys.stderr.write("There is no rules/ folder in %s, so there is nothing to compile.\n" % hub)
        return 2
    if not os.path.isfile(agents):
        sys.stderr.write("There is no AGENTS.md in %s. That is the file your rules go into.\n" % hub)
        return 2

    rules, problems = [], []
    for name in sorted(os.listdir(rules_dir)):
        if not name.endswith(".md") or name in ("README.md", "MEMORY.md"):
            continue
        h = header(read(os.path.join(rules_dir, name)))
        slug = name[:-3]
        if h.get("where", "always") != "always":
            continue  # a rule kept for reference, or one that belongs to a single job
        if not h.get("line"):
            problems.append("%s has no `line:` in its header, so there is nothing to put in the "
                            "block. Add one: a single sentence saying what the rule is." % slug)
            continue
        rules.append((h.get("group", "how"),
                      int(h["order"]) if h.get("order", "").isdigit() else 99,
                      slug, h["line"]))
    if problems:
        for p in problems:
            sys.stderr.write("  %s\n" % p)
        return 2
    if not rules:
        sys.stderr.write("No rules found in %s. Nothing written.\n" % rules_dir)
        return 2

    parts = [BEGIN + " - written by tools/compile-rules.py from the files in rules/. "
                     "Edit those, not this. -->", ""]
    n = 0
    for key, title in GROUPS:
        rows = sorted([r for r in rules if r[0] == key], key=lambda r: (r[1], r[2]))
        if not rows:
            continue
        parts += [title, ""]
        for _, _, slug, line in rows:
            n += 1
            parts.append("%d. %s `[%s]`" % (n, line, slug))
        parts.append("")
    parts += [FOOTER, "", END]
    block = "\n".join(parts) + "\n"

    if len(block) > MAX_CHARS:
        longest = sorted(rules, key=lambda r: -len(r[3]))[:3]
        sys.stderr.write(
            "Not written. The block would be %d characters and the limit is %d.\n\n"
            "That limit is here on purpose. Rules pile up, and past a certain number they start\n"
            "contradicting each other at the edges, which makes your assistant worse rather than\n"
            "better. Merge one into a rule that already covers the same ground, shorten one, or\n"
            "drop one. Your three longest lines:\n\n" % (len(block), MAX_CHARS))
        for _, _, slug, line in longest:
            sys.stderr.write("  %4d characters  %s\n" % (len(line), slug))
        return 1

    cur = read(agents)
    i, j = cur.find(BEGIN), cur.find(END)
    if i == -1 or j == -1:
        sys.stderr.write(
            "AGENTS.md has no place to put the rules. Add these two lines where they belong,\n"
            "then run this again:\n\n    %s -->\n    %s\n" % (BEGIN, END))
        return 2
    # Keep one blank line after the closing marker, or the paragraph below it collides with the
    # block and reads as part of it.
    rest = cur[j + len(END):].lstrip("\n")
    new = cur[:i] + block + ("\n" + rest if rest else "")

    if check:
        if new != cur:
            sys.stderr.write("AGENTS.md is out of date. Run: python3 tools/compile-rules.py\n")
            return 1
        print("AGENTS.md is up to date: %d rules, %d characters." % (n, len(block)))
        return 0

    if new == cur:
        print("Nothing to change: %d rules, %d characters." % (n, len(block)))
        return 0
    with open(agents, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(new)
    print("AGENTS.md now carries your %d rules (%d characters, limit %d)." % (n, len(block), MAX_CHARS))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
