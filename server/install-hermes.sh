#!/bin/bash
# Give your assistant a phone number.
#
# Chapter 28 put your assistant on a machine that never sleeps, and it can send
# you a brief every morning. What it cannot do is hear you. This script fixes
# that. It installs Hermes, an agent that reads the same folder your assistant
# already uses and answers you on Telegram, so you can hand it a job while you
# are standing at a bus stop.
#
# YOU PROBABLY DO NOT NEED TO RUN THIS ON ITS OWN. The one-line installer in
# this folder covers Chapters 28 and 29 together, and does everything below as
# part of it:
#
#     curl -fsSL https://raw.githubusercontent.com/MichaelZelbel/teach-it-once-kit/main/server/install.sh | bash
#
# This script stays for two cases: you already built the server by hand and only
# want the Hermes half, or something broke and you want to run just this part
# again. It is the same steps, in the same order.
#
# Run it as the `ai` user you made in Chapter 28, never as root:
#
#     bash install-hermes.sh
#
# It is safe to run twice. Nothing here is destructive, and every step says what
# it is doing before it does it.

set -uo pipefail

HUB="${HUB:-$HOME/hub}"
BRAIN="$HUB/AGENTS.md"

# Hermes reads a profile file up to this many characters and no further.
CEILING=20000
SAFE=19000

say()  { printf '\n== %s\n' "$1"; }
ok()   { printf '   ok: %s\n' "$1"; }
warn() { printf '   ATTENTION: %s\n' "$1"; }
die()  { printf '\n   STOPPED: %s\n\n' "$1" >&2; exit 1; }

# --------------------------------------------------------------------------
say "Checking where you are running this"

[ "$(id -u)" -eq 0 ] && die "You are root. Chapter 28 gave your assistant its own
   account for a reason: the account you log in with can destroy the machine, and
   your assistant does not need that. Log in as that user and run this again."

[ -d "$HUB" ] || die "No folder at $HUB. That folder is your assistant's memory,
   the one Chapter 28 put on this machine. Set HUB=/path/to/it and run this again."

ok "running as $(whoami), folder found at $HUB"

# --------------------------------------------------------------------------
# THE CEILING NOBODY TELLS YOU ABOUT.
#
# Hermes puts your AGENTS.md into every single conversation, and it will not take
# more than 20,000 characters of it. Past that it keeps the beginning and the end
# and throws away the MIDDLE. No error. No line in any log. The agent is not told
# either, so it cannot mention it. Your assistant simply stops knowing whatever
# was in the middle of its own instructions, and from the outside it just looks
# like it got worse at its job.
#
# This is checked first, before anything is installed, because it is the single
# most expensive thing on this page to learn the hard way.
say "Checking your instructions still fit"

if [ -f "$BRAIN" ]; then
  N=$(wc -m < "$BRAIN" | tr -d ' ')
  if [ "$N" -ge "$CEILING" ]; then
    die "AGENTS.md is $N characters. Hermes reads the first 14,000 and the last
   4,000 and silently drops the $((N - 18000)) in between, so your assistant would
   run with a hole in its instructions and no way to know. Move reference material
   into its own file, leave a pointer to it, and get this under $SAFE characters."
  elif [ "$N" -ge "$SAFE" ]; then
    warn "AGENTS.md is $N characters. It still fits, but it is only $((CEILING - N))
   from the point where Hermes starts dropping the middle of it without telling
   anyone. Move something out before you add anything."
  else
    ok "AGENTS.md is $N characters, $((SAFE - N)) below the line"
  fi
else
  warn "no AGENTS.md in $HUB yet. Hermes will still run; it just will not know
   anything about you until you write one."
fi

# --------------------------------------------------------------------------
# WHAT THE MACHINE NEEDS BEFORE HERMES WILL GO ON.
#
# Hermes brings almost everything with it: it downloads its own Python and its
# own package tool. Two things it cannot bring are curl and git, because they
# have to be installed by the administrator of the machine.
#
# And here is the part that catches people. Chapter 28 gave your assistant its
# own account ON PURPOSE, with no power to install software. That is the whole
# point of that account. So when the Hermes installer notices git is missing and
# tries `sudo apt install git`, it is refused, exactly as it should be. Nothing
# is broken. It just means the one apt command belongs to you, in your own
# admin account, before you run this.
say "Checking what the machine already has"

