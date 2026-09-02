# Where It Runs (Chapters 20 and 21)

The one mechanical fact that decides what every procedure in this book
can do. Read it once, and the rest of Part V stops being confusing.

## The rule

**A job fires only on a machine where Hermes is running. A machine that
is off runs nothing, and a missed slot is never caught up.**

Hermes' clock lives inside the part of it that runs in the background,
the gateway. Nothing else fires a scheduled job. There is no cloud kind
and no "remote routine": your jobs run where a Hermes gateway runs, and
read whatever folder that machine holds.

## How to tell whether your jobs will fire

One command, and the program answers in its own words:

```
hermes cron status
```

On a laptop with the Hermes window open and no gateway running (measured
2026-09-02, Hermes 0.20.6 on Windows 11):

```
Gateway is not running, cron jobs will NOT fire

To enable automatic execution:
  hermes gateway install    # Install as a user service
```

On a server where the gateway runs as a system service (measured
2026-09-02, Hermes 0.21.0 on Ubuntu 24.04):

```
Gateway is running, cron jobs will fire automatically
  PID: 709
  Ticker heartbeat: 41s ago
```

Read that line before you trust any schedule. It beats this card a year
from now.

## Nothing is caught up

Measured on hardware (Run 2, 2026-09-01): a two-minute job, gateway
stopped across three slots, zero fires while it was down, the next live
slot after it came back, and the missed slots never replayed. So on a
laptop that sleeps through 07:00, the 07:00 brief does not arrive at
07:00, and it does not arrive at 08:15 either. It arrives at the next
07:00 the machine is awake for.

## Living with that

- **A desk machine that stays on.** Tell Hermes to start its gateway with
  the machine (`hermes gateway install`, which on Windows registers a
  scheduled task that starts on login). Then every morning is a morning.
- **A laptop you close at night.** The honest promise is "it runs the
  morning I open the lid, if the gateway is running", not "it runs while
  I sleep".
- **The grown-up answer.** A small server of your own that never sleeps,
  with Hermes' gateway as a system service and its own copy of your
  folder. That is Chapter 28, and every job you build on your laptop moves
  there unchanged.

## The four parts of a cron line

```
hermes cron create "0 7 * * *" "Follow skills/morning-brief/SKILL.md and write today's brief as a dated file in brief/." --name morning-brief --workdir /path/to/your/hub
```

- **Schedule.** Five fields, minute then hour: `0 7 * * *` is seven every
  morning. Phrases work too; Hermes' own examples are `30m`, `every 2h`
  and `0 9 * * *`. There is no once-an-hour floor: a two-minute job fired
  every two minutes on the test server.
- **Prompt.** One line that names the recipe. A scheduled run is a
  stranger to your session; say the name and the recipe runs.
- **Name.** What you will recognise in `hermes cron list`.
- **Workdir.** Your hub, full path. It is the folder the job runs in AND
  the only thing that hands the job your `AGENTS.md`. Hermes' own help:
  "Omit to preserve old behaviour (no project context files)." Never
  leave it out.

## A hand run proves the recipe, not the clock

`hermes cron run <name>` fires a job immediately and works with the
gateway stopped. Its run record says `source=direct`; a run the clock
fired says `source=builtin`. Testing with a hand run and closing the lid
proves the recipe and nothing about the schedule.

## Jobs never ask

Shipped defaults: a scheduled job that reaches for a command Hermes would
normally ask about is refused, not paused (`approvals.cron_mode: deny`).
A brief that only reads the folder and writes into `brief/` never reaches
for one. If a job genuinely needs a dangerous command, grant it on
purpose in Hermes' approvals; do not discover it at 07:00.

## The desktop screen

Hermes Desktop shows the same clock as a screen titled **Scheduled jobs**,
with a **New cron** button and a form (Name, Prompt, Frequency, Deliver
to, Model). Labels from the app's own string table, 2026-09-02; the
screen was not driven for the book. The terminal line above is the one
the book ran.

## What does not count as a procedure

Asking an open session to "check again in ten minutes" is not a
procedure: nothing is written down, and it is gone when the conversation
ends. It never gets a block in `procedures.md`, because a register entry
for something that quietly died last Tuesday is worse than no entry at
all.
