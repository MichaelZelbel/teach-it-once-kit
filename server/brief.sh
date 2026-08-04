#!/bin/bash
# Morning brief on a machine that never sleeps. Chapter 25.
#
# Install: save as ~/brief.sh, then `chmod +x ~/brief.sh`
# Schedule: `crontab -e`, then one line:   0 6 * * * /home/ai/brief.sh
#
# Secrets live OUTSIDE the folder, in ~/.hub-env, holding:
#   TELEGRAM_BOT_TOKEN=...
#   TELEGRAM_CHAT_ID=...
# Keeping them out of the folder is what stops `git add -A` committing them.

cd "$HOME/hub" || exit 1
set -a; . "$HOME/.hub-env"; set +a

TODAY=$(date +%F)
LOG="$HOME/brief.log"

git pull -q --rebase

claude -p "Run the recipe in skills/morning-brief.md. Today is $TODAY." >>"$LOG" 2>&1

# Telegram will not take a message longer than about four thousand characters, and it
# refuses it in a way that is easy to miss: the curl command still succeeds. So a brief
# that grew too long looks exactly like a brief that arrived. That is the third trap in
# this chapter wearing a different hat, so it gets the same treatment.

# Post one message and read what Telegram actually answered. Anything other than an
# "ok" is a message that never reached the phone, whatever curl thought.
send_one() {
  local answer
  answer=$(curl -s --max-time 20 -X POST \
    "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" --data-urlencode "text=$1")
  case "$answer" in
    '{"ok":true'*) return 0 ;;
    *) echo "$(date -u +'%F %T') telegram refused it: $answer" >>"$LOG"; return 1 ;;
  esac
}

# Cut the text into pieces Telegram will accept, breaking at the end of a line where
# possible so a sentence is never split in half. Fails if any piece did not get through.
send() {
  local text="$1" piece rc=0
  while [ -n "$text" ]; do
    if [ "${#text}" -le 3900 ]; then
      piece="$text"; text=""
    else
      piece="${text:0:3900}"
      case "$piece" in
        *$'\n'*) piece="${piece%$'\n'*}" ;;
        *' '*)   piece="${piece% *}" ;;
      esac
      # If breaking at a line end or a space left nothing at all - one very long
      # run of text with a space only at the very start - cut it at 3900 instead.
      # Without this the piece is empty, the text never gets shorter, and a job
      # that runs at six in the morning loops for ever.
      [ -n "$piece" ] || piece="${text:0:3900}"
      text="${text:${#piece}}"
      text="${text#$'\n'}"
    fi
    send_one "$piece" || rc=1
  done
  return $rc
}

if [ -s "brief/$TODAY.md" ]; then
  if send "$(cat "brief/$TODAY.md")"; then
    git add -A
    git commit -q -m "brief $TODAY" || true
    git push -q
    echo "$(date -u +'%F %T') sent and pushed" >>"$LOG"
  else
    # The brief was written and it is good work, so keep it even though the phone
    # never got it. Then say so, in a short message that will fit.
    git add -A
    git commit -q -m "brief $TODAY (written, not delivered)" || true
    git push -q
    send_one "Your brief was written this morning but Telegram would not take it. It is saved on the server in brief/$TODAY.md."
    echo "$(date -u +'%F %T') WRITTEN BUT NOT DELIVERED" >>"$LOG"
  fi
else
  # The most important lines in the file. Without them a broken procedure
  # looks exactly like a quiet morning, for weeks.
  send_one "Your morning brief did not run today. Something on the server needs a look."
  echo "$(date -u +'%F %T') FAILED, alert sent" >>"$LOG"
fi
