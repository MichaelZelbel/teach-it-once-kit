# Morning Brief Setup (Chapter 21)

A briefing about your own week, built from your own files, waiting for
you before you start work. Two halves: write the recipe, then hang a
clock on it.

## Half one: the recipe (do this first, always)

In a session with your folder attached, paste this:

```
Build me a morning brief. Write it as a skill, in
.claude/skills/morning-brief/SKILL.md. When it runs, it should read my
profile files, work out what today actually needs from my projects,
deadlines and people, and write the brief as a new file in brief/,
named with today's date. Under 200 words, plain words, no pep talk, no
invented facts. Where you do not know something, say so plainly. Then
run it once so I can see today's brief.
```

You get two things: `.claude/skills/morning-brief/SKILL.md` (the recipe)
and `brief/YYYY-MM-DD.md` (today's brief, for real).

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

1. In the Code side's sidebar, open **More** and click **Routines**. The
   page is titled **Routines**, and across the top it says *Local
   routines only run while your computer is awake and online.*
2. Top right, **New routine**. It offers **New local routine** and
   **New remote routine**. Take the local one. Read `where-it-runs.md`
   if you want to know why before you click.
3. Fill in the form:
   - **Name**: Morning brief. **Description**: one line saying what it
     is for. The description is required.
   - **Instructions**: `Follow .claude/skills/morning-brief/SKILL.md and
     write today's brief as a dated file in brief/.`
   - **Working folder**: **Select folder**, and pick your hub. A local
     routine will not save without one.
   - **Branch** and **Worktree**: leave alone. They belong to people who
     write software.
   - **Permissions**: **Accept edits** is the sane setting for a job that
     only writes into `brief/`. Not **Manual**, which stalls waiting for
     you. Never **Bypass permissions**.
   - **Model**: leave on **Default**.
   - **Schedule**: **Daily**, then pick your time.
4. **Create**.

## Do the approval pass before you walk away

The routine's page has a **Run now** button. Press it, watch one real
run, and answer every question it asks with the always-allow option
rather than the once-only one. Those answers stick, and future runs
inherit them. Skip this and you get the worst failure in the book: a
brief that started at seven, hit one question, and waited politely until
you opened the app at nine.

What you granted is listed on the routine's page under **Always
allowed**, one row each, with a bin beside every row. Before the first
run that section reads *Approvals you grant during a run appear here.*

## The off-switch

**Pause routine** on the routine's page. The next-run line goes and the
entry drops out of the running list. **Enable routine** puts it back. Do
it once today, so stopping is a reflex.

Deleting asks one extra question. The confirmation says *Any sessions
from this routine will be archived*, and under it is a checkbox, **Also
delete files on disk**. Empty, the clock dies and the routine's own file
stays. Ticked, both go.

## Its prompt is a file you own

A local routine keeps its instructions on disk, a folder per routine
under `~/.claude/scheduled-tasks/`, each holding a `SKILL.md`. Edit it in
a text editor and the next run uses the new words. Only the instructions
live there: the schedule, the folder, the model and whether it is on at
all are held by the app.

## Then the register

Tell your assistant the routine is live ("the morning brief is now
scheduled, daily at seven, as a local routine on my computer; update the
register") and let it fill in the block in `procedures.md`: the rhythm,
where it lives, and the off-switch. If you installed the house rules
from Chapter 17, it has often done this already. One glance to confirm.

## Honesty notes

- Routines need a paid plan. The same one this book has needed since
  Chapter 3.
- A schedule fires at most once an hour, both kinds. The schedule box
  refuses anything shorter with *Schedules must run at most once per
  hour*, and a routine that got one anyway is switched off with a message
  saying so. Runs are staggered by a few minutes on top, so 07:00 can
  arrive at 07:04.
- On a laptop that sleeps through 07:00: on waking, the app looks back
  seven days, starts exactly one catch-up for the most recent miss, and
  discards anything older. Six missed days produce one brief, not six.
- **Settings**, **Desktop app**, **General**, **Keep computer awake**
  stops idle-sleep so runs can fire. It says its own limit: your display
  can still turn off, and closing the laptop lid still puts it to sleep.
- A local routine will not run against a folder it has not been trusted
  with. Same trust gate you clicked in Chapter 3.
- The brief is written by an AI. Chapter 24's habit applies to it like
  everything else.
