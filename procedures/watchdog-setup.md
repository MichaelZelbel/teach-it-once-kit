# Watchdog Setup (Chapter 19)

A watchdog is a procedure that checks something for you and only speaks
up when reality changed. You stop checking; it starts. Type your
watchdog into the **Scheduled** page's **Schedule a task** box.

## The pattern

Every watchdog task has the same five parts. Keep all five:

1. **The rhythm.** "Every Friday at 16:00" / "Every morning at 8:00".
   A watchdog patrols on a schedule; it does not stand guard every
   second. Pick the rhythm from how fast the thing you watch moves.
2. **The watch.** What to check, said narrowly. One watchdog per worry.
3. **The bar.** What counts as news ("only report changes that alter
   what users see or click", "only if the price drops below X").
4. **The receipt.** "Tell me where you read it, with a link."
5. **The quiet line.** "If you find nothing solid, write exactly one
   line: 'All quiet, nothing changed.' Never pad a quiet day." The
   quiet line is the heartbeat: it proves the watch ran.

## Worked example (the author's own)

```
Every Friday at 16:00, run my product watchdog. Search the web for
changes announced this week to ChatGPT's Projects, Scheduled tasks,
memory, or personalization features. Only report changes that alter
what users see or click. For each change, tell me what changed and
where you read it, with a link. If you find nothing solid, write
exactly one line: "All quiet, nothing changed." Never pad a quiet week.
```

## Ideas to steal (public-web watches, no special access needed)

- A product you want back in stock, or below a price you name.
- Announcements from your town, your kid's school's public calendar,
  your professional association.
- A software release or feature change that affects how you work.
- Tour dates, ticket sales, or a festival lineup.
- Mentions of your name, your business, or your product.

## Test it today, not on Friday

Fire a disposable copy (the Chapter 18 move): retype the task with the
first line changed to "In 5 minutes, run my product watchdog once."
Check the run, then delete the completed copy and its chat.

## Boundary

These watchdogs watch the public web. Watching private things (your
inbox, your bank) needs connected apps and the red lines of Chapter 21
first. Walk before that.
