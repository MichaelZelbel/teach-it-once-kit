# server

Optional. Chapters 28 and 29. This solves one specific problem and nothing else.

**The problem.** Hermes' clock lives inside its gateway, so a scheduled job fires only on a
machine where the gateway is running, and a missed slot is never caught up. A brief that reads
your real files at 6am needs a machine that is awake at 6am with Hermes running. If you work at
a desk machine that stays on, you may never need this folder.

**The answer.** A small rented Linux machine, around five euros a month, holding its own clone of
your folder, kept in step through the private repository you set up in Chapter 18, with Hermes'
gateway as a system service that starts with the machine.

## Start here

Log in to the machine you rented and paste this one line:

```
curl -fsSL https://raw.githubusercontent.com/MichaelZelbel/teach-it-once-kit/main/server/install.sh | bash
```

It asks you one thing, which repository holds your folder, and shows you two codes to type on
any device: one signs Hermes in to your ChatGPT subscription, one signs the machine in to
GitHub. It never asks for a GitHub token, an SSH key, or a Telegram chat id.

| File | What it is for |
|---|---|
| `install.sh` | The one line above. Covers both chapters. Root's phase, then the assistant's account. Built on the shared primitives in `kit-bootstrap`, pinned to a tag. |
| `steps/build-the-server.md` | What the installer does, step by step, for a human reading along or hunting a broken step. |
| `setup.md` | The same build by hand, for when you want to know what it did, or something broke. |
| `install-hermes.sh` | The Hermes half on its own, if you built the server by hand: the `AGENTS.md` ceiling, pointing Hermes at the folder and proving it, the gateway (a user service, unless the system service is already there), and the `morning-brief` cron job. |
| `three-traps.md` | The three things that went wrong building this for real, and the fixes. |

The installer stands on `kit-bootstrap`, a small public repository that holds the install steps
shared with the other kits, so the same code is not maintained in two places:
<https://github.com/MichaelZelbel/kit-bootstrap>

## Read this before you build anything

Three findings from building it on a blank machine on 2026-07-26, and what Hermes changed.

1. **On a server, "ask me first" means "no".** With nobody there to answer a permission prompt,
   a request that waits is a stop button that presses itself. The leash has to be the walls:
   give the assistant its own user account that can reach almost nothing. Hermes ships the
   other half: a scheduled job that reaches for a dangerous command is refused, not paused.
2. **`git add -A` will commit your keys.** Keep the key file OUTSIDE the folder, in the home
   directory, and put `.env*` and `.hub-env` in `.gitignore` as a second net.
3. **A silent failure looks exactly like a quiet morning.** The job's own prompt orders it to
   say so when the recipe is missing or the brief cannot be written, `hermes cron incidents`
   keeps the record, and `hermes cron status` says in one line whether the clock will fire at
   all. Build that on day one, not after the first outage.
