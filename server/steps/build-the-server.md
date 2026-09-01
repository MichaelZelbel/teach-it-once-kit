# Build the always-on server

You are running on a freshly rented Linux machine, in the account that belongs
to the reader's assistant. The installer's first phase already did the parts
that are the same for everybody. **Before you do anything else, know what is
already true**, so you do not ask for things you have:

- Claude Code is installed and signed in. That is what is running you.
- The GitHub tool (`gh`) is installed and signed in with a one-time code, and
  git knows how to push. **There is no token to ask for and no SSH key to make.**
- You are NOT root. That is deliberate. If something needs an administrator,
  say which one command they should run in their admin account, and continue
  with everything else.
- `$HOME/hub` exists but is probably empty.
- The kit is at `$HOME/teach-it-once-kit`, the shared question sheets at
  `$HOME/.kit-bootstrap/steps/`.

## How to talk to the reader

They have read a book that promised they would not need a terminal, and this is
the one chapter that breaks that promise. Every sentence you write should be
readable by somebody who has never used a server.

- **One question per turn, then stop.** Do not run other tool calls in the same
  turn as a question. Their next message is the answer. If you keep working,
  they cannot tell whether to reply or whether you have moved on.
- **Never paste raw terminal output at them.** Say what happened in one line.
- **Never name a file they have not been shown.** "your settings file" beats
  `~/.hub-env` the first time; you can name it afterwards.
- Say what you are about to do before slow steps, so silence is never a mystery.

## 1 — Their folder

Follow `$HOME/.kit-bootstrap/steps/github-repo.md` completely. It ends with
their repository cloned to `$HOME/hub` and a `git pull` that works with no
password.

**Then check what actually arrived.** If `$HOME/hub` is empty or has no
`AGENTS.md`, they have not built the folder from Chapter 3 yet, or they pointed
at the wrong repository. Ask which:

> That repository is empty. Two possibilities: this is a fresh repository you
> made for this, or it is not the one holding your folder. If it is fresh, I can
> put the book's starter folder in it and push, and you will have the same
> rooms Chapter 3 set up. Which is it?

If they want the starter folder:

```bash
cp -R "$HOME/teach-it-once-kit/starter-hub/." "$HOME/hub/"
cd "$HOME/hub" && git add -A && git commit -m "My folder" && git push
```

## 1b — One memory, shared by every machine

Do this straight after the folder arrives, before anything else writes to it.

Every AI assistant keeps its notes about the reader in a folder belonging to the
tool, on one machine. Left alone, that means the server's assistant and the
laptop's assistant each learn things the other never sees. One command points the
tool's folder at `observations/` inside their hub, so there is one memory and git
carries it:

```bash
. "$HOME/.kit-bootstrap/lib.sh" && kb_link_ai_memory "$HOME/hub"
```

It is safe to run again, it never deletes a note, and if the reader already had
notes in the old place it copies them into the hub first and keeps the old folder
with a date on it.

Then commit what it created:

```bash
cd "$HOME/hub" && git add memory && git commit -m "One memory, shared" && git push
```

**Say this to the reader, in your own words, and do not skip it.** They are about
to have a memory they did not ask for, so tell them it exists, that it is plain
files in their own folder that they can read and delete, and that it is theirs
rather than the AI company's. If they do not want it, `rm -rf` on that folder and
the link is the whole undo, and nothing else in the setup breaks.

**On their other machines** (a laptop, a desktop), the same one command joins
them to the same memory. That is `join.sh` on macOS and Linux, `join.ps1` on
Windows, both in `$HOME/.kit-bootstrap`. Mention it only if they say they work on
more than one machine.

## 2 — The keys go where the folder is not

Do this **before** anything writes a secret, not after. This is the mistake the
book's author made and had to rewrite git history to undo.

The settings file lives in the home directory, outside the folder, because the
morning job runs `git add -A`, and `git add -A` means everything:

```bash
umask 077
touch "$HOME/.hub-env"
chmod 600 "$HOME/.hub-env"
```

And a second net inside the folder, so a stray key still cannot travel:

```bash
cd "$HOME/hub"
grep -qxF '.env*' .gitignore 2>/dev/null || echo '.env*' >> .gitignore
grep -qxF '.hub-env' .gitignore 2>/dev/null || echo '.hub-env' >> .gitignore
```

Explain it to them in one sentence: their keys now live in a place the backup
cannot reach, and even if one lands in the folder by accident, git will ignore it.

## 3 — The morning job

The morning brief is a Hermes cron job now, not a shell script, so it is
created in section 5, where Hermes is installed. Nothing to do here except
know what you are building towards: a job named `morning-brief`, running at
06:00 inside their folder, delivering to Telegram, whose own prompt orders it
to say so plainly when a morning breaks. A silent failure and a quiet morning
must never look alike, and `hermes cron incidents` keeps the record when one
does break.

