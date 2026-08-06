#!/usr/bin/env bash
# =============================================================================
# Teach It Once - the always-on server, in one line.
#
# Chapters 25 and 26 of the book. This puts your folder on a machine that never
# sleeps, sends you a brief every morning, and lets you message your assistant
# from your phone.
#
# On the server you just rented, logged in as root, paste this:
#
#   curl -fsSL https://raw.githubusercontent.com/MichaelZelbel/teach-it-once-kit/main/server/install.sh | bash
#
# It is safe to run twice. Nothing here deletes anything.
#
# What it does on its own:
#   - installs what the machine is missing (git, curl, the GitHub tool)
#   - makes a separate account for your assistant, so it is never root
#   - installs Claude Code and signs it in
#   - signs in to GitHub with a one-time code
#   - then hands over to a conversation that asks you the rest
#
# What it will ask you (and nothing else):
#   1. Which of your GitHub repositories holds your folder - or shall it make one
#   2. Which AI should answer your messages, and its key
#   3. Whether to connect Telegram, and your bot token
#
# What it deliberately does NOT ask for: a personal access token, an SSH deploy
# key, or your Telegram chat id. The first two are replaced by signing in with a
# code; the third it works out by itself.
#
# The by-hand version of all of this is in server/setup.md, for when something
# breaks and you want to know what it did.
# =============================================================================

set -euo pipefail

KB_TAG="setup"
export KB_TAG

# This script's own address. reexec_as_user re-downloads it to hand it to the
# assistant's account, because a script arriving through a pipe has no file on
# disk to re-run.
KB_SELF_URL="https://raw.githubusercontent.com/MichaelZelbel/teach-it-once-kit/main/server/install.sh"
export KB_SELF_URL

LIB_URL="https://raw.githubusercontent.com/MichaelZelbel/kit-bootstrap/v1/lib.sh"
KIT_REPO="https://github.com/MichaelZelbel/teach-it-once-kit.git"
KIT_DIR="$HOME/teach-it-once-kit"
BOOTSTRAP_DIR="$HOME/.kit-bootstrap"
HUB="${HUB:-$HOME/hub}"
AI_USER="${AI_USER:-ai}"

# --- The shared groundwork ---------------------------------------------------
# Every one of our installers needs the same first hundred lines. They live in
# one repository now, so a fix reaches all of them. See kit-bootstrap/README.md.
if ! LIB="$(curl -fsSL "$LIB_URL")"; then
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

  # Hands the rest of this script to that account and does not come back.
  reexec_as_user "$AI_USER"
fi

# =============================================================================
# PHASE 2 - as the assistant's account: everything else
# =============================================================================

# If someone ran this as an ordinary user on a machine that is missing the
# basics, say the useful thing rather than failing on a permission error.
MISSING=""
for t in git curl xz jq gh; do
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
ensure_claude_code
ensure_claude_signin

say "Connecting this machine to GitHub"
ensure_gh_auth

# --- The kit, and the shared question sheets ---------------------------------
say "Getting the book's files"

fetch_repo() {
  local url="$1" dir="$2" branch="${3:-}" name="$4"
  if [ -d "$dir/.git" ]; then
    git -C "$dir" pull --ff-only >/dev/null 2>&1 || warn "Could not update $name; using the copy already here."
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
fetch_repo "https://github.com/MichaelZelbel/kit-bootstrap.git" "$BOOTSTRAP_DIR" "v1" "the shared question sheets"

[ -f "$KIT_DIR/server/brief.sh" ] || die "The kit downloaded but server/brief.sh is missing from it."
[ -f "$BOOTSTRAP_DIR/steps/telegram.md" ] || die "The question sheets downloaded but steps/telegram.md is missing."

# Let the assistant work without asking permission for every single step. This is
# the chapter's own lesson applied to the install: on a server a question is a
# refusal, so the safety is the account, not the asking.
KB_PERMISSION_PROFILE="$BOOTSTRAP_DIR/settings/server-profile.json"

# --- Hand over ---------------------------------------------------------------
mkdir -p "$HUB"

PROMPT="Set up this always-on server for me, following Chapters 25 and 26 of the book Teach It Once. \
Read and follow $KIT_DIR/server/steps/build-the-server.md from the top. It tells you which question \
sheets to use and in what order; the shared ones are in $BOOTSTRAP_DIR/steps/. \
My folder should end up at $HUB, my settings file at $HOME/.hub-env, and the kit you can copy files \
from is at $KIT_DIR. Claude Code and the GitHub tool are both already signed in on this machine, so \
never ask me for a GitHub token or an SSH key. Ask me one question at a time and stop the turn after \
each one so I know it is my turn. When everything is done, do not tell me it is working until a test \
message has actually arrived on my phone and I have confirmed it."

handoff "$PROMPT" "$HUB"
