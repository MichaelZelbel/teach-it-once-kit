# Starter hub

This folder is your personal AI system. The book's installer (Chapter 3)
lays everything inside `starter-hub` into your `hub` folder for you;
Appendix D is the by-hand road, a copy into an empty `hub` folder.
Point your assistant at the result. Chapter 4 of the book walks through
the layout; Parts II and III fill it up.

**The folder names answer one question: when does your assistant read this?**
That is the only thing that separates them, and it is the thing that decides
everything. Some of it has to be in front of your assistant every single time,
because it cannot look up a rule it does not know exists. The rest can wait
until its subject comes up, which is what keeps the first part small.

    profile/       what it knows because you told it ...... every session
    rules/         how it should behave .................... compiled into AGENTS.md
    observations/  what it worked out on its own ........... when the subject comes up
    prompts/       what you typed to an AI ................. never, unless you ask

What is here. Ten names, and they are the whole system:

- `AGENTS.md`: your AI's operating manual. How to work in this folder, and the
  short list of your rules. Different tools look for house rules under
  different file names, so Chapter 15 is where you install this where
  your assistant will actually read it.
- `profile/`: who you are, your people, your projects, your voice. The
  Part II files. You write these.
- `rules/`: one file per rule, holding the whole story of why you gave it.
  Eight are pre-loaded, and they are your red lines. The one-line version of
  each is written into `AGENTS.md` by `tools/compile-rules.py`, which is the
  only rules text your assistant reads every session. You edit the files; you
  never edit that block. Chapter 15.
- `skills/`: one file per skill, the five starters pre-loaded. Say a
  skill's name to run it, or install it into the app so it fires on its
  own (Chapters 10 and 11).
- `procedures.md`: the register. Everything that runs without you.
- `decisions.md`: append-only log of real decisions.
- `inbox/`: where loose captures land between weekly reviews.
- `observations/`: what your assistant works out about you and writes down
  itself, one file per fact, with a page called `MEMORY.md` that it
  reads at the start of a session and that tells it where everything goes.
  You write `profile/`, it writes this. It starts empty and fills up on its
  own. Chapter 8.
- `prompts/`: what you typed to an AI. **Your assistant never reads this
  folder on its own**, it only searches it when you ask, and that rule is
  what makes it safe to keep. Two drawers, each with its own README:
  `prompts/library/` holds the prompts you keep and paste into other
  tools, and `prompts/archive/` is the log of everything you have typed.
  Chapters 11 and 28.
- `world/`: your life as data. The people, dated things and facts your
  notebook knows, copied down as small files so they survive without it.
  **It starts empty and stays empty until you connect a notebook**, and an
  empty one costs you nothing. Chapters 23 and 24, and its own README.

Nothing here needs a terminal. It is a folder of text files, and that is
the point.
