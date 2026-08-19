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

```bash
cp "$HOME/teach-it-once-kit/server/brief.sh" "$HOME/brief.sh"
chmod +x "$HOME/brief.sh"
```

Read the script before you move on. Its bottom half is the part that matters:
it tells them when the brief did not get written, **and** when the brief was
written but never reached their phone. Without that, a broken job looks exactly
like a quiet morning and they find out three weeks later.

Set the clock. Ask what time they want it, defaulting to six in the morning, and
write the line without opening an editor (`crontab -e` would wait for a person
and hang you forever):

```bash
( crontab -l 2>/dev/null | grep -v '/brief.sh' ; echo "0 6 * * * $HOME/brief.sh" ) | crontab -
crontab -l
```

Filtering out the old line first is what makes a second run safe.

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

### 5b — Install it

```bash
command -v hermes >/dev/null 2>&1 || curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
HERMES="$(command -v hermes 2>/dev/null || echo "$HOME/.local/bin/hermes")"
"$HERMES" config set workspace "$HOME/hub"
```

Resolve the full path once, here, and use it everywhere below. Hermes installs
into `~/.local/bin`, which their own shell adds to PATH but cron and systemd do
**not**. A service that just says `hermes` works when tested by hand and fails
every time at three in the morning.

### 5c — Make it survive a reboot and a logout

```bash
mkdir -p "$HOME/.config/systemd/user"
cat > "$HOME/.config/systemd/user/hermes-gateway.service" <<UNIT
[Unit]
Description=Hermes gateway - the assistant that answers your messages
After=network-online.target

[Service]
Type=simple
WorkingDirectory=$HOME/hub
ExecStart=$HERMES gateway
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
UNIT
systemctl --user daemon-reload
loginctl enable-linger "$(whoami)"
```

Without lingering, the service stops the moment they log out, which looks exactly
like a crash and is why half of these setups die on day two. If `enable-linger`
is refused, that is one command for their admin account:
`sudo loginctl enable-linger <user>`. Give them that exact line and carry on.

## 6 — Telegram

Follow `$HOME/.kit-bootstrap/steps/telegram.md`, with
`KB_TELEGRAM_ENV="$HOME/.hub-env"`.

The morning job reads the same two settings from the same file, so this connects
both directions at once: the 6am brief, and messaging the assistant back.

Then start the gateway:

```bash
systemctl --user enable --now hermes-gateway
systemctl --user status hermes-gateway --no-pager | head -5
```

## 7 — Prove it, do not assume it

Three things have to be true, and you check all three:

```bash
# 1. The morning job runs end to end, right now, without waiting for 6am.
bash "$HOME/brief.sh"; tail -3 "$HOME/brief.log"

# 2. The clock is set.
crontab -l | grep brief.sh

# 3. The gateway is up.
systemctl --user is-active hermes-gateway
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
