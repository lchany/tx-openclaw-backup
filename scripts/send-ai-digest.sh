#!/bin/bash
# AI 资讯发送脚本 - 供 cron 使用
# 使用 curl 直接调用 Telegram Bot API

TELEGRAM_BOT_TOKEN="你的Bot Token"
TELEGRAM_CHAT_ID="6445835734"
DATE=$(date +%Y-%m-%d)

# 获取新闻内容
HACKER_NEWS=$(curl -s "https://news.ycombinator.com/front" 2>/dev/null | grep -o 'class="titleline"[^>]*>[^<]*' | sed 's/class="titleline"[^>]*>//' | sed 's/<[^>]*>//g' | head -3)

MESSAGE="🤖 *AI 每日资讯 - $DATE*

🔥 *今日热点*
• Anthropic Claude Opus 4.6 发布
• \"我怀念深度思考\" 引热议
• AI 正在杀死 B2B SaaS

📊 *Hacker News Top*
$HACKER_NEWS

---"

# 发送 Telegram
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d "chat_id=$TELEGRAM_CHAT_ID" \
    -d "text=$MESSAGE" \
    -d "parse_mode=Markdown" \
    -d "disable_web_page_preview=true" > /dev/null

echo "发送完成: $(date)"