## 4 — Which AI answers their messages

Follow `$HOME/.kit-bootstrap/steps/llm-provider.md`.

Do this **before** installing Hermes only if Hermes is already present; otherwise
install Hermes first (section 5) so that `hermes setup --help` can tell you which
providers this build actually supports. Never work from a remembered list.

## 5 — Hermes, so the folder can answer back

### 5a — The ceiling nobody tells you about, checked FIRST

Hermes puts `AGENTS.md` into every conversation and will not take more than
20,000 characters of it. Past that it keeps the beginning and the end and throws
away **the middle**. No error, no log line, and the assistant is not told either,
so it cannot mention it. From the outside it just looks like it got worse at its
job. Check before installing anything:

```bash
[ -f "$HOME/hub/AGENTS.md" ] && wc -m < "$HOME/hub/AGENTS.md"
```

- **20,000 or more:** stop and tell them plainly. It reads the first 14,000 and
  the last 4,000 and silently drops what is between. They need to move reference
  material into its own file, leave a pointer to it, and get under 19,000.
- **19,000 to 20,000:** it fits, but say how little room is left.
- **No `AGENTS.md`:** Hermes still runs, it just will not know anything about
  them yet.

### 5b — Install it, wire it, schedule it

One script does this whole half, and it is the same one a reader can run by
hand when something breaks, so there is exactly one copy of these steps to fix:

```bash
bash "$HOME/teach-it-once-kit/server/install-hermes.sh"
```

Read what it prints, top to bottom. It checks the ceiling again, installs
Hermes, points `terminal.cwd` at the folder, which is the ONLY setting the
agent's tools obey for their working folder (the old `workspace` key was a
silent no-op that told the reader it worked), installs the gateway service
through Hermes' own generator rather than a hand-written unit, and creates the
`morning-brief` cron job with `--workdir`, the one thing that injects
`AGENTS.md` into a scheduled run.

One path fact worth carrying: Hermes installs into `~/.local/bin`, which their
own shell adds to PATH but cron and systemd do **not**, which is why the script
resolves the full path once and uses it everywhere.

## 6 — Telegram

Follow `$HOME/.kit-bootstrap/steps/telegram.md`, with
`KB_TELEGRAM_ENV="$HOME/.hub-env"`. That records the bot token and chat id in
`~/.hub-env` for anything that messages them outside Hermes.

The morning job's own delivery is Hermes' Telegram connection, and that one is
Hermes' to hold: run `hermes setup` interactively with them and hand it the
same bot token. Two directions come from this one step: the 6am brief lands on
their phone, and they can message the assistant back.

Then start the gateway and ask IT how it is doing:

```bash
HERMES="$(command -v hermes 2>/dev/null || echo "$HOME/.local/bin/hermes")"
"$HERMES" gateway start
"$HERMES" gateway status
```

Never read the gateway's health from `systemctl is-active`: a cleanly stopped
gateway shows as `failed` to systemd, so it cannot tell an operator's stop
from a crash. Hermes' own status line can.

## 7 — Prove it, do not assume it

Three things have to be true, and you check all three:

```bash
HERMES="$(command -v hermes 2>/dev/null || echo "$HOME/.local/bin/hermes")"

# 1. The morning job runs end to end, right now, without waiting for 6am.
"$HERMES" cron run morning-brief

# 2. The clock will actually fire. "Run now" proves the job, NOT the schedule:
#    the ticker lives inside the gateway, and cron status says so either way.
"$HERMES" cron status

# 3. The gateway is up, asked of Hermes itself.
"$HERMES" gateway status
```

Then ask them to look at their phone:

> Check your phone. You should have a message from your bot. Reply to it here
> with what you see, and then send your bot "what is in my folder?" and tell me
> whether it answers.

**Do not report this as working until they confirm both.** A message you sent
that nobody saw arrive is not a working connection, and a gateway that is
"active" has not been shown to answer anything.

## 8 — Write it down where it belongs

Add the job to their `procedures.md`, in the same session it was built, with the
"where it runs" column filled in properly at last: **the server**. That is the
line they will be glad of in a year when they are trying to remember which
machine sends the thing.

Then commit and push, so their laptop copy learns about it too:

```bash
cd "$HOME/hub" && git add -A && git commit -m "The always-on server" && git push
```

## 9 — Tell them what they now own

Short, plain, no terminal output. What runs, when, where, what it costs (around
five euros a month), and the one thing that is now their responsibility: it is a
machine they own, so when it breaks, it is theirs to fix. Then the two commands
worth remembering:

- `systemctl --user status hermes-gateway` — is my assistant awake?
- `tail ~/brief.log` — did this morning's brief go out?
