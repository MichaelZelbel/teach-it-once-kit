# The monthly question: what are you actually paying for AI? (Chapter 22)

Most people who use AI seriously end up paying for three or four things. One
plan does almost all the work. One or two are quietly costing money every month
for something you stopped using in spring.

You cannot tell which is which by remembering. But your computer has been
keeping the receipts the whole time, and nobody has ever read them.

## The receipts you already have

Every time your AI does a piece of work, it writes down what it did: which model
answered, how much it read, how much it wrote. That record is sitting in a
folder on your machine right now.

On a machine running Claude Code it is `~/.claude/projects/` on Mac and Linux,
and `C:\Users\<you>\.claude\projects\` on Windows. You do not have to install
anything or sign up for anything. The file is already there.

The first time this was run on the author's machine it found thirty days of
work in three hundred files: twelve billion units of reading and forty-eight
million of writing, all through one flat monthly plan. That plan turned out to
be carrying about eighty times its own price in work. The plan he had actually
been worrying about was carrying about one percent.

That is the whole point of this card. Not to find you a cheaper plan. To show
you the sizes, so you worry about the right one.

## What this procedure does

Once a month, four things:

1. Reads your receipts and works out what each plan actually carried.
2. Asks you **one** question, if there is something it cannot work out.
3. Writes you a page you can look at.
4. Tells you if something looks like dead weight, and leaves the decision to you.

## The rule that keeps it honest

**It never tells you which AI is better.**

That changes every month, the tests everyone quotes measure somebody else's
work rather than yours, and an AI asked to compare providers from a web search
will write you a confident paragraph either way. Confident and wrong is worse
than silent.

So it reports two things it cannot be wrong about: what you paid, and what you
used. The choice stays yours. If you want a real comparison, the only one worth
having is ten real jobs from your own month run through both, judged by you.

## Step 1: start the list

In a session with your folder attached:

```
Create profile/subscriptions.md. Add one block per AI subscription I pay
for, in this shape, and leave anything I have not told you blank rather
than guessing:

## (name of the plan)
Costs: ($X per month, or blank).  Renews: (a day of the month, or blank).
Receipts: (claude-code, or none).  Status: active.

The ones I pay for right now are: (list them).
```

Blanks are not a failure. A blank is next month's question.

## Step 2: read the receipts

```
Read my Claude Code transcript folder and total up, for the last 30 days
and for each model: how many messages, how much was read, how much was
written. Do not price anything yet. Show me the table.
```

You now know something about your own AI use that you did not know before,
and it took one prompt.

## Step 3: make it a monthly habit

Add it to the weekly review you already have, on the first review of the month:

```
Open .claude/skills/weekly-review/SKILL.md and add a part that runs ONLY on the first
review of a calendar month: read my Claude Code receipts for the last 30
days, compare them against profile/subscriptions.md, and tell me three
things. What each plan carried. Anything I am paying for that carried
nothing. And ONE question, if the list cannot answer something the
receipts raise. Never tell me which model is better. Never show a plan
you could not measure as zero, say you could not measure it.
Change nothing else.
```

## The two mistakes to design out, and why

**Never show a plan you cannot measure as zero.** Most consumer plans publish no
receipts at all. "I could not see this one" and "$0.00" look identical on a
page, and they point at opposite decisions. One means ask; the other means
cancel. Cancelling on a zero you never measured is the expensive mistake here.

**A unit of work on a flat plan does not cost you money.** This is the one almost
everybody gets backwards, including the author when he first asked the question.
If you pay a fixed fee, using more costs you nothing extra. What runs out is
capacity: the hourly or weekly ceiling. So the question is never "is this plan
cheap". It is "how many times this month did it stop me, and what did that
cost me". The first question has no useful answer. The second one does.

## When it says something looks like dead weight

It should name one specific thing you could do, and then stop. Cancel this.
Downgrade that. Move this work onto the plan already carrying everything else.

It should never do any of them. A procedure that cancels your subscriptions is
a procedure you cannot leave running.
