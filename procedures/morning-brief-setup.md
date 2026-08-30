# Morning Brief Setup (Chapter 21)

A briefing about your own week, built from your own files, waiting for
you before you start work. Two halves: write the recipe, then hang a
clock on it.

## Half one: the recipe (do this first, always)

In a session with your folder attached, paste this:

```
Build me a morning brief. Write it as a skill file in .claude/skills/, called
morning-brief.md. When it runs, it should read my profile files, work
out what today actually needs from my projects, deadlines and people,
and write the brief as a new file in brief/, named with today's date.
Under 200 words, plain words, no pep talk, no invented facts. Where
you do not know something, say so plainly. Then run it once so I can
see today's brief.
```

You get two things: `.claude/skills/morning-brief/SKILL.md` (the recipe) and
`brief/YYYY-MM-DD.md` (today's brief, for real).

Run it two or three more times in the same sitting: read what came out,
edit the skill file, run it again. The facts differ every morning anyway;
the shape is what you are training, and the loop works best while the
last run is still fresh in your head. Chapter 20's rule: no clock for a
recipe you have not watched run.

## One line worth stealing

Tony Stubblebine, the CEO of Medium, ends his own AI morning briefing
with every file he touched in the past 24 hours. The morning starts
with yesterday's thread back in your hand. Steal it: add one line to
`.claude/skills/morning-brief/SKILL.md`:

```
End with one short line naming which files in this folder changed in
the last day. If none did, say nothing.
```

Run the brief again and check the new closing line.

## Half two: the clock

1. Sidebar, **Scheduled**. The page reads *Run tasks on a schedule or
   whenever you need them.*
2. Top right, **New task**. Choose **Set up manually** to see every
   control at once (**Create with Claude** interviews you instead).
3. The box is titled **Create scheduled task**. Fill in:
   - **Name**: Morning brief. **Description**: one line, both required.
   - The prompt: `Run my morning brief skill.`
   - The folder button: pick your folder, if you want the brief that
     knows your life. Read `where-it-runs.md` before you decide.
   - Approval mode: **Automatically approve**. Not **Manually approve**,
     which stalls waiting for you, and not **Skip all approvals**, which
     switches off the safety checks.
   - **Model**: leave on **Default model**.
   - **Frequency**: **Daily**, then pick your time.
   - **Run on your computer**: on for the folder brief. The line under
     the switch is the whole trade: "Only runs while your computer is on.
     Use this if the task needs access to local files or desktop
     extensions."
4. **Save**. The task gets its own page: an **Active** pill, a pill
   saying where it runs, and **Next run**.

## Check it without waiting for tomorrow

The task's page has a **Run now** button. Press it, watch one real run,
then leave the schedule alone.

## The off-switch

The switch next to the task's name. **Active** becomes **Paused**, the
next-run line disappears, the task leaves the sidebar list. Flip it back
and the countdown returns. Do it once today, so stopping is a reflex.

## Then the register

Tell your assistant the task is live ("the morning brief is now
scheduled, daily at seven, on my computer; update the register") and let
it fill in the block in `procedures.md`: the rhythm, where it lives, and
the off-switch. If you installed the house rules from Chapter 17, it has
often done this already. One glance to confirm.

## Honesty notes

- Scheduled tasks need a paid plan. The same one this book has needed
  since Chapter 3.
- A schedule fires at most once an hour, and runs are staggered by a few
  minutes, so 07:00 can arrive at 07:04.
- A task tied to a folder will not run against a folder it has not been
  trusted with. Same trust gate you clicked in Chapter 3.
- The brief is written by an AI. Chapter 24's habit applies to it like
  everything else.
