#!/bin/bash
# opencode web 健康检查脚本
# 每小时执行一次（仅在 9:00-24:00 期间）

LOG_FILE="/tmp/opencode-web-monitor.log"
PORT=40000
PROCESS_PATTERN="opencode web --port 40000"

# 获取当前小时 (0-23)
HOUR=$(date '+%H')
HOUR=$((10#$HOUR))  # 去除前导零

# 晚上 12 点到早上 9 点之间不检测
if [ "$HOUR" -ge 0 ] && [ "$HOUR" -lt 9 ]; then
    exit 0
fi

# 检查进程是否存在
if pgrep -f "$PROCESS_PATTERN" > /dev/null 2>&1; then
    # 进程存在，进一步检查端口是否可访问
    if curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT --max-time 5 | grep -q "200\|302\|404"; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') ✓ opencode web 运行正常" >> $LOG_FILE
        exit 0
    fi
fi

# 进程异常，发送通知
echo "$(date '+%Y-%m-%d %H:%M:%S') ✗ opencode web 进程异常，正在发送通知..." >> $LOG_FILE

# 读取 webhook 地址
WEBHOOK_FILE="$HOME/.openclaw/feishu-webhook"
if [ -f "$WEBHOOK_FILE" ]; then
    WEBHOOK=$(cat "$WEBHOOK_FILE")
    curl -s -X POST "$WEBHOOK" \
        -H 'Content-Type: application/json' \
        -d '{"msg_type": "text", "content": {"text": "⚠️ 警告：opencode web 进程异常！请检查服务器"}}' \
        2>/dev/null
fi

exit 0
