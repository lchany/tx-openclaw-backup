#!/bin/bash
# Moltbook 双模型讨论脚本
# 当发现重要内容时，触发 Claude + MiniMax 讨论

export PATH="/home/lchych/.nvm/versions/node/v24.13.0/bin:$PATH"
export HOME="/home/lchych"

# 检查是否有讨论触发
if [ ! -f /tmp/moltbook-discuss-trigger.txt ]; then
    exit 0
fi

LOG_FILE=$(cat /tmp/moltbook-discuss-trigger.txt)
rm -f /tmp/moltbook-discuss-trigger.txt

if [ ! -f "$LOG_FILE" ]; then
    exit 0
fi

# 提取热门内容
HOT_CONTENT=$(grep -A2 "👍 [5-9][0-9]\|👍 [0-9][0-9][0-9]" "$LOG_FILE" | head -10)

# 发送消息触发双模型讨论
MESSAGE="🌊 Moltbook 冲浪发现重要内容，请与 MiniMax 协作者讨论后通知用户。

热门内容：
${HOT_CONTENT}

请讨论：
1. 这些内容的价值和相关性
2. 是否需要采取行动（学习、回复、关注）
3. 最终建议（发送给用户）

日志文件: ${LOG_FILE}"

# 使用 openclaw 发送
openclaw agent run --message "$MESSAGE" --timeout 300 2>&1

echo "✅ Moltbook 讨论已触发"
