#!/bin/bash
# 定时任务失败告警脚本
# 用法: cron-alert.sh "任务名称" "错误信息"

TASK_NAME="$1"
ERROR_MSG="$2"
LOG_FILE="$3"

# Telegram 配置
BOT_TOKEN="8104939902:AAG_xvcBjipQ8SRVwdZ6aJ2YAWUFWSYxn4M"
CHAT_ID="6445835734"

# 构建消息
MESSAGE="⚠️ 定时任务失败告警

任务: ${TASK_NAME}
时间: $(date '+%Y-%m-%d %H:%M:%S')
错误: ${ERROR_MSG}

${LOG_FILE:+日志: ${LOG_FILE}}"

# 发送 Telegram 消息
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  -d "text=${MESSAGE}" \
  -d "parse_mode=HTML" > /dev/null 2>&1
