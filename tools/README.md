# tools

Five small programs. The installer puts them on your computer. **They are not part
of your hub folder, and that is deliberate.**

Chapter 4 says your hub is a folder of text files and that nothing in it needs a
terminal. That stays true. These are software, like your assistant is software, so
they live where software lives on your computer and they write into the folder from
the outside.

## What they are

- **`prompt-harvest.js`** starts the job. It works out where your hub is, finds a
  working Python, runs the collector, saves the result into your hub and pushes it.
- **`hub-prompt-archive`** is the collector, and the interesting one. It reads the
  conversation logs your AI tools keep on this computer, takes the turns a human
  typed and the reply the AI showed for each of them, removes anything that looks
  like a password or a private name, and writes what is left into
  `prompts/archive/` in your hub. It never keeps the AI's internal machinery, only
  text you actually saw, so you can later ask "what was that answer again" as well
  as "what did I type".

Together they are the program Chapter 4 and Chapter 31 mean when they say
*"a program fills it"*.

The third one is the only one here you type yourself.

- **`compile-rules.js`** takes the one-line version of each rule in `rules/` and
  writes them all into `AGENTS.md`, between two markers, so your assistant reads
  your whole rulebook at the start of every session without reading a page per
  rule. You edit the files; you never edit the block. It refuses to write past
  4,000 characters, which is fifteen to twenty rules, and tells you which of your
  lines are longest instead. That refusal is the point of it. Chapter 17.

The installer gives it a launcher, so the command is:

```
hub-compile-rules            rewrite the block in AGENTS.md
hub-compile-rules --check    say whether it is out of date, change nothing
```

Run that in your hub folder. It was a Python program called `compile-rules.py`
until 2026-08-21, and the book printed it as `python3 tools/compile-rules.py`,
a path nobody has, for a language this installer never installs.

The other two are the two arrows in Chapter 25's diagram. **Neither runs unless you
connect a notebook**, and a reader who never connects one can ignore both.

- **`notebook-sync.py`** sends copies of your hub files up to your notebook so you
  can search them by meaning instead of by exact word (Chapter 26). It sends
  `observations/`, `skills/` and each decision in `decisions.md` separately. It does not
  send `profile/` or `AGENTS.md`, because your assistant reads those at the start of
  every session anyway, and a search result that repeats what it is already reading
  is noise. Your files are never changed; the copies are.
- **`world-pull.py`** brings the other direction down: the people, dated things and
  facts your notebook knows, written into `world/` as small files so they survive
  without the notebook. It rewrites only the files marked `origin: menerio` and
  never touches one you wrote.

```
python3 ~/.local/bin/notebook-sync.py              # dry run, shows what it would send
python3 ~/.local/bin/notebook-sync.py --apply

python3 ~/.local/bin/world-pull.py                 # dry run, shows what it would write
python3 ~/.local/bin/world-pull.py --apply
```

Both need one thing in your environment first, the key you made in Chapter 26:

```
export MENERIO_API_KEY=your-key-here
```

## What you do with them

For the two prompt programs, nothing. The installer schedules them and they run on
their own. Everything you ever do with the result is to ask your assistant, in words:

```
Search my prompt log for the one about the invoice reminder.
```

If you want to prove they work rather than wait a day, run `hub-prompt-harvest`
once from a terminal and read what it says.

## You choose which tools are read

The installer shows you which AI tools it found on your computer and lets you
untick any of them. Your choice is kept on that machine, in `~/.hub/device.env`
on a line like `HUB_PROMPT_SOURCES=claude,codex`. A tool not on the list is not
read at all. To change your mind later, edit that line or run the installer
again. An empty value (or `-`) means nothing is read on that machine.

## The honest limit

They can only harvest from an AI tool that keeps your conversations as files on
your own computer, which means a terminal tool: Chapters 28 and 30. Claude Desktop,
the desk from Chapter 3, keeps no such store. If that is your only tool, this finds
nothing, `prompts/archive/` stays empty, and nothing is broken. Use
`prompts/library/` next door and save the prompts you care about as you go.

## Why they are in this repository and not in `starter-hub/`

Because a reader who never opens a terminal should never have a Node program and a
Python program sitting in the folder they were told is theirs to read. The kit's
`starter-hub/` is what your hub is *made of*. This folder is what the installer
*puts on the machine*. Two different things, kept apart on purpose.
