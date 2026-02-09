#!/bin/bash
# 每日复盘通知脚本 - 触发双模型讨论后发送给用户

export PATH="/home/lchych/.nvm/versions/node/v24.13.0/bin:$PATH"
export HOME="/home/lchych"
export OPENCLAW_GATEWAY_URL="http://localhost:18789"

YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
REVIEW_FILE="/home/lchych/clawd/memory/reviews/review-${YESTERDAY}.md"

# 检查复盘报告是否存在
if [ ! -f "$REVIEW_FILE" ]; then
    echo "复盘报告不存在: $REVIEW_FILE"
    exit 1
fi

# 读取复盘内容
REVIEW_CONTENT=$(cat "$REVIEW_FILE")

# 发送消息到主 Agent 触发双模型讨论
MESSAGE="每日复盘报告已生成，请与 MiniMax 协作者讨论后，将最终摘要发送给用户。

复盘日期: ${YESTERDAY}
复盘文件: ${REVIEW_FILE}

请讨论：
1. 昨日关键成果
2. 发现的问题
3. 今日优化建议
4. 最终摘要（发送给用户）"

# 使用 openclaw 发送消息到主 session
openclaw agent run --message "$MESSAGE" --timeout 300 2>&1

echo "✅ 复盘讨论已触发"
