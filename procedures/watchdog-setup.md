# Watchdog Setup (Chapter 23)

A watchdog is a procedure that checks something for you and speaks up
only when reality changed. You stop checking. It starts.

A watchdog reads the public web and needs nothing out of your folder, so
it is the one procedure in this book with a real argument for running in
the cloud. It also has a real argument for staying local, and the local
one wins on the first build. See **Where to put it**, below.

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
   link." Chapter 24 arriving early.
5. **The quiet line.** "If you find nothing solid, write exactly one
   line: 'All quiet, nothing changed.' Never pad a quiet week." A
   watchdog that says nothing is indistinguishable from a watchdog that
   broke. Silence you can trust has to be spoken out loud.

## Worked example (the author's own, run for real)

```
Run my product watchdog. Search the web for changes announced in the
last seven days to the Claude desktop app's Code tab, its Routines, its
skills, or how it gets access to a folder. Only report changes that
alter what a user sees or clicks. For each change, tell me what changed
and where you read it, with a link. Append the result to
watch/product-watchdog.md, newest at the top, with the date on it. If
you find nothing solid, write exactly one line: "All quiet, nothing
changed." Never pad a quiet week.
```

## Where to put it

**More**, **Routines**, **New routine**, **New local routine**. Name it,
write the one-line description, paste the prompt into **Instructions**,
pick your hub as the **Working folder**, set **Permissions** to **Accept
edits**, set the **Schedule** to **Weekly** (or Daily), pick a day and a
time, **Create**.

Two notes on that, because the obvious instinct is now wrong:

- **A local routine always has a folder.** The form will not save
  without one. "This job has no business in my folder" is no longer an
  option, and it turns out not to be needed: giving it the hub is what
  lets it write its weekly line into a file you already walk past.
- **The cloud kind is the one that runs while your laptop is shut**, and
  for a watchdog that is a genuine draw. The price is where the work
  lands: a remote routine writes to a branch in your GitHub copy, not
  into your folder. For a weekly one-liner that is a worse landing place.
  Take the local one first; move it to Chapter 28's machine when you
  want it running through the weekend.

Do not wait for Friday to see it work: press **Run now**, and use that
run to answer its questions with the always-allow option.

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
switch one on, have the red lines from Chapter 17 installed, and know
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
