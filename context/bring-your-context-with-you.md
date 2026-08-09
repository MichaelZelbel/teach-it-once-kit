# Bring your context with you (Chapter 1)

Your folder should not start empty. Whatever AI you have been using already knows things
about you: who you work with, what you are building, the corrections you have made a hundred
times. That is yours. This gets it out.

Do this before anything else in the book. Ten minutes per tool.

There is no button for it, in any product. No AI lets another program read its memory. So the
route is: one prompt in, one answer out, and your assistant files the answer. That is not a
workaround, it is the only route that exists, and it works with every tool.

## Step 1: paste this into the AI you have been using

Use the tool you have actually been talking to. If that is ChatGPT on your phone, use that.
If it is Claude on the web, open the project you have been working in, because its memory is
per project.

````markdown
I am moving to a new assistant that keeps its memory as plain files I own. Export
everything you know about me so nothing is lost.

Use your memory of me, your saved instructions about me, and our past conversations.
Do not invent anything. If you are unsure whether something is true, leave it out.

Output ONLY the document below, using exactly these headings, in this order. Under each
heading, put ONE item per line, starting with "- ". Each line must make sense on its own
to someone who has never met me, so no "he" or "that project", and no reference to this
chat. If a heading has nothing, write "- none".

## WHO I AM
My work, my role, my situation, where I live, my languages. Facts about me as a person.

## PEOPLE
One line per person who matters to my work or life: who they are to me, and the one
thing worth remembering about working with them. Use first names only.

## PROJECTS
One line per project or ongoing piece of work: what it is, where it stands, what it is
for. Include ones that are paused or finished, and say so.

## PREFERENCES AND RULES
One line per instruction I have given you about HOW to work with me. Include everything
I have corrected you on more than once, everything I told you never to do, and how I like
answers shaped. This is the most valuable section, so be thorough.

## DECISIONS
One line per real decision I made and stuck with, with roughly when, and why I made it.

## REUSABLE PROMPTS
The prompts I have asked you for more than once, or that produced work I kept. For each
one use exactly this shape, and put the prompt text itself in a fenced code block:

### <short name for the prompt>
what it is for: <one line>
```
<the full prompt text, exactly as it works best>
```

## THINGS I SHOULD CHECK
Anything you are including that might be out of date or that you are unsure about, one
per line, so I can verify it rather than trust it.
````

## Step 2: read it before you keep it

This is the one moment where you see, on a single page, everything a company's AI believes
about you. Some of it will be wrong. Some of it will be from a job you left. Delete those
lines now. Moving is also cleaning, and this is the only time it is easy.

The PREFERENCES AND RULES section is the valuable one. Those lines are years of corrections
you would otherwise make all over again with a new assistant.

## Step 3: file it in your folder

Save the answer as `inbox/import-from-<tool>.md`, then open a session with your folder and
say:

```
Read inbox/import-from-chatgpt.md. File it into my folder:
- WHO I AM goes into context/about-me.md
- PEOPLE goes into context/people.md
- PROJECTS goes into context/projects.md
- PREFERENCES AND RULES: add each one to AGENTS.md under a heading
  "What ChatGPT learned about how I work"
- DECISIONS: append each to decisions.md with its date
- REUSABLE PROMPTS: one file each in skills/, named the way Chapter 12 names them
- THINGS I SHOULD CHECK: leave in the inbox as a checklist for me

Mark every line you file with where it came from and today's date, so I can
always tell an imported guess from something I told you myself. Do not invent
anything that is not in that file. Show me what you did, then delete nothing.
```

That last paragraph is the part people skip and regret. An imported line is a claim another
company's AI made about you. A line you wrote yourself is a fact. Keep them apart, or in six
months you will not be able to tell which is which.

## Do it again later

You will keep using that other AI. Phone, browser, whatever it is. Every month or two, run
the same prompt again and file only what is new. Put it in your procedure register (Chapter
18) so it is a listed job and not something you have to remember.
