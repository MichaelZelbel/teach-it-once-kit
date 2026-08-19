# Testing a Skill (Chapter 16)

Three tests. None of them takes more than a minute, and each one finds a
different kind of broken.

## Test 1: the cold start

Open a brand new session with your folder attached. No history, no
warm-up, no explaining. Name the skill, give it the input, take your
hands off the keyboard.

What you are looking for:

- The shape came out right without you steering it.
- Where a fact was missing, it left a visible hole or asked, instead of
  filling the gap with something plausible.
- Every numbered rule was obeyed.

A rule that gets broken here is usually a rule that was wrong, not an
assistant that misbehaved. Read it again and ask whether it can actually
be followed in the situation the run was in.

## Test 2: the stranger

Paste the recipe text into a plain chat with no folder attached, add a
realistic input, and send. Do not help it.

- **Good failure:** it names the files it cannot find and refuses to
  invent. Your recipe is honest about what it depends on.
- **Bad pass:** it produces a smooth, complete, confident answer built
  out of guesses. A vague recipe does not fail, it improvises, and
  improvisation looks exactly like competence.

If you get the bad pass, the fix is always the same: replace every
"you know my style" with a file path, and every adjective with a number.

## Test 3: the rule check

The cheapest of the three. Paste an answer the skill gave you, together
with the recipe, and ask:

```
Check the reply below against every numbered rule in
skills/<your-skill>.md. For each rule say kept or broken, and quote the
part that broke it. Do not rewrite the reply.
```

This catches the silent misses: the rule that exists, reads well, and was
simply not applied. Limit worth knowing: the check only sees what you
paste, so paste the whole exchange if the rule depends on what you said
earlier.

## The habit that matters more than the tests

**The second time you make the same correction, it becomes a line in the
file.** Once is a nudge. Twice is a rule announcing itself. Corrections
made in chat evaporate with the conversation; corrections made in the
file hold on the days you are too tired to notice.
