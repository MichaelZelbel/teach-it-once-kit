#!/usr/bin/env bash
# =============================================================================
# Teach It Once - the always-on server, in one line.
#
# Chapters 28 and 29 of the book. This puts your folder on a machine that never
# sleeps, runs Hermes there as a service that starts with the machine, puts the
# morning brief on Hermes' own clock, and leaves the messenger one command away.
#
# On the server you just rented, logged in as root, paste this:
#
#   curl -fsSL https://raw.githubusercontent.com/MichaelZelbel/teach-it-once-kit/main/server/install.sh | bash
#
# It is safe to run twice. Nothing here deletes anything.
#
# What it does on its own, first as root and then as your assistant's account:
#   - installs what the machine is missing (git, curl, xz, jq, the GitHub tool)
#   - makes a separate account for your assistant, so it is never root
#   - installs Hermes for that account, tells it where your folder will be, and
#     installs its gateway as a system service (root's one job, done once)
#   - signs Hermes in to your ChatGPT subscription with a code you type on any device
#   - fetches your folder from GitHub (a code again), or starts a fresh one
#   - wires the folder exactly the way the laptop installer does, proves Hermes
#     can read it, and schedules the morning brief on Hermes' clock, for Telegram
#
# What it asks you: which repository holds your folder, once. Plus the two codes.
# What only you can do afterwards: connect Telegram with `hermes setup`.
#
# The by-hand version of all of this is in server/setup.md, for when something
# breaks and you want to know what it did.
# =============================================================================

# Not `set -e`: the shared primitives report a failure and return, and a
# half-wired server that says WHICH half beats one that quit on the first snag.
set -uo pipefail

KB_TAG="setup"
export KB_TAG

# This script's own address. reexec_as_user re-downloads it to hand it to the
# assistant's account, because a script arriving through a pipe has no file on
# disk to re-run. Overridable so a test can hand it a local copy.
KB_SELF_URL="${KB_SELF_URL:-https://raw.githubusercontent.com/MichaelZelbel/teach-it-once-kit/main/server/install.sh}"
export KB_SELF_URL

# The pin is an immutable TAG, never the moving v2 branch, so this installer runs
# exactly the code that passed its end-to-end runs until this line is edited.
KB_PIN="v2.2"
LIB_URL="https://raw.githubusercontent.com/MichaelZelbel/kit-bootstrap/$KB_PIN/lib.sh"
KIT_REPO="https://github.com/MichaelZelbel/teach-it-once-kit.git"
AI_USER="${AI_USER:-ai}"
HUB="${HUB:-}"            # settled below: the assistant's home + /hub unless told otherwise
HUB_REPO="${HUB_REPO:-}"  # a hub you already keep on GitHub; empty means ask, or start fresh

# --- The shared groundwork ---------------------------------------------------
# Every one of our installers needs the same first hundred lines. They live in
# one repository now, so a fix reaches all of them. See kit-bootstrap/README.md.
if ! LIB="$(curl -fsSL "$LIB_URL")" || [ -z "$LIB" ]; then
  echo "Could not download the installer's shared parts from:" >&2
  echo "  $LIB_URL" >&2
  echo "Check the machine has internet, then run this again." >&2
  exit 1
fi
eval "$LIB"
unset LIB

# =============================================================================
# PHASE 1 - as root: the things only an administrator may do
# =============================================================================
if kb_is_root; then
  say "Setting up the machine"

  need_tools git curl xz jq
  ok "git, curl, xz and jq are here"

  # Installed now, as root, because the assistant's account will not be allowed
  # to install software - and that is the point of that account, not a problem
  # with it.
  ensure_gh

  say "Making an account for your assistant"
  cat <<'WHY'
   The login you were given with this machine can destroy it. Your assistant
   does not need that, and on a server there is nobody awake at 3am to ask
   "are you sure?". So it gets its own account with its own home folder, and
   the safety comes from how little that account can reach.
