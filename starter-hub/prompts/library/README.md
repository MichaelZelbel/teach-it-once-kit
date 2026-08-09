# Saved prompts

Prompts worth keeping. One file each.

A prompt is a piece of text you paste into an AI to get a job done. This drawer
is where the good ones live, so you never have to write one twice or hunt for it
in an old chat.

**This is not the same thing as `skills/`, and mixing them up causes real
trouble.** A skill is a recipe your assistant reads and follows by itself. It has
a short header at the top saying what it is for, which is how the assistant can
pick the right one without opening all of them. A prompt has no such header, so
your assistant cannot browse this drawer and choose. It is yours to reach for.

The plain version of the difference:

| | `skills/` | `prompts/library/` |
|---|---|---|
| Who uses it | your assistant, by itself | you, by pasting it somewhere |
| Where it runs | in this folder | anywhere, including tools that cannot see this folder |
| How it is found | the assistant reads the header and picks | you search for it, or ask your assistant to |

The clearest example is a prompt for making a book cover. The tool that makes the
picture cannot see this folder and never will. So the prompt is not a skill. It is
a thing you carry, and this is where you keep it.

## How a saved prompt is written

One file per prompt, in this folder, shaped like this:

```markdown
---
purpose: one line saying what this prompt is for
source: where it came from, and when
---

The prompt text itself, exactly as it works best.
```

The `purpose` line is the one part worth caring about. It is what shows up when
you search, so write it for the version of you who has forgotten this file exists.

## How to get things in here

- **Ask.** "Save that prompt in my prompts library, call it cover-art, and write
  a purpose line for it."
- **From your old AI.** Chapter 1's export asks your previous assistant for the
  prompts behind the jobs it does for you again and again. Those land here.

## How to get things out

Ask your assistant. "Find the prompt I used for the cover art." It will search
this folder and the log next door in `prompts/archive/`.

Nothing here yet. It fills up as you work.
