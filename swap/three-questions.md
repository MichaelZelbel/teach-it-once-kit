# The three questions (Chapter 26)

The entrance exam you give any new hire on their first morning. Open a terminal in your folder,
type `opencode`, and ask these three. Answers below are from a real run on 2026-07-26, on a
server, with `moonshotai/kimi-k3`, in the book's illustrator folder. Unedited.

## Question one: do you know whose house this is?

```
Whose folder is this, what are the standing rules you must follow
here, and which file would you check for what matters most right
now? Answer from what is in the folder. Do not change anything.
```

It named the owner, listed the red lines from `AGENTS.md`, and then went further than asked:

> **File I'd check for what matters most right now:** `context/projects.md` ... priority one is
> Nadia's 20-card set, deadline **Tue 28 Jul**, 5 cards in revision (4 days late, each round takes
> 3 days), 3 not started, and Nadia hasn't been told about the slip.

It found `AGENTS.md` on its own, because this tool looks for that filename. Your other assistant
does not. Same file, different doorbell.

## Question two: can you reach my memory?

```
Use my memory tools to look up who <person> is and how they want bad
news delivered. Report what the memory returned. Do not read any file
in this folder for the answer.
```

It quoted real notes, and then did something nobody asked for:

> **Gap, honestly stated:** a note titled "Lead with bad news, no apology" surfaced in semantic
> search, but it is a standalone preference note **not attributed to Nadia**, memory doesn't say
> whose rule it is.

That is Chapter 22's habit arriving unprompted, from a model that has never met you.

## Question three: can you run my procedures?

```
Read skills/plan-my-day.md. In three sentences: what does this
procedure produce, and what does it refuse to do? Change nothing.
End your reply with exactly: Nothing modified.
```

It summarised both halves correctly, and added:

> (Note: `git status` shows a pre-existing modification to `opencode.json` that was already there
> before this session; I only read files and ran read-only commands.)
>
> Nothing modified.

It separated a change it found from a change it made. That is the behaviour you want from
anything with hands.

## What passing means

Three for three means your system is not locked to a vendor. A price rise, a model that gets
worse, a company having a bad year: your answer is a one-line edit to `opencode.json`, not a
migration.
