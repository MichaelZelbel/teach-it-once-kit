# Memory index

This is what your assistants have learned about you and your work, one file per
fact, and this page is the list of them. It starts empty. It fills up on its own
as you work.

**Why it lives here and not inside the AI tool.** Every AI assistant keeps notes
about you in a folder that belongs to the tool, on one machine. So the notes
never leave that machine, and your other assistants cannot see them. This folder
is inside your hub instead, which means it travels with everything else in the
folder, and every assistant on every machine you own reads the same one.

**Why an index and not just a pile of files.** Your assistant reads this list at
the start of a session, and opens a memory file only when the subject comes up.
The list is small; the files behind it do not have to be. Loading everything
every time would cost a lot and tell the assistant almost nothing it needs.

## How a memory is written

One file per fact, in this folder, with a short header:

```markdown
---
name: the-file-name-without-md
description: one line, so a session can tell whether to open it
metadata:
  type: user | feedback | project | reference
---

The fact itself. Link a related memory with [[its-name]].
```

`user` is who you are. `feedback` is a rule you gave your assistant ("never do
X"). `project` is work in progress. `reference` is a pointer to something
outside, like a link or an account.

The split matters for one reason: a rule has to be in front of the assistant at
all times, because it cannot search for a rule it does not know exists. A fact
is different. It can sit here until the subject comes up.

## The list

One line per memory, like this:

- [What it is](some-fact.md) - the short version, so a session can tell whether to open it

Nothing here yet.
