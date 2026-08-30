# The Skill Interview (Chapter 13)

Do not write a recipe from a blank page. Answer questions about how you
like the job done, and let the assistant write the file.

Open a session with your folder attached and paste this, changing the
first sentence to whatever job you actually repeat:

```
I keep asking you to summarize long text, and I keep re-explaining how I
want it. Make that a skill. Interview me first, one question at a time,
until you know the job, the exact shape of the answer, and my rules. Then
write it as .claude/skills/<name>/SKILL.md and tell me what you named it.
```

Expect five or six questions. Some of them will ask about decisions you
have never consciously made (your preferred date format, what should
happen when there is nothing to do). That is the point of the interview:
you have preferences you have never written down, and you notice them
instantly when they are wrong.

## Before you accept the file

Open it and read it. It is plain text in your own folder. Check three
things:

1. **The shape is numbered, not described.** "At most five bullets"
   survives; "keep it brief" does not.
2. **The never list is real.** Every rule in it should come from
   something that has actually annoyed you.
3. **It names the files it needs.** If the recipe depends on your voice
   or your projects, it should say `profile/voice.md` and
   `profile/projects.md`, not "you know my style".

## Naming

The file name is the switch you flick, so make it carry the meaning.
Start with the verb and say whose way it is:

- `summarize-for-me.md`, `answer-email-my-way.md`, `plan-my-day.md`
- not `helper.md`, `email.md`, `notes-thing.md`

## Running it

Say the name: "Run my summarize skill on this", "Answer email my way".
A recipe sitting loose in some other folder does not fire because a matching job walked
past. Installing it as a Skill in the app fixes that properly (Chapter 13
shows the upload): the app matches your request against the skill's
description and runs it for you.