WHY
  if ! id -u "$AI_USER" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$AI_USER" >/dev/null \
      || die "Could not create the account '$AI_USER'."
    ok "made the account '$AI_USER'"
  else
    ok "the account '$AI_USER' is already here"
  fi
  AI_HOME="$(getent passwd "$AI_USER" | cut -d: -f6)"
  [ -n "$AI_HOME" ] && [ -d "$AI_HOME" ] || die "The account '$AI_USER' has no home folder."
  HUB="${HUB:-$AI_HOME/hub}"

  # Hermes is installed FOR the assistant's account, by root, before the account
  # takes over. Root has to be the one to install the gateway as a system service
  # a few lines down, and the service needs the binary to exist first.
  say "Installing Hermes for that account"
  HERMES_BIN="$AI_HOME/.local/bin/hermes"
  if [ -x "$HERMES_BIN" ]; then
    ok "already installed: $(su - "$AI_USER" -c "'$HERMES_BIN' --version" 2>/dev/null | head -1)"
  else
    su - "$AI_USER" -c 'curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash' >/dev/null 2>&1 \
      || die "the Hermes installer did not finish for '$AI_USER'. Run it by hand as that
   account and read what it prints:  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash"
    [ -x "$HERMES_BIN" ] || die "Hermes installed but $HERMES_BIN is not there."
    ok "installed: $(su - "$AI_USER" -c "'$HERMES_BIN' --version" 2>/dev/null | head -1)"
  fi

  # THE ORDER HERE IS LOAD-BEARING. The gateway copies terminal.cwd into its own
  # environment once, when it starts (agent/runtime_cwd.py: "bridged once ... at
  # gateway/cron startup"). A gateway started before the folder is set works in
  # the wrong place until somebody restarts it, and a Telegram message would land
  # in the assistant's home rather than the hub. So the folder's path is written
  # first, the service second, even though the folder itself arrives later.
  say "Telling Hermes where your folder will be"
  if su - "$AI_USER" -c "'$HERMES_BIN' config set terminal.cwd '$HUB'" >/dev/null 2>&1; then
    ok "hub: Hermes will work in $HUB"
  else
    warn "hub: could not set terminal.cwd for '$AI_USER'. The next phase tries again."
  fi

  say "Installing the gateway as a system service"
  cat <<'WHY'
   The clock that fires the morning brief lives inside this service, and the
   messenger answers from it. As a system service it starts when the machine
   does, with nobody logged in, and comes back after a reboot on its own.
   This is the one thing on this page that has to be done as root.
WHY
  KB_HERMES_BIN="$HERMES_BIN"
  export KB_HERMES_BIN
  kb_install_gateway "$AI_USER" || true

  # `su -` starts the next phase with a clean environment, so the choices made
  # here travel in a small file the next phase reads once and deletes.
  CARRY="$AI_HOME/.kit-bootstrap-env"
  {
    printf 'HUB=%q\n' "$HUB"
    printf 'HUB_REPO=%q\n' "$HUB_REPO"
    printf 'AI_USER=%q\n' "$AI_USER"
    printf 'KB_SKIP_HUB_PROOF=%q\n' "${KB_SKIP_HUB_PROOF:-}"
    printf 'KB_SYNC_SOURCES=%q\n' "${KB_SYNC_SOURCES:-hermes}"
  } > "$CARRY"
  chown "$AI_USER":"$AI_USER" "$CARRY"
  chmod 0600 "$CARRY"

  # Hands the rest of this script to that account and does not come back.
  reexec_as_user "$AI_USER"
fi

# =============================================================================
# PHASE 2 - as the assistant's account: everything else
# =============================================================================
if [ -f "$HOME/.kit-bootstrap-env" ]; then
  # shellcheck disable=SC1090
  . "$HOME/.kit-bootstrap-env"
  rm -f "$HOME/.kit-bootstrap-env"
fi
HUB="${HUB:-$HOME/hub}"
KIT_DIR="$HOME/teach-it-once-kit"
BOOTSTRAP_DIR="$HOME/.kit-bootstrap"
export PATH="$HOME/.local/bin:$PATH"
KB_HERMES_BIN="${KB_HERMES_BIN:-$HOME/.local/bin/hermes}"
export KB_HERMES_BIN

