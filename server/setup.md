# Build the always-on server by hand (Chapters 25 and 26)

**You probably do not need this page.** The normal way is one line, pasted into
the server as the login you were given:

```
curl -fsSL https://raw.githubusercontent.com/MichaelZelbel/teach-it-once-kit/main/server/install.sh | bash
```

That does everything below and asks you three questions while it goes.

This page is the same thing done by hand. Two reasons to read it: you want to
know what the one line actually did, or something has broken and you are trying
to find which part. Every step here was run on a blank Ubuntu machine.

---

## 1. Rent the machine

Any small Linux server, around five euros a month. Choose Ubuntu. You get an
address and a way to log in.

## 2. Make a user that is not the boss

```
adduser ai
```

Everything after this happens as `ai`. The account you were given can destroy
the machine; your assistant does not need that. This is the same instinct as the
red lines: draw the boundary while nothing is at stake.

It matters more here than on your laptop. On your laptop the leash is a
question: it asks, you answer. On a server at three in the morning there is
nobody to answer, so the leash cannot be a question. **It has to be the walls.**

## 3. Install the assistant

```
curl -fsSL https://claude.ai/install.sh | bash
```

Run this as `ai`, not with `sudo`. It installs into the home folder of whoever
runs it, so under `sudo` it would land in root's home and your own account would
not find it.

> Older versions of this page installed Node first and then used npm. That is no
> longer needed: the installer above downloads a finished program and never
> touches Node.

## 4. Sign in with no browser on the machine

```
claude auth login
```

> **Why this and not `claude setup-token`.** Both work, and they do different
> jobs. `setup-token` gives you a long-lived token and prints it, for you to save
> yourself as `CLAUDE_CODE_OAUTH_TOKEN` in `~/.hub-env`; the morning job picks it
> up from there. That works, and it is what this page used to say. Two things
> make `auth login` the better first choice: it saves the sign-in itself, so
> there is nothing for you to copy and store, and it never puts a year-long
> credential on your screen. If you use `setup-token`, remember that on its own
> it does not sign the machine in, and save the token or nothing will run.

It tries to open a browser, fails, because there is not one, and then tells you
what to do:

> Opening browser to sign in…
>
> If the browser didn't open, visit: https://claude.com/cai/oauth/authorize?...
>
> Paste code here if prompted >

Open that address on your own computer. You get a consent screen:

> Claude Code would like to connect to your Claude chat account
>
> YOUR ACCOUNT WILL BE USED TO:
> Contribute to your Claude subscription usage

Read that middle line before approving: the server's work comes out of the
subscription you already pay for. Approve, copy the code it returns, paste it
into the waiting server.

## 5. Give the server your folder

There are two ways. **The first is easier and is what the one-line installer
does.** The second is here because some people would rather not put a GitHub
login on a rented machine at all, and that is a fair thing to want.

### 5a. The short way: sign in to GitHub with a code

Install the GitHub tool once (as the admin account, since it installs software):

```
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update && sudo apt install gh -y
```

Then, back as `ai`:

```
gh auth login --hostname github.com --git-protocol https --web --skip-ssh-key
gh auth setup-git
gh repo clone YOUR-NAME/YOUR-REPO hub
```

`gh auth login` shows a short code and a web address. Open the address on your
phone, type the code, approve. That is the whole sign-in: no token to create, no
key to paste into a website. `gh auth setup-git` is what lets `git push` work
afterwards without asking for a password.

If you have no repository yet, make one instead of cloning:

```
cd ~/hub && git init -b main && git add -A && git commit -m "My folder"
gh repo create YOUR-REPO --private --source . --push
```

### 5b. The long way: a deploy key

A deploy key opens exactly one repository and nothing else, which is why it beats
putting an account login on a server.

```
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

In your repository on GitHub: **Settings**, **Deploy keys**, **Add deploy key**.
Paste the public half, tick **Allow write access**. Then:

```
git clone git@github.com:YOUR-NAME/YOUR-REPO.git hub
```

## 6. Put the keys where the folder is not

```
nano ~/.hub-env
```

```
TELEGRAM_BOT_TOKEN=...
TELEGRAM_CHAT_ID=...
```

Then, inside the folder, a `.gitignore` containing:

```
.env*
```

Both halves. The morning job runs `git add -A`, and `git add -A` means
everything. See `three-traps.md` for what happens if you skip this.

## 7. Delivery to your phone

In Telegram, message **BotFather**, send `/newbot`, answer its two questions. It
gives you a long line of text: that is `TELEGRAM_BOT_TOKEN`. Send your new bot
any message so it is allowed to reply to you.

You do not have to hunt for your chat id. Send the bot a message first, then ask
Telegram what it saw:

```
curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates" \
  | jq -r '[ .result[]? | select(.message.chat.type=="private") | .message.chat.id ] | .[0]'
```

That number is `TELEGRAM_CHAT_ID`. Put both in `~/.hub-env`, then test:

```
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
  -d chat_id="$TELEGRAM_CHAT_ID" --data-urlencode "text=hello from my server"
```

A reply starting `{"ok":true` means delivery works. Anything else means it did
not arrive, whatever else it says.

## 8. The runner and the clock

Save `brief.sh` from this folder as `~/brief.sh`, then:

```
chmod +x ~/brief.sh
crontab -e
```

One line, meaning "at 06:00 every day":

```
0 6 * * * /home/ai/brief.sh
```

That is the whole scheduler. It has been on every Linux machine for forty years
and does not care whether you are awake.

## 9. Hermes, so it can hear you back (Chapter 26)

Everything above sends one way. Hermes is what makes it two-way.

**Check this first, before installing anything.** Hermes puts your `AGENTS.md`
into every conversation and will not take more than 20,000 characters of it. Past
that it keeps the beginning and the end and throws away the middle, with no error
and no log line. Your assistant simply stops knowing what was in the middle of
its own instructions:

```
wc -m < ~/hub/AGENTS.md
```

Under 19,000 and you have room. Over 20,000 and you must move reference material
into its own file before you go on.

```
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
hermes config set workspace ~/hub
```

Then a service, so it comes back after a reboot:

```
mkdir -p ~/.config/systemd/user
```

Write `~/.config/systemd/user/hermes-gateway.service` with the contents in
`install-hermes.sh` in this folder, then:

```
systemctl --user daemon-reload
loginctl enable-linger $(whoami)
hermes model      # choose the AI and give it your key
hermes setup      # connect Telegram
systemctl --user enable --now hermes-gateway
```

Without `enable-linger` the service stops the moment you log out, which looks
exactly like a crash and is why half of these setups die on day two.

## 10. Register it

Add the procedure to `procedures.md` in the same sitting, with the "where it
runs" line filled in properly at last: the server. In a year that line is how you
will remember which machine sends the thing.

## What a working run looks like

```
2026-07-26 18:20:44 sent and pushed
```

Cron woke it, it pulled the folder, read the context files, wrote the brief, sent
it to the phone, and pushed one file back to GitHub. Just the brief. No keys.

Two commands worth remembering afterwards:

```
systemctl --user status hermes-gateway   # is my assistant awake?
tail ~/brief.log                         # did this morning's brief go out?
```
