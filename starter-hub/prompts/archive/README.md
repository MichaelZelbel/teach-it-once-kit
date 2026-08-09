# The prompt log

Everything you have typed to an AI, kept so nothing is lost. One file per month.

This drawer is not for reading. It is for looking things up. Months from now you
will want to know how you got some result you liked, and the answer is the words
you actually typed at the time. Nobody remembers those. This is where they are.

**Your assistant must never load this folder.** It is a log, not instructions. If
it read the log every session it would drown in old requests and treat them as
things you want done now. The house rule in `AGENTS.md` says so in one line, and
that rule is the only reason this drawer is safe to have.

## The honest limit

The log fills itself only if you use an AI tool that keeps your conversations as
files on your own computer. That means a terminal tool, which is Chapter 25 and
Chapter 27 of the book.

Claude Desktop, the desk the book gives you in Chapter 3, keeps no such store, so
there is nothing for a program to harvest. If that is your only tool, this drawer
stays empty and nothing is broken. Use `prompts/library/` next door instead, and
save the prompts you care about as you go.

## What a month file looks like

One line per prompt, in the order you typed them, in a format made for machines
to search rather than for you to read:

```
{"ts": "2026-08-09T14:02:11", "machine": "laptop", "text": "the prompt you typed"}
```

## How to look something up

Ask your assistant. "Search my prompt log for the one about the invoice
reminder." It reads both drawers and shows you what it found.

Nothing here yet.