# If someone ran this as an ordinary user on a machine that is missing the
# basics, say the useful thing rather than failing on a permission error.
MISSING=""
for t in git curl xz jq; do
  command -v "$t" >/dev/null 2>&1 || MISSING="$MISSING $t"
done
if [ -n "$MISSING" ]; then
  PACKAGES="$(printf '%s' "$MISSING" | sed 's/\bxz\b/xz-utils/')"
  die "This machine is missing:$MISSING

   Your account is not allowed to install software, which is correct. Log out,
   log back in as the administrator account you were given with the machine,
   and run this same one-line command there. It will install these, make your
   assistant's account, and carry on by itself."
fi

say "Installing your assistant"
kb_install_hermes || die "Hermes is not on this machine and could not be installed. Read what it printed above."

# The sign-in. A device code: open the address on any device, type the code.
# The subscription is the one from Chapter 3; the server's work comes out of it.
# `hermes login` is deprecated and is never used here. A code that runs out is
# safe to repeat, and this whole script is safe to run again.
say "Signing your assistant in"
kb_hermes_signin openai-codex \
  || warn "Hermes is not signed in yet. Everything below still gets set up, and
   the folder check will say it could not check yet. When you are ready:
   $(kb_hermes_bin) auth add openai-codex --type oauth --no-browser
   then run this one line again."

# --- The kit, and the shared install code ------------------------------------
say "Getting the book's files"

fetch_repo() {
  local url="$1" dir="$2" branch="${3:-}" name="$4"
  if [ -d "$dir/.git" ]; then
    # When a pin is named, an existing clone is MOVED to it, or a server built
    # last month keeps running last month's code while this file says otherwise.
    # `git pull` cannot do that from a detached tag checkout, so fetch the ref
    # and check it out directly. Works for a tag and a branch alike.
    if [ -n "$branch" ]; then
      { git -C "$dir" fetch -q --depth 1 origin "$branch" \
          && git -C "$dir" checkout -q FETCH_HEAD; } >/dev/null 2>&1 \
        || warn "Could not update $name to $branch; using the copy already here."
    else
      git -C "$dir" pull --ff-only >/dev/null 2>&1 || warn "Could not update $name; using the copy already here."
    fi
    ok "$name updated"
  else
    if [ -n "$branch" ]; then
      git clone --depth 1 --branch "$branch" "$url" "$dir" >/dev/null 2>&1 || die "Could not download $name from $url"
    else
      git clone --depth 1 "$url" "$dir" >/dev/null 2>&1 || die "Could not download $name from $url"
    fi
    ok "$name downloaded"
  fi
}

fetch_repo "$KIT_REPO" "$KIT_DIR" "" "the book's kit"
fetch_repo "https://github.com/MichaelZelbel/kit-bootstrap.git" "$BOOTSTRAP_DIR" "$KB_PIN" "the shared install code"

[ -f "$KIT_DIR/server/install-hermes.sh" ] || die "The kit downloaded but server/install-hermes.sh is missing from it."
[ -f "$BOOTSTRAP_DIR/setup-hub.sh" ] || die "The shared install code downloaded but setup-hub.sh is missing from it."

# --- Your folder -------------------------------------------------------------
say "Your folder"

if [ -d "$HUB/.git" ]; then
  ok "a folder is already at $HUB; it will be brought up to date, not replaced"
elif [ -z "$HUB_REPO" ]; then
  cat <<'ASK'
   Chapter 18 gave your folder a private copy on GitHub. If this machine should
   fetch that copy, paste the repository's address (the one that ends in .git,
   or the https://github.com/you/name form). Press Enter to start a fresh
   folder here instead, with the book's starter rooms.
ASK
  HUB_REPO="$(ask "Which repository holds your folder" "")"
fi

if [ -n "$HUB_REPO" ] && [ ! -d "$HUB/.git" ]; then
  case "$HUB_REPO" in
    *github.com*)
      say "Connecting this machine to GitHub"
      ensure_gh_auth
      ;;
  esac
fi

