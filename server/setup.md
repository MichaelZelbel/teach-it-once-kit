# Build the always-on server (Chapter 25)

From a blank Ubuntu machine to a brief on your phone. Every step below was run on a blank
machine on 2026-07-26. This is the one chapter in the book that needs a terminal.

## 1. Rent the machine

Any small Linux server, around five euros a month. Choose Ubuntu. You get an address and a way
to log in.

## 2. Make a user that is not the boss

```
adduser ai
```

Everything after this happens as `ai`. The account you were given can destroy the machine; your
assistant does not need that. This is the same instinct as the red lines: draw the boundary while
nothing is at stake.

## 3. Install Node, then the assistant

```
curl -fsSL https://deb.nodesource.com/setup_22.x -o /tmp/n.sh && bash /tmp/n.sh
apt-get install -y nodejs
npm install -g @anthropic-ai/claude-code
```

## 4. Sign in with no browser on the machine

```
claude setup-token
```

It tries to open a browser, fails, because there is not one, and then tells you what to do:

> Browser didn't open? Use the url below to sign in (c to copy)
>
> https://claude.com/cai/oauth/authorize?...
>
> Paste code here if prompted >

Open that address on your own computer. You get a consent screen:

> Claude Code would like to connect to your Claude chat account
>
> YOUR ACCOUNT WILL BE USED TO:
> Contribute to your Claude subscription usage

Read that middle line before approving: the server's work comes out of the subscription you
already pay for. Approve, copy the code it returns, paste it into the waiting server.

## 5. Give the server your folder, with a key that opens only that

```
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

In your repository on GitHub: **Settings**, **Deploy keys**, **Add deploy key**. Paste the public
half, tick **Allow write access**. A deploy key opens exactly one repository and nothing else,
which is why it beats putting an account password on a server.

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

Both halves. See `three-traps.md` for what happens if you skip this.

## 7. Delivery to your phone

In Telegram, message **BotFather**, send `/newbot`, answer its two questions. It gives you a long
line of text: that is `TELEGRAM_BOT_TOKEN`. Send your new bot any message so it is allowed to
reply to you, and put your chat id in the same file.

Test it before wiring anything else:

```
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
  -d chat_id="$TELEGRAM_CHAT_ID" --data-urlencode "text=hello from my server"
```

A reply starting `{"ok":true` means delivery works.

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

That is the whole scheduler. It has been on every Linux machine for forty years and does not
care whether you are awake.

## 9. Register it

Add the procedure to `procedures.md` in the same sitting, with the "where it runs" line filled in
properly at last: the server. In a year that line is how you will remember which machine sends
the thing.

## What a working run looks like

```
2026-07-26 18:20:44 sent and pushed
```

Cron woke it, it pulled the folder, read the context files, wrote the brief, sent it to the
phone, and pushed one file back to GitHub. Just the brief. No keys.
