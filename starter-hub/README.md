# Starter hub

This folder is your personal AI system. Copy everything inside
`starter-hub` into the `hub` folder you made in Chapter 1 (when your
computer asks about replacing `context/about-me.md`, keep your own),
and point your assistant at it. Chapter 4 of the book walks through
the layout; Parts II and III fill it up.

What is here. Eight names, and they are the whole system:

- `AGENTS.md`: your AI's operating manual. How to work in this folder,
  plus your red lines. Different tools look for house rules under
  different file names, so Chapter 15 is where you install this where
  your assistant will actually read it.
- `context/`: who you are, your people, your projects, your voice. The
  Part II files. You write these.
- `skills/`: one file per skill, the five starters pre-loaded. Say a
  skill's name to run it, or install it into the app so it fires on its
  own (Chapters 10 and 11).
- `procedures.md`: the register. Everything that runs without you.
- `decisions.md`: append-only log of real decisions.
- `inbox/`: where loose captures land between weekly reviews.
- `memory/`: what your assistant works out about you and writes down
  itself, one file per fact, with an index called `MEMORY.md` that it
  reads at the start of a session. You write `context/`, it writes this.
  It starts empty and fills up on its own. Chapter 8.
- `prompts/`: what you typed to an AI. **Your assistant never reads this
  folder on its own**, it only searches it when you ask, and that rule is
  what makes it safe to keep. Two drawers, each with its own README:
  `prompts/library/` holds the prompts you keep and paste into other
  tools, and `prompts/archive/` is the log of everything you have typed.
  Chapters 11 and 28.

Nothing here needs a terminal. It is a folder of text files, and that is
the point.
