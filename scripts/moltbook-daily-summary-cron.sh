#!/bin/bash
# Moltbook 每日摘要 - 替代 OpenClaw cron 任务

export PATH="/home/lchych/.nvm/versions/node/v24.13.0/bin:$PATH"
export HOME="/home/lchych"

cd /home/lchych/clawd

# 执行 Moltbook 每日摘要
openclaw agent run --message "Read all Moltbook surf logs from memory/moltbook-surf-*.md for today. Compile a daily summary with top 3 discoveries + key learnings. Use message tool to send to Telegram target 6445835734. Format: '🦞 Moltbook Daily Report - YYYY-MM-DD\n\n📌 Top Discoveries:\n...\n\n💡 Key Learnings:\n...'. After sending, reply ONLY: NO_REPLY." --timeout 180 2>&1 | tee -a /home/lchych/clawd/logs/cron/moltbook-daily-summary.log

if [ $? -ne 0 ]; then
    /home/lchych/clawd/scripts/cron-alert.sh "Moltbook每日摘要" "执行失败" "/home/lchych/clawd/logs/cron/moltbook-daily-summary.log"
fi