# The same installer the laptop runs, from the pinned copy just fetched: the
# starter rooms (or a top-up of the folder that arrived), one visible skills room
# with the links pointing at it, terminal.cwd PROVED by a file read once a
# provider is connected, the leash, the kit's tools, and the prompt log's own
# clock. On a server the prompt log reads Hermes, because Hermes is what runs here.
say "Setting the folder up the way the laptop installer does"
SETUP_ARGS=(--hub "$HUB" --skip-prereqs --sources "${KB_SYNC_SOURCES:-hermes}")
[ -n "$HUB_REPO" ] && SETUP_ARGS+=(--repo "$HUB_REPO")
KB_BRANCH="$KB_PIN" bash "$BOOTSTRAP_DIR/setup-hub.sh" "${SETUP_ARGS[@]}" \
  || warn "the folder setup reported a problem above. Read it; everything below still runs."

# --- The keys go where the folder is not --------------------------------------
# Done BEFORE anything writes a secret. The morning job commits and pushes the
# folder, and `git add -A` means everything, so a key inside the folder travels.
say "Putting the keys where the folder is not"
umask 077
touch "$HOME/.hub-env"
chmod 600 "$HOME/.hub-env"
umask 022
if [ -d "$HUB" ]; then
  grep -qxF '.env*'    "$HUB/.gitignore" 2>/dev/null || echo '.env*'    >> "$HUB/.gitignore"
  grep -qxF '.hub-env' "$HUB/.gitignore" 2>/dev/null || echo '.hub-env' >> "$HUB/.gitignore"
fi
ok "plain keys live in $HOME/.hub-env, outside the folder, and the folder ignores any that stray in"

# --- The Hermes half: the ceiling, the folder proof, the clock ---------------
# One script, shared with readers who built the server by hand, so there is
# exactly one copy of these steps to fix. It checks the AGENTS.md ceiling, points
# Hermes at the folder and proves it with a file read, leaves the gateway to the
# system service from the root phase, and schedules the morning brief with
# --workdir (the one thing that hands a scheduled run its AGENTS.md) and
# Telegram delivery.
say "The morning brief, on Hermes' clock"
HUB="$HUB" bash "$KIT_DIR/server/install-hermes.sh" \
  || warn "the Hermes half reported a problem above. Read it before trusting the clock."

# --- The register --------------------------------------------------------------
# Nothing runs unlisted. One block, written once, if the folder has the file and
# not the block.
if [ -f "$HUB/procedures.md" ] && ! grep -q '^## Morning brief' "$HUB/procedures.md"; then
  cat >> "$HUB/procedures.md" <<REG

## Morning brief

Does: reads my profile files and writes today's brief before I start work.
Rhythm: daily, 06:00.             Lands: brief/YYYY-MM-DD.md in this folder, and my phone.
Lives: Hermes cron, the server.   Off-switch: hermes cron pause morning-brief, on the server.
Last checked: $(date +%F).
REG
  ok "register: the morning brief has its block in procedures.md"
fi

# --- What is left, and only you can do it ------------------------------------
say "What is left, and only you can do it"
cat <<NEXT

   Connect Telegram, so the brief can reach your phone and you can answer back:

        $(kb_hermes_bin) setup

      It asks for a bot token. To get one, open Telegram, message the account
      called BotFather, send /newbot and answer its two questions. It hands you
      a long line of text. That is the token. Then send your new bot any message
      so it is allowed to answer you.

   The gateway is a system service, so after Telegram is connected it needs
   one restart, as the administrator:

        sudo $(kb_hermes_bin) gateway restart --system

   Then ask Hermes itself how it is doing, from this account:

        $(kb_hermes_bin) gateway status
        $(kb_hermes_bin) cron status
        $(kb_hermes_bin) cron list

      Read the gateway's health from Hermes, not from systemctl: a cleanly
      stopped gateway shows as "failed" to systemd, so systemctl cannot tell an
      operator's stop from a crash.

   Message your bot "what is in my folder?" from your phone. If it answers,
   your assistant has a phone number, and from the next 06:00 the brief arrives
   on it by itself. Nothing is caught up: a morning the gateway was down is a
   morning with no brief.

NEXT
