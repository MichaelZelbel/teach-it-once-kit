# Voice Extraction Prompt (Chapter 8)

A one-time, ten-minute job: teach your AI to write like you by showing it
real samples, not by describing yourself.

## Step 1: collect

Three to five real things you wrote. Normal writing, not best writing:
emails you sent, a message where you explained something, one where you
said no.

## Step 2: extract

Paste them into a chat with this prompt:

```
Here are five real messages I wrote. Study how I write, then describe my
voice as a set of concrete, mechanical rules another writer could follow:
typical sentence length, how I open and close messages, how direct I am,
how I soften bad news, words and phrases I actually use, and words I
would clearly never use. Do not flatter me. Be specific.
```

Read the mirror it hands back. Correct anything wrong. Then:

```
Boil that down to a compact block of style rules, under 1,200 characters,
that I can paste into my assistant's settings. Include a "Never use" list
of my banned words and phrases.
```

## Step 3: install

Paste the block into ChatGPT under **Settings → Personalization → Custom
Instructions**, second box ("How would you like ChatGPT to respond?").

## Filled example (Sam)

```
Write like me: short sentences, plain words, calm and warm. Open with the
point, not a greeting ritual. One idea per paragraph. Soften bad news by
being early and factual, never by groveling. Sign off simply ("Best,
Sam"). Never use: exclamation marks, "I hope this finds you well",
"absolutely!", "I'd be happy to", corporate filler ("touch base",
"circle back"), or emojis in client messages. Humor is allowed, dry and
brief.
```

Tip: the **never list** is the strongest part. Positive style rules bend;
banned phrases hold.
