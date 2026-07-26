# Weekly Review Setup (Chapter 20)

The procedure that keeps the rest of the system true. It reads your
context files and your `inbox/`, tells you what changed, asks you the one
question only you can answer, and hands you your weekly admin as a list
with the file names already filled in.

## Half one: the recipe

In a session with your folder attached:

```
Build me a weekly review. Write it as a skill file in
skills/weekly-review.md. When it runs it should read my context files
and everything in inbox/, then write the review as a new file in
reviews/, named with the date, in four parts:
1) what changed in my projects and people since last week, taken only
   from the files, and where it knows nothing it says so plainly;
2) the one question only I can answer, asked plainly: what actually
   happened last week that mattered;
3) the two or three things in inbox/ that belong in my context files,
   each named with the file it should go to;
4) the one thing my priorities say I should protect this week.
Under 250 words, no pep talk. Then run it once so I can see this
week's review.
```

What each part carries:

1. The clause "where it knows nothing it says so plainly" is the most
   important line in the recipe. A review that quietly invents your week
   is worse than no review.
2. The question only you can answer. The assistant was not in the room.
3. Chapter 9's promotion ritual, arriving by itself, with source file and
   destination file named so there is no thinking left in it.
4. Your priorities from Chapter 6, cashed in as a decision about the
   coming week rather than a list.

## Half two: the clock

Same path as the brief: **Scheduled**, **New task**, **Set up manually**,
prompt `Run my weekly review skill.`, your folder attached,
**Automatically approve**, **Frequency: Weekly**, pick the day and time,
**Save**. Sunday evening works as well as Monday morning. Pick the moment
you already plan your week.

You do not need a disposable test copy, because you already ran the
recipe by hand. If you want to watch the clock itself work, press
**Run now** on the task's page.

## The other half is you

The review lands. It costs you ten minutes, and the ten minutes are the
point.

1. Answer the question in a new file in `inbox/`, in plain sentences:
   what actually happened, what changed, what broke. That answer is a
   capture (Chapter 8), and next week's review will read it.
2. Do the three lines under "Move to context". They are already written
   for you: source file on the left, destination file on the right.
3. If a priority shifted, edit `context/projects.md` while the coffee is
   still warm.

Your context feeds your procedures, and now a procedure feeds your
context. That loop, running by itself, is the closest thing this book has
to a perpetual motion machine.

## Then the paperwork

One block in `procedures.md`. Nothing runs unlisted.
