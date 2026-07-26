# Where It Runs (Chapters 18 and 19)

The one mechanical fact that decides what every procedure in this book
can do. Read it once, and the rest of Part V stops being confusing.

## The rule

**A task that touches a folder on your computer runs on your computer.
A task that runs while your computer is off cannot touch your folder.**

There is no clever way around it, and it is not a bug. Your folder is on
your machine. When your machine is off, nothing can read it.

## What each flavour buys you

| | Runs on your computer | Runs in the cloud |
|---|---|---|
| Can read and write your folder | yes | no |
| Runs while the machine sleeps | no | yes |
| Needs the app open | yes | no |
| Where a file it makes lands | your folder | the task's **Outputs**, in your Claude account |
| Good for | the brief that knows your life, the weekly review | watchdogs, news, anything that reads the public web |

## How to tell which one you got

Do not guess, and do not trust this page a year from now. The app tells
you, twice.

**Before you save.** At the bottom of the **Create scheduled task** box
there is a switch called **Run on your computer**, and the line printed
under it says:

> Only runs while your computer is on. Use this if the task needs access
> to local files or desktop extensions.

**After you save.** The task's own page carries a small pill under the
name. With the switch off it reads **Runs in cloud**.

Those two are the whole answer, and they will still be the answer after
the menus get renamed.

## Living with the local ceiling

If your procedure needs your folder, it needs your machine awake:

- On a desktop that stays on, this costs you nothing.
- On a laptop you close at night, a 07:00 task will not fire at 07:00.
  It fires when you open the lid, and the app tells you it is catching
  up on a missed run. The honest promise is not "it runs while you
  sleep", it is "it runs while the kettle boils".
- The desktop app has a setting that stops the machine from dozing off
  so tasks can fire. It is blunt about its own limit: the display can
  still turn off, and closing the lid still puts the machine to sleep.

## Two other things worth knowing before you schedule anything

- A schedule can fire **at most once an hour**. Every fifteen minutes is
  not on the menu.
- Runs are staggered by a few minutes on purpose, so a 07:00 task may
  land at 07:04. That is normal, not a fault.
