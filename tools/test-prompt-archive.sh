#!/usr/bin/env bash
# The prompt collector: what must never reach a repository, and what must never be missed.
#
# WHY THIS FILE IS HERE AND NOT IN A HUB. The two programs in tools/ are what the book means
# by "a program fills it". They used to live in one person's private hub, and so did their
# tests. Since 2026-08-10 there is one copy of each, here, in the kit that readers install
# from, so the tests live beside the thing they test.
#
# TWO RISKS NOTHING ELSE IN THE KIT HAS. The collector WRITES, and what it writes comes from
# outside: years of conversation logs.
#
#   1. A secret written into a repository. Conversation logs are the one place a pasted key or
#      a client's name turns up by accident, and a repository is forever. Checks 11 to 14 are
#      that, and check 13 matters most: a line that still looks like a credential after
#      scrubbing must be DROPPED, never half-cleaned. Losing one prompt costs nothing.
#   2. A source that quietly reaches none of the drawer. Checks 24 to 28 are that.
#
# Usage: bash tools/test-prompt-archive.sh
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
ARC="$HERE/hub-prompt-archive"
PY_BIN="${PYTHON:-python3}"; command -v "$PY_BIN" >/dev/null 2>&1 || PY_BIN=python
PY="$PY_BIN"
PASS=0; FAIL=0
ok()  { echo "  ok   $1"; PASS=$((PASS+1)); }
bad() { echo "  FAIL $1"; FAIL=$((FAIL+1)); [ -n "${2:-}" ] && echo "       $2"; }

W="$HERE/.tmp-archive-test.$$"; rm -rf "$W"; mkdir -p "$W/memory" "$W/home"
trap 'rm -rf "$W"' EXIT
# Point the bot reader at nothing, for every case that is not about it. On a machine that runs
# bots this suite would otherwise find the REAL ones and archive real chats into a throwaway
# folder. Cases 24 onward set this to their own fixture. A test that reads live data is not a
# test.
export HUB_HERMES_HOME="$W/no-hermes"

echo "== the prompt archive: what must never reach the repository =="

mkdir -p "$W/home/.claude/projects/proj" "$W/home/.hub"
J="$W/home/.claude/projects/proj/s.jsonl"
w() { printf '%s\n' "$1" >> "$J"; }
w '{"type":"user","timestamp":"2026-07-01T10:00:00Z","message":{"content":"Rewrite the landing page headline, shorter and less salesy."}}'
w '{"type":"user","timestamp":"2026-07-01T10:01:00Z","message":{"content":"here is the key sk-abcdefghijklmnop1234567890 use it"}}'
w '{"type":"user","timestamp":"2026-07-01T10:02:00Z","message":{"content":"token ghp_ABCDEFGHIJKLMNOPQRSTUVWXYZ012345"}}'
w '{"type":"user","timestamp":"2026-07-01T10:03:00Z","message":{"content":"mail me at someone@example.com about it"}}'
w '{"type":"user","timestamp":"2026-07-01T10:04:00Z","message":{"content":"The client is Umbrella Consolidated and they want a demo."}}'
w '{"type":"user","timestamp":"2026-07-01T10:05:00Z","message":{"content":[{"type":"tool_result","content":"total 48\ndrwxr-xr-x 1 x"}]}}'
w '{"type":"user","timestamp":"2026-07-01T10:06:00Z","message":{"content":"Authorization: Bearer aVeryLongLivedSecret0123456789abcdef"}}'
# A credential shape nothing above matches by name. The last-resort guard must DROP this
# whole line rather than store a partly-cleaned version of it.
w '{"type":"user","timestamp":"2026-07-01T10:07:00Z","message":{"content":"use this value Xq7ZmP2vLd8RtY4wNb1CfH6jGk3sVe9AuQ5oIrTzB0xM as the credential"}}'
printf 'Umbrella Consolidated\n' > "$W/home/.hub/redact.txt"

