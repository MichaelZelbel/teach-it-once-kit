#!/usr/bin/env bash
# Give a hub its checked private GitHub home. The server installer calls this
# only after the starter files and secret-file ignores are in place. It also
# repairs a run where origin was added but the first push did not finish.
set -uo pipefail

hub="${1:-}"
repo_name="${2:-}"

fail() {
  printf '   stop: %s\n' "$*" >&2
  exit 1
}

[ -n "$hub" ] || fail "the hub folder was not named"
[ -d "$hub/.git" ] || fail "$hub is not a git repository"
command -v gh >/dev/null 2>&1 || fail "the GitHub tool is not installed"

origin="$(git -C "$hub" remote get-url origin 2>/dev/null || true)"

if [ -z "$origin" ]; then
  if [ -z "$repo_name" ]; then
    printf 'Name for the new private GitHub repository [hub]: '
    IFS= read -r repo_name || true
  fi
  repo_name="${repo_name:-hub}"

  case "$repo_name" in
    *[!A-Za-z0-9._-]*|'')
      fail "repository names may contain letters, numbers, dots, dashes and underscores"
      ;;
  esac
fi

if ! git -C "$hub" config user.name >/dev/null 2>&1; then
  git -C "$hub" config user.name "Hub Owner"
fi
if ! git -C "$hub" config user.email >/dev/null 2>&1; then
  git -C "$hub" config user.email "hub@localhost"
fi

if ! git -C "$hub" rev-parse --verify HEAD >/dev/null 2>&1; then
  git -C "$hub" add -A || fail "the starter files could not be prepared for the first commit"
  git -C "$hub" commit -q -m "Start my hub" \
    || fail "the first commit could not be created"
fi

branch="$(git -C "$hub" branch --show-current)"
[ -n "$branch" ] || fail "the hub has no current branch to push"

if [ -z "$origin" ]; then
  printf '   Creating the private GitHub repository %s and pushing the hub\n' "$repo_name"
  gh repo create "$repo_name" --private --source "$hub" --remote origin --push >/dev/null \
    || fail "GitHub did not create and receive the private repository '$repo_name'. No public repository was requested."
else
  printf '   Checking the private GitHub repository and its pushed branch\n'
  git -C "$hub" push -q -u origin "$branch" \
    || fail "the local branch could not be pushed to origin"
fi

git -C "$hub" ls-remote --exit-code origin "refs/heads/$branch" >/dev/null 2>&1 \
  || fail "the repository exists, but the first commit did not reach it"

# Asked from inside the hub. With no repository named, the GitHub tool reads the
# remotes of the current directory, and the installer calls this script from the
# account's home, not from the hub. Found on the 2026-09-05 end-to-end run, where
# every install stopped here with a private repository already created and pushed.
repo_check="$(cd "$hub" && gh repo view --json isPrivate,url --jq '[.isPrivate, .url] | @tsv' 2>/dev/null)" \
  || fail "the repository exists, but its privacy could not be checked from $hub"
private="${repo_check%%$'\t'*}"
url="${repo_check#*$'\t'}"
[ "$private" = "true" ] || fail "GitHub reports that $url is not private"

printf '   ok: private GitHub repository: %s\n' "$url"
printf '   ok: the first commit reached %s on branch %s\n' "$url" "$branch"
