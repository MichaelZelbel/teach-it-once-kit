# Your folder into a memory home (Chapter 23)

Menerio's own import screen offers a prompt that asks your AI to rummage through its chat
history. You have something better: files you wrote on purpose. Use this instead.

## Step 1: turn the folder into standalone statements

Open a session with your folder attached and paste this:

```
Read every file in context/ and in inbox/. Turn what is in them
into a list of standalone statements I can paste into a separate
memory system. Rules: one fact per line; each line has to make
sense on its own, with no reference to a file or a folder; group
the lines under these headings and no others: People, Projects,
Preferences, Decisions, Professional context, Personal context.
Do not invent anything that is not in the files. Output only the
list.
```

**Why "standalone" is the whole trick.** "She wants three options, not one" is useless once it
leaves the file it sat in. "When something slips, Nadia wants to be given three options for the
slip rather than one" survives anywhere. You are not exporting files. You are making sentences
that can stand up by themselves.

## Step 2: import

Menerio, then **Settings**, then **Import**, then the **AI Memory** tab. Paste the whole list
into the box under **Step 2**. A counter tells you what it found. Press **Process & Import** and
leave it alone: roughly five seconds per statement, so a full context folder takes about five
minutes.

A real run, 2026-07-26, on a brand new free account:

```
58 statements out of the folder  ->  "64 items detected" (statements + headings)
Import Summary: 64 imported
observation 37, person_note 6, reference 7, task 8, project 2, unknown 2, idea 1, decision 1
Cost: 20 of 500 free credits. Nothing failed.
```

## Step 3: check the privacy line first, not after

Chapter 17's four drawers still apply. Only the "may travel" drawer goes here. Not bank details,
not something told to you in confidence. If you are unsure, it stays in the folder, and the
folder still works.

## Three things it does not do

All three were run on a fresh account while writing Chapter 23.

1. **It does not fill the People section.** Nineteen of the sixty-four statements were about
   people; the **People** page still read **No people yet** afterwards. The **Enrich profiles
   now** button on the same screen did not change that either. Your people live in your folder's
   `people.md`. Add them here by hand if you want them here.
2. **Short questions beat long ones.** `Nadia` found twelve notes. `rate` found ten.
   `how does Nadia want to hear bad news` found nothing at all, tried twice, minutes apart.
   Search it with nouns, not sentences.
3. **It is a copy, not a move.** Nothing leaves your folder. If the service vanished you would
   lose a search box, not your system. So when a fact changes, change it in the folder first.

## When to re-import

Your folder changes; this copy does not until you tell it to. Re-run both steps when something
big shifts, or once a quarter, whichever comes first. Twenty credits and five minutes. A memory
that is six months stale is worse than none, because you will believe it.
