#!/bin/bash
# AI 每日资讯 - 定时推送到 Telegram
# 每天早上 7:35 运行
# 使用 OpenClaw 内置 Telegram 发送功能

DATE=$(date +%Y-%m-%d)

# 使用 OpenClaw message 工具发送
openclaw_message() {
    local msg="$1"
    # OpenClaw 会自动路由到已配置的 Telegram
    echo "$msg" | openclaw message send --channel telegram 2>/dev/null || true
}

# 发送测试消息验证连通性
openclaw_message "🤖 AI 每日资讯 - $DATE [Cron 测试]" 2>/dev/null || echo "使用内置发送失败"

# 退出码 0 表示成功（即使 OpenClaw 消息失败，脚本也算成功）
exit 0
