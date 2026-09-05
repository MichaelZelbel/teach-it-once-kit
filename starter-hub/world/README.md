# world - your life as data

**This room starts empty, and an empty one costs you nothing.** It fills the first time you
connect a notebook and run the pull (Chapter 26). If you never connect one, you have an empty
folder and you have lost nothing.

Everything here is one small text file, so a script can answer questions like "what changed about
Peter this year" without an AI model and without the internet. The AI only steps in when language
is needed.

## The three kinds

1. **Entity**: a thing that exists. A person, a place, an organization, a project, an object.
   One file per entity in `entities/`.
2. **Event**: a thing that happened. It has a date. One file per event in `events/`.
3. **Claim**: a fact believed about an entity. "Peter is my friend", "the flat costs 900 euros".
   One file per claim in `claims/`.

The one useful difference: **an event never changes, and a claim can stop being true.** That is
why a claim can carry a start date and an end date, and an event only carries its day.

## Who owns a file, which is the only rule here

Every file carries an `origin:` line, and it decides who may write to it.

- `origin: hub` means you wrote it. Edit it freely. The pull never touches it and never
  deletes it.
- `origin: menerio` means your notebook wrote it and this is a copy. It is rewritten on every
  pull, so an edit made here is lost at the next one. **Fix the fact in the notebook instead.**

A file with no `origin:` line at all counts as `origin: hub`, so anything you write by hand is
safe by default.

No fact ever has two writers. That is why there is no merge step, nothing to resolve, and no
"last write wins" quietly picking a loser.

## The file formats

Every file starts with a small block between `---` lines, then free text.

`entities/<slug>.md`:

```
---
slug: peter-mueller
name: Peter Mueller
type: person
aliases: [Peter, Pete]
---
Free-text description.
```

`events/YYYY-MM-DD-<slug>.md` (the date prefix makes the folder sort by time):

```
---
date: 2026-08-11
participants: [me, peter-mueller]
source: where this came from
---
What happened, in free text.
```

`claims/<subject>--<attribute>--<date>.md`:

```
---
subject: peter-mueller
attribute: relationship-to-me
value: friend
valid_from: 2024-03-01
confidence: certain
source: you said it
---
Optional detail.
```

`type`, `attribute` and `confidence` are open vocabulary. A missing `valid_to` means "believed
true today". A missing `valid_from` means "true since before you started recording".

## Filling it

```
python3 tools/world-pull.py                  # dry run, shows what it would write
python3 tools/world-pull.py --apply          # write the files
```

You can also write these files by hand, or let your assistant write them. The formats above are
the whole contract.

## When a fact changes

A claim that stops being true gets a `valid_to` date and stays. That is half the job. The
other half is asking what you wrote while it still held. `hub-check-built-on` reads every
claim with an end date, searches `profile/`, `rules/`, `procedures.md` and `AGENTS.md` for
the old value, and names each line it finds. It changes nothing; you decide whether a line
is stale or is history. Two rules make it useful:

- **To keep an old value on purpose, put the date it stopped being true on the same line.**
  "We lived in Krefeld until 2026-03-01" is history and is never reported.
- **A file can say what it depends on.** A `rests_on: [peter-mueller/employer]` line at the
  top of a rule or a note means the file is listed when that fact changes, even when the old
  value is not written in it. Your assistant can add the line when it writes the file.

```
hub-check-built-on                        every fact that changed
hub-check-built-on --claim me/city        one fact
```
