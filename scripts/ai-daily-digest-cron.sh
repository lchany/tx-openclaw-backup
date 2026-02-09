#!/bin/bash
# AI 每日新闻摘要 - 替代 OpenClaw cron 任务
# 原时间：07:35

export PATH="/home/lchych/.nvm/versions/node/v24.13.0/bin:$PATH"
export HOME="/home/lchych"

cd /home/lchych/clawd

# 执行 AI 新闻获取
openclaw agent run --message "Fetch latest AI news using web_search. Create a daily digest in Chinese with top 5 AI news + brief summaries. Use message tool to send to Telegram target 6445835734. Format: '🤖 AI Daily Digest - YYYY-MM-DD\n\n1. [标题]\n摘要...\n\n2. ...'. After sending, reply ONLY: NO_REPLY." --timeout 300 2>&1 | tee -a /home/lchych/clawd/logs/cron/ai-daily-digest.log

# 检查执行结果
if [ $? -ne 0 ]; then
    /home/lchych/clawd/scripts/cron-alert.sh "AI每日新闻" "执行失败" "/home/lchych/clawd/logs/cron/ai-daily-digest.log"
fi
