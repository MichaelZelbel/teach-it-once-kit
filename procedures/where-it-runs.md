# Where It Runs (Chapters 20 and 21)

The one mechanical fact that decides what every procedure in this book
can do. Read it once, and the rest of Part V stops being confusing.

## The rule

**A job that touches a folder on your computer runs on your computer.
A job that runs while your computer is off cannot touch your folder.**

There is no clever way around it, and it is not a bug. Your folder is on
your machine. When your machine is off, nothing in the app can read it.

## The two kinds, and where you choose

Sidebar, **More**, **Routines**, **New routine**. The choice is the two
buttons you are offered: **New local routine** and **New remote
routine**.

| | Local routine | Remote (cloud) routine |
|---|---|---|
| Reads your folder as it is now | yes | no |
| Reads your folder as you last pushed it | n/a | yes, if you did Chapter 18 |
| Runs while the machine sleeps | no | yes |
| Needs the app open | yes | no |
| Where a file it makes lands | your folder | a branch in your GitHub copy, which you have to pull |
| A working folder is required | yes, it will not save without one | no |
| Good for | the brief that knows your week, the weekly review | anything that reads the public web |

## The cloud kind is not "blind", it is "behind"

This card used to say a cloud task could not see your folder at all.
That is no longer the whole truth, and the truth is more useful.

A remote routine works from one or more GitHub repositories, cloned
fresh each run. Chapter 18 already had you push a private copy of your
hub. So a remote routine can read your folder: **the version that was on
GitHub the last time you pushed.**

Two traps come with that, and both are worth saying out loud:

- **The stale copy.** If pushing is a monthly safety net rather than a
  habit, a remote routine is reading last month's life. A brief built on
  last month is worse than no brief, because it is confidently wrong
  about who is waiting on you.
- **Where the work lands.** Output is a branch in your GitHub copy, not
  a file in your folder. Nothing appears on your machine until you pull
  it. A brief you have to go and fetch is a brief you will stop fetching.

## How to tell which one you got

The app tells you, twice, and both places beat this card a year from now.

**Before you save.** The Routines page prints, across the top:

> Local routines only run while your computer is awake and online.

**After you save.** The list filters by where a routine runs, and the
labels are **Local** and **Cloud**.

## Living with the local ceiling

If your procedure needs your folder, it needs your machine awake:

- On a desktop that stays on, this costs you nothing.
- On a laptop you close at night, a 07:00 routine will not fire at 07:00.
  When the machine wakes, the app looks back over the last seven days,
  starts **exactly one** catch-up run for the most recent miss, and
  discards anything older. Six missed days produce one brief, not six,
  and a notice says *Routine ... missed at ... Running now.* The honest
  promise is not "it runs while you sleep", it is "it runs while the
  kettle boils".
- **Settings**, **Desktop app**, **General**, **Keep computer awake**
  stops idle-sleep so runs can fire. It is blunt about its own limit:
  *Prevent your computer from idle-sleeping while Claude is open so
  scheduled tasks can run. Your display can still turn off. Closing the
  laptop lid will still put it to sleep.*

## Two other things worth knowing before you schedule anything

- A schedule fires **at most once an hour**, both kinds. Every fifteen
  minutes is not on the menu, and the app refuses it with *Schedules must
  run at most once per hour.* If you genuinely need that, it is
  Chapter 28's machine, not this page.
- Runs are staggered by a few minutes on purpose, so a 07:00 routine may
  land at 07:04. That is normal, not a fault.

## What does not count as a procedure

You can ask an open session to repeat something on a timer, and it will.
That timer lives inside that one conversation: nothing is written to a
file, it is gone when you close the session, and it stops itself after
seven days. Useful on a busy afternoon, and never a procedure. It never
gets a block in `procedures.md`, because a register entry for something
that quietly died last Tuesday is worse than no entry at all.