( export HOME="$W/home" HUB_HOME="$W/home"; cd "$W" && "$PY" "$ARC" --hub "$W" archive ) >"$W/arc.out" 2>&1
A="$(cat "$W/prompts/archive/"*.jsonl 2>/dev/null)"

# 11. The ordinary prompt is kept. An archive that keeps nothing is safe and useless.
echo "$A" | grep -q "less salesy" && ok "11 an ordinary prompt is archived" || bad "11 nothing was archived" "$(cat "$W/arc.out")"

# 12. Key-shaped text never reaches the repo, in any of its shapes.
LEAK=""
for pat in 'sk-abcdefghijklmnop' 'ghp_ABCDEFGHIJKLMNOP' 'someone@example.com' 'aVeryLongLivedSecret'; do
  echo "$A" | grep -q "$pat" && LEAK="$LEAK $pat"
done
[ -z "$LEAK" ] && ok "12 no key, token, bearer or email survived into the repo" \
                || bad "12 A SECRET REACHED THE REPOSITORY:$LEAK"

# 13. Half-cleaning is the dangerous outcome, so a still-risky line is dropped whole.
grep -q "dropped" "$W/arc.out" && ok "13 a line that still looked like a credential was dropped, not patched" \
                              || bad "13 nothing was dropped, so the last-resort guard never fired" "$(cat "$W/arc.out")"

# 14. The name list is what protects his employer and clients, and it is kept OUTSIDE the repo.
echo "$A" | grep -qi "Umbrella Consolidated" && bad "14 a named party reached the repository" \
  || ok "14 a name from the local list was stripped"

# 15. A tool result is not a prompt. This is the 24,590 that made the archive look impossible.
echo "$A" | grep -q "drwxr-xr-x" && bad "15 a tool result was archived as if he had typed it" \
  || ok "15 tool results are not mistaken for prompts"

# 16. Harvesting again must add nothing, because this runs on a schedule.
B1=$(cat "$W/prompts/archive/"*.jsonl | wc -l)
( export HOME="$W/home" HUB_HOME="$W/home"; cd "$W" && "$PY" "$ARC" --hub "$W" archive ) >/dev/null 2>&1
B2=$(cat "$W/prompts/archive/"*.jsonl | wc -l)
[ "$B1" = "$B2" ] && ok "16 harvesting twice adds nothing" || bad "16 the archive duplicated itself" "$B1 -> $B2"

# 17. Search has to find it, from any machine, or the whole archive is write-only.
( export HOME="$W/home" HUB_HOME="$W/home"; "$PY" "$ARC" --hub "$W" search salesy ) 2>&1 | grep -q "less salesy" \
  && ok "17 search finds an archived prompt" || bad "17 search could not find what was archived"

# 18. A miss is a checked absence, said out loud, never silence.
( export HOME="$W/home" HUB_HOME="$W/home"; "$PY" "$ARC" --hub "$W" search zzzznotpresent ) 2>&1 | grep -qi "checked absence" \
  && ok "18 a search miss says it is a checked absence" || bad "18 a miss said nothing useful"

# --- 19 to 21: what he types on his PHONE, and the drawer's own front door -------------
#
# WHY THESE THREE EXIST. On 2026-08-09 the Telegram drawer was empty and looked fine. The
# reader filtered on a "role" field; the live transcript on the server has no role field, it
# has {"dir": "in"|"out"}. So the filter matched nothing, on every line, for as long as it had
# existed: 155 prompts typed from a phone, skipped in silence. The path was
# compiled into the code, so no test could ever have reached it. It is an env var now, and
# these are the tests that were impossible before.
TG="$W/transcript.jsonl"
cat > "$TG" <<'EOF'
{"ts": "2026-08-01T09:00:00", "dir": "in", "text": "remind me to book the dentist tomorrow morning"}
{"ts": "2026-08-01T09:00:30", "dir": "out", "text": "the bot answering him about the dentist"}
{"ts": "2026-08-01T09:01:00", "role": "user", "text": "and add milk to the shopping list"}
EOF
( export HOME="$W/home" HUB_HOME="$W/home" HUB_TELEGRAM_TRANSCRIPT="$TG"; cd "$W" && "$PY" "$ARC" --hub "$W" archive ) >"$W/tg.out" 2>&1
T="$(cat "$W/prompts/archive/"*.jsonl 2>/dev/null)"

