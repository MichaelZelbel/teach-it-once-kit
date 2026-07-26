# Watchdog Setup (Chapter 21)

A watchdog is a procedure that checks something for you and speaks up
only when reality changed. You stop checking. It starts.

This is the one procedure that genuinely belongs in the cloud: it reads
the public web, it needs nothing from your folder, so it can run while
your laptop is shut. Attach no folder, and switch **Run on your
computer** off.

## The five parts

Keep all five, in any order that reads naturally:

1. **The rhythm.** Daily for volatile things, weekly for slow ones. A
   watchdog patrols on a schedule, it does not stand guard every second.
2. **The watch.** What to look at, said narrowly. One watchdog per
   worry. A watchdog that watches everything sees nothing.
3. **The bar.** What counts as news ("only changes that alter what a
   user sees or clicks", "only if the price drops below X"). Without a
   bar, every patrol finds *something* and you have built a spam machine.
4. **The receipt.** "Tell me what changed and where you read it, with a
   link." Chapter 22 arriving early.
5. **The quiet line.** "If you find nothing solid, write exactly one
   line: 'All quiet, nothing changed.' Never pad a quiet week." A
   watchdog that says nothing is indistinguishable from a watchdog that
   broke. Silence you can trust has to be spoken out loud.

## Worked example (the author's own, run for real)

```
Run my product watchdog. Search the web for changes announced in the
last seven days to Claude's Cowork, scheduled tasks, Skills, or folder
access. Only report changes that alter what a user sees or clicks. For
each change, tell me what changed and where you read it, with a link.
If you find nothing solid, write exactly one line: "All quiet, nothing
changed." Never pad a quiet week.
```

Its first run, four minutes after it was built, found a feature that had
shipped the week before, with three dated source links, and correctly
threw away three other findings for being nine days old rather than
seven.

## Where to put it

**Scheduled**, **New task**, **Set up manually**. Name it, add the
one-line description, paste the prompt, leave the folder empty, switch
**Run on your computer** off, set **Automatically approve**, set
**Frequency: Weekly** (or Daily), pick a day and time, **Save**. The
task page should show a pill reading **Runs in cloud**.

Do not wait for Friday to see it work: press **Run now**.

## Ideas to steal (public web, no special access needed)

- A product you want back in stock, or below a price you name.
- Announcements from your town, or a school's public calendar.
- A software release or feature change that affects how you work.
- Tour dates, ticket sales, a festival lineup.
- Mentions of your name, your business, or your product.
- The buttons and menus of the AI app you depend on. They get renamed.

## Boundary: watchdogs and hands

These watchdogs read the public web. Watching *private* things (your
inbox, your bank, your company's systems) needs a **connector**: a switch
in the settings that lets your assistant reach one of your accounts.

A connector is not a bigger version of chatting. It is hands. Before you
switch one on, have the red lines from Chapter 15 installed, and know
that they work harder for procedures than for chats, because a chat has
you in the room.

Two layers, and you want both:

1. **Permissions.** Connect only accounts you actually use. Take
   read-only when it is offered. No stored payment method, ever.
2. **The red lines.** They catch what permissions cannot: the Tuesday
   you type "just do it, I trust you" because you are tired.

## Then the paperwork

One block in `procedures.md`, including the off-switch. Nothing runs
unlisted.
