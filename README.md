# Teach It Once: Companion Kit

The reader kit for the book **Teach It Once: Set up a personal AI that knows you and works on its own** by Michael Zelbel.

Everything the book asks you to copy, paste, fill in, or print lives here. You never have to type a template from a page.

## Let it set itself up

Whichever computer you use, one thing to run and no decisions to make. It works out for itself whether this machine needs a first setup or an update.

**On Windows:** **[download HubSetup.exe](https://github.com/MichaelZelbel/teach-it-once-kit/releases/latest/download/HubSetup.exe)** and double-click it. Nothing to type, no terminal.

**On a Mac or Linux:** open a terminal and paste this one line. (A terminal is the normal way to install things on those systems, which is why they get a line and Windows gets a file.)

```
curl -fsSL https://raw.githubusercontent.com/MichaelZelbel/teach-it-once-kit/main/install-hub.sh | bash
```

Either one sets up your hub with the `starter-hub/` folder below already in place, installs the few things it needs underneath (Git, Node.js and Claude Code), and makes one memory that every machine you own shares. If that computer already has a hub, it updates that one instead. Run it as often as you like; it never deletes anything you have written.

**Windows will warn you the first time.** You will see a blue box saying "Windows protected your PC", and at first the only button is *Don't run*. Click **More info**, then **Run anyway**. Windows shows this for any program whose publisher it has not seen enough copies of yet. It is not a virus warning and says nothing about whether the program is safe.

## How to get it by hand

No terminal needed: click the green **Code** button on GitHub and choose **Download ZIP**, then unpack it anywhere.

Later in the book, once your assistant is looking after the folder for you, it can keep this up to date with git instead:

```
git clone https://github.com/MichaelZelbel/teach-it-once-kit.git
```

## What is where

- `starter-hub/`: the folder that becomes your own system. Copy this whole folder and it is your hub. Everything else here fills it up.
- `profile/`: Part II assets. The about-you template, the people and projects interviews, the voice extraction prompt, the capture and spring-clean checklists.
- `skills/`: Part III assets. The skill interview, the five starter recipes, the craft-skill interview, the test checklist, practice texts, and one big finished craft skill (`strip-ai-tells.md`) to see what a real one looks like.
- `procedures/`: Part V and VI assets. Morning brief, weekly review, watchdog, the procedure register, the red lines, the card for keys that run out, and the card for everything else that runs out (`what-runs-out-and-when.md`).
- `living/`: the two-questions card, the privacy audit checklist, the saved-prompt card, the printable build-order card.
- `menerio/`: Part VI, optional. The notebook chapters: what goes in it and what stays out, the MCP connection, and two optional routes for pulling an old AI's memory in.
- `server/`: Part VI, optional. Scripts and guides for giving your system an always-on home.
- `swap/`: Part VI. Config examples for running the same system on a different company's tool and model.

The full chapter-by-chapter map is in `docs/CHAPTERS.md`.

## Status

The book is in production. Folders marked **building** in `docs/CHAPTERS.md` fill up as their chapters are verified and written. Nothing lands here before it has been run live.

## License

MIT. Use it, change it, share it. See `LICENSE`.