# 19. The shape the real file actually has. This is the bug itself, held shut.
echo "$T" | grep -q "book the dentist" && ok "19 a Telegram line marked dir:in is archived" \
  || bad "19 the Telegram transcript was skipped again" "$(cat "$W/tg.out")"

# 20. His side only. Archiving the bot's replies would fill the drawer with our own words, so
#     every search would return the answer instead of the question he asked.
echo "$T" | grep -q "the bot answering him" && bad "20 the bot's own reply was archived as a prompt" \
  || ok "20 the bot's side of the chat is not archived"

# 21. The other shape still works, so a future transcript format cannot silently drop his words.
echo "$T" | grep -q "add milk" && ok "21 a line marked role:user is still archived" \
  || bad "21 the role-shaped line stopped being read"

# 22. The drawer's own README explains the drawer to a human. It is not a prompt, and counting
#     it as one would put the explanation in every search result.
mkdir -p "$W/prompts/library"
saved_count() { ( export HOME="$W/home" HUB_HOME="$W/home"; "$PY" "$ARC" --hub "$W" stats ) 2>&1 \
  | sed -n 's/^saved prompts *\([0-9]*\).*/\1/p'; }
S1=$(saved_count)
printf '# The shelf\n\nAn explanation, not a prompt. It mentions salesy on purpose.\n' > "$W/prompts/library/README.md"
S2=$(saved_count)
[ -n "$S1" ] && [ "$S1" = "$S2" ] && ok "22 a drawer README is not counted as a saved prompt" \
  || bad "22 the README was counted as a prompt" "before=$S1 after=$S2"

# 22b. And it must not turn up as a search hit either, or the explanation of the drawer starts
#      answering questions about its contents.
( export HOME="$W/home" HUB_HOME="$W/home"; "$PY" "$ARC" --hub "$W" search salesy ) 2>&1 | grep -q "README" \
  && bad "22b the drawer README came back as a search hit" \
  || ok "22b the drawer README is not a search hit"

# 23. Rescrub is what makes the name list useful, because a name is always added too late.
printf 'Umbrella Consolidated\n' > "$W/home/.hub/redact.txt" 2>/dev/null || { mkdir -p "$W/home/.hub"; printf 'Umbrella Consolidated\n' > "$W/home/.hub/redact.txt"; }
printf '{"id":"deadbeefdeadbeef","at":"2026-07-01T10:00:00","machine":"test","tool":"claude-code","project":"","text":"a note about Umbrella Consolidated and its billing"}\n' >> "$W/prompts/archive/test-2026-07.jsonl"
( export HOME="$W/home" HUB_HOME="$W/home"; "$PY" "$ARC" --hub "$W" rescrub ) >"$W/rs.out" 2>&1
grep -qi "Umbrella Consolidated" "$W/prompts/archive/test-2026-07.jsonl" \
  && bad "23 rescrub left a named party in a prompt that was already stored" "$(cat "$W/rs.out")" \
  || ok "23 rescrub cleans a name out of what was already archived"