# On a normal Ubuntu server all three of these are already there, so this check
# usually just passes and you never think about it again. It exists because when
# one of them IS missing the failure is unreadable: the Hermes installer gets
# most of the way in and then prints "tar (child): xz: Cannot exec", which tells
# you nothing about what to do. One clear sentence now beats that later.
MISSING=""
for tool in curl git xz; do
  command -v "$tool" >/dev/null 2>&1 || MISSING="$MISSING $tool"
done
# xz lives in a package with a different name, which is its own small trap.
PACKAGES="$(printf '%s' "$MISSING" | sed 's/\bxz\b/xz-utils/')"

if [ -n "$MISSING" ]; then
  die "this machine is missing:$MISSING

   Your assistant's account is not allowed to install software, which is correct
   and is why Chapter 28 made it that way. Log out, log back in as the admin
   account you were given with the machine, and run this one line:

       sudo apt update && sudo apt install -y$PACKAGES

   Then log back in as $(whoami) and run this script again."
fi
ok "curl, git and xz are all here"

# --------------------------------------------------------------------------
say "Installing Hermes"

if command -v hermes >/dev/null 2>&1; then
  ok "already installed: $(hermes --version 2>&1 | head -1)"
else
  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash \
    || die "the installer did not finish. Read what it printed above; it is
   usually a missing build tool, and it names the one it wants."
fi

# Find it by its real path. On a fresh machine Hermes installs into
# ~/.local/bin, which your own shell adds to PATH but cron and systemd do NOT.
# A script that just says `hermes` works when you test it by hand and fails
# every time at three in the morning. So the full path is resolved once, here,
# and written into the service below.
HERMES="$(command -v hermes 2>/dev/null || echo "$HOME/.local/bin/hermes")"
[ -x "$HERMES" ] || die "Hermes is installed but I cannot find the program.
   Look for it with:  ls -l ~/.local/bin/hermes"
ok "found at $HERMES"

# --------------------------------------------------------------------------
say "Pointing Hermes at your folder"

"$HERMES" config set workspace "$HUB" >/dev/null 2>&1 \
  && ok "workspace set to $HUB" \
  || warn "could not set the workspace automatically. Do it yourself with:
   $HERMES config set workspace $HUB"

# --------------------------------------------------------------------------
say "Making it start again after a reboot"

UNIT="$HOME/.config/systemd/user/hermes-gateway.service"
mkdir -p "$(dirname "$UNIT")"
cat > "$UNIT" <<UNITFILE
[Unit]
Description=Hermes gateway - the assistant that answers your messages
After=network-online.target

[Service]
Type=simple
WorkingDirectory=$HUB
ExecStart=$HERMES gateway
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
UNITFILE
ok "wrote $UNIT"

systemctl --user daemon-reload >/dev/null 2>&1
# Without lingering, a user service stops the moment you log out, which looks
# exactly like a crash and is the reason half of these setups die on day two.
if loginctl enable-linger "$(whoami)" >/dev/null 2>&1; then
  ok "this account may now keep programs running while you are logged out"
else
  warn "could not turn on lingering. Ask whoever owns the machine to run:
   sudo loginctl enable-linger $(whoami)
   Without it the assistant stops when you close your terminal."
fi

# --------------------------------------------------------------------------
say "What is left, and only you can do it"

cat <<NEXT
   Two things need answers that are yours, so this script does not guess them.

   1. Choose which AI does the thinking, and give it your key:

        $HERMES model

   2. Connect Telegram, so it can hear you:

        $HERMES setup

      It asks for a bot token. To get one, open Telegram, message the account
      called BotFather, send /newbot and answer its two questions. It hands you
      a long line of text. That is the token. Then send your new bot any message
      so it is allowed to answer you.

   When both are done, switch it on:

        systemctl --user enable --now hermes-gateway
        systemctl --user status hermes-gateway

   Then message your bot "what is in my folder?" from your phone. If it answers,
   your assistant has a phone number.

NEXT
