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

send() {
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" --data-urlencode "text=$1" >/dev/null
}

if [ -s "brief/$TODAY.md" ]; then
  send "$(cat "brief/$TODAY.md")"
  git add -A
  git commit -q -m "brief $TODAY" || true
  git push -q
  echo "$(date -u +'%F %T') sent and pushed" >>"$LOG"
else
  # The most important four lines in the file. Without them a broken
  # procedure looks exactly like a quiet morning, for weeks.
  send "Your morning brief did not run today. Something on the server needs a look."
  echo "$(date -u +'%F %T') FAILED, alert sent" >>"$LOG"
fi