# --- 24 to 28: EVERY bot he talks to, not the one bot somebody plumbed ------------------
#
# WHY THESE FIVE EXIST. On 2026-08-10 the drawer held what he had typed to one bot, the hub
# bot, and to none of the other eight running beside it on the same server. Claire on the
# Pattern Lab board, the health advisor, three Ownward Studio desks: 281 prompts, thrown away,
# with every guard green, because the guards counted machines and the server was contributing.
# The cause was that the one bot was reached through a file a separate nightly job wrote for
# it, so covering a bot was a thing somebody had to remember to do, once per bot, for ever.
# The reader now goes to the store the bots write themselves. These cases hold that shut.
HH="$W/hermes"; mkdir -p "$HH/profiles/claire" "$HH/profiles/quiet-desk"
"$PY" - "$HH" <<'PYEOF'
import sqlite3, sys, os
hh = sys.argv[1]
def bot(name, rows):
    con = sqlite3.connect(os.path.join(hh, "profiles", name, "state.db"))
    con.execute("CREATE TABLE sessions (id TEXT, source TEXT)")
    con.execute("CREATE TABLE messages (session_id TEXT, role TEXT, content TEXT, timestamp REAL)")
    for sid, src in {(r[0], r[1]) for r in rows}:
        con.execute("INSERT INTO sessions VALUES (?,?)", (sid, src))
    for sid, _src, role, txt in rows:
        con.execute("INSERT INTO messages VALUES (?,?,?,?)", (sid, role, txt, 1785875150.0))
    con.commit(); con.close()

bot("claire", [
    ("s1", "telegram",   "user",      "what is the board deciding about the video script"),
    ("s1", "telegram",   "assistant", "Claire replying about the video script"),
    ("s1", "telegram",   "user",      "[Sam] and show me the actual script this time"),
    ("s1", "telegram",   "user",      "[WORK ORDER from the company - this is NOT a message from the founder.] do the thing"),
    ("s2", "api_server", "user",      "You are board desk, an AI agent employee in a company"),
])
bot("quiet-desk", [
    ("s3", "telegram",   "user",      "a prompt typed to a desk nobody ever plumbed"),
])
PYEOF

( export HOME="$W/home" HUB_HOME="$W/home" HUB_HERMES_HOME="$HH" HUB_TELEGRAM_TRANSCRIPT="$W/none.jsonl"
  cd "$W" && "$PY" "$ARC" --hub "$W" archive ) >"$W/bots.out" 2>&1
B="$(cat "$W/prompts/archive/"*.jsonl 2>/dev/null)"

# 24. The bug itself: a bot with no file of its own is read anyway.
echo "$B" | grep -q "what is the board deciding" \
  && ok "24 what you typed to a bot with no transcript file is archived" \
  || bad "24 a bot's chat was skipped again" "$(cat "$W/bots.out")"

# 25. And it says WHICH bot, because "telegram" alone cannot answer "what did I ask Claire".
echo "$B" | grep -q '"project": *"claire"' \
  && ok "25 the archived prompt names the bot you said it to" \
  || bad "25 the bot's name was not recorded"

# 26. A courier work order wears his role in the same table. It is our own machinery talking,
#     and archiving it would make every search return our words instead of his.
echo "$B" | grep -q "WORK ORDER" && bad "26 a work order from our own machinery was archived as his prompt" \
  || ok "26 a message our machinery injected is not archived"

# 27. The bot's own side, and the sessions where the hub gives the bot work, stay out too.
echo "$B" | grep -qE "Claire replying|You are board desk" \
  && bad "27 the bot's replies or its work sessions were archived as prompts" \
  || ok "27 only his side of a real chat is archived"

# 28. The guard that would have caught all of this: a source with prompts in it and none of
#     them archived must FAIL, by name. Counting machines could never see this.
rm -f "$W/prompts/archive/"*.jsonl
( export HOME="$W/home" HUB_HOME="$W/home" HUB_HERMES_HOME="$HH" HUB_TELEGRAM_TRANSCRIPT="$W/none.jsonl"
  "$PY" "$ARC" --hub "$W" sources ) >"$W/src.out" 2>&1
SRC_RC=$?
[ "$SRC_RC" -ne 0 ] && grep -q "telegram/claire" "$W/src.out" \
  && ok "28 sources fails and names the bot whose prompts reach none of the archive" \
  || bad "28 an entirely unarchived source was reported as healthy" "rc=$SRC_RC $(cat "$W/src.out")"

echo
echo "  $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
