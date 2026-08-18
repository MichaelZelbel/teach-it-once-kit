#!/usr/bin/env bash
# The two sync arrows and their runner: what must stay quiet, and what must never happen.
#
# WHY THIS FILE IS HERE. tools/notebook-sync.py, tools/world-pull.py and hub-notebook-sync
# are what Chapter 24 means by the notebook keeping itself current. They run unattended,
# on a schedule, on machines whose owner never asked to see them, and that shape carries
# two promises the rest of the kit does not:
#
#   1. A reader WITHOUT a notebook must never see an error from them. Most readers never
#      connect one, and a scheduled job that complains daily about a thing you never asked
#      for is how a kit gets uninstalled. Checks 8 and 9 are that.
#   2. The runner must never push. Pulling keeps an idle machine fresh; pushing is a
#      decision, and a schedule must not make decisions. Check 7 is that.
#
# Usage: bash tools/test-notebook-sync.sh
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
PY="${PYTHON:-python3}"
command -v "$PY" >/dev/null 2>&1 && "$PY" -c "pass" >/dev/null 2>&1 || PY=python
"$PY" -c "pass" >/dev/null 2>&1 || { echo "no working python, cannot test"; exit 0; }
PASS=0; FAIL=0
ok()  { echo "  ok   $1"; PASS=$((PASS+1)); }
bad() { echo "  FAIL $1"; FAIL=$((FAIL+1)); [ -n "${2:-}" ] && echo "       $2"; }

W="$HERE/.tmp-notebook-test.$$"; rm -rf "$W"; mkdir -p "$W"
trap 'rm -rf "$W"' EXIT

echo "== the notebook sync: quiet for most readers, honest for the rest =="

# 1 + 2. Both programs are valid Python. A syntax error here ships to every reader.
for f in notebook-sync.py world-pull.py; do
  if "$PY" -c "import ast,sys; ast.parse(open(sys.argv[1], encoding='utf-8').read())" "$HERE/$f" 2>"$W/err"; then
    ok "$f is valid Python"
  else
    bad "$f does not parse" "$(cat "$W/err")"
  fi
done

# 3 + 4. --help answers and exits 0, which is the smallest proof each program starts.
for f in notebook-sync.py world-pull.py; do
  if "$PY" "$HERE/$f" --help >/dev/null 2>"$W/err"; then
    ok "$f --help answers"
  else
    bad "$f --help failed" "$(cat "$W/err")"
  fi
done

# 5 + 6. The runner and the credential helper parse as shell.
for f in hub-notebook-sync hub-notebook-env; do
  if bash -n "$HERE/$f" 2>"$W/err"; then
    ok "$f parses as shell"
  else
    bad "$f does not parse" "$(cat "$W/err")"
  fi
done

# 7. The runner never pushes. It pulls to stay fresh; pushing stays a decision a person
# makes, never something a schedule does.
if [ "$(grep -Ec 'git +push' "$HERE/hub-notebook-sync")" = "0" ]; then
  ok "the runner never contains git push"
else
  bad "THE RUNNER PUSHES, which turns a schedule into a decision-maker"
fi

# 8. No hub recorded on this computer: silent, exit 0. This is most readers' machines
# before the installer runs, and any output here becomes a daily complaint.
mkdir -p "$W/home-empty/.hub"
rc=0; out="$(HOME="$W/home-empty" MENERIO_API_KEY="" sh "$HERE/hub-notebook-sync" 2>&1)" || rc=$?
if [ "$rc" = "0" ] && [ -z "$out" ]; then
  ok "no hub recorded: exit 0 and not a word"
else
  bad "a reader with no hub saw something (exit $rc)" "$out"
fi

# 9. A hub but no notebook: silent, exit 0. This is most readers' machines forever.
mkdir -p "$W/home-nokey/.hub" "$W/hub-nokey"
printf 'HUB_DIR=%s\n' "$W/hub-nokey" > "$W/home-nokey/.hub/device.env"
rc=0; out="$(HOME="$W/home-nokey" MENERIO_API_KEY="" sh "$HERE/hub-notebook-sync" 2>&1)" || rc=$?
if [ "$rc" = "0" ] && [ -z "$out" ]; then
  ok "no notebook connected: exit 0 and not a word"
else
  bad "a reader without a notebook saw something (exit $rc)" "$out"
fi

# 10 to 13. The dry run keeps the book's promise, offline: "It sends observations/,
# skills/, and each decision in decisions.md as its own entry. It does not send
# profile/ or AGENTS.md." No key and no --apply, so nothing leaves the machine.
mkdir -p "$W/hub/observations" "$W/hub/skills" "$W/hub/profile"
printf 'You proofread before sending.\n' > "$W/hub/observations/quirk.md"
printf '# Plan my day\n'                 > "$W/hub/skills/plan-my-day.md"
printf '# About me\n'                    > "$W/hub/profile/about-me.md"
printf '# Manual\n'                      > "$W/hub/AGENTS.md"
cat > "$W/hub/decisions.md" <<'DECEOF'
# Decisions

- (2026-01-05) Chose one AI subscription instead of two, because the best
  tool is the one I open daily.
- 2026-02-11 Named the folder hub, so every tool calls it the same thing.

## 2026-03-01 Moved the notebook key
Why: one key, one off-switch.
DECEOF

plan="$(MENERIO_API_KEY="" "$PY" "$HERE/notebook-sync.py" --repo-root "$W/hub" 2>&1)"

echo "$plan" | grep -q "would create observations/quirk.md" \
  && ok "observations/ is sent" || bad "observations/ was not in the plan" "$plan"
echo "$plan" | grep -q "would create skills/plan-my-day.md" \
  && ok "skills/ is sent" || bad "skills/ was not in the plan" "$plan"

n="$(echo "$plan" | grep -c "would create decisions.md#")"
if [ "$n" = "3" ]; then
  ok "each decision is its own entry: two bullets and a heading make three"
else
  bad "expected 3 decision entries, the plan holds $n" "$plan"
fi

if echo "$plan" | grep -q "profile/\|AGENTS.md"; then
  bad "profile/ or AGENTS.md reached the plan, and the book promises they never do" "$plan"
else
  ok "profile/ and AGENTS.md are not sent"
fi

echo
echo "  $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
