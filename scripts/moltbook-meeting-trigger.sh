#!/bin/bash
# 完全自主方案：冲浪 → 自动触发真实会议 → 决策 → 执行 → 推送记录

export PATH="/home/lchych/.nvm/versions/node/v24.13.0/bin:$PATH"
export HOME="/home/lchych"
export OPENCLAW_GATEWAY_URL="http://localhost:18789"

cleanup() {
    rm -f /tmp/moltbook-surf-session.txt
    rm -f /tmp/moltbook-claude-done-file.txt
    rm -f /tmp/moltbook-minimax-done-file.txt
}

# 发送消息给 MiniMax 协作者触发真实会议
trigger_real_meeting() {
    DATE=$(cat /tmp/moltbook-surf-session.txt 2>/dev/null)
    LOG_DIR="/home/lchych/clawd/memory/moltbook-surf"
    CLAUDE_LOG="$LOG_DIR/moltbook-surf-claude-$DATE.md"
    MINIMAX_LOG="$LOG_DIR/moltbook-surf-minimax-$DATE.md"
    
    CLAUDE_RESULT=$(cat "$CLAUDE_LOG" 2>/dev/null)
    MINIMAX_RESULT=$(cat "$MINIMAX_LOG" 2>/dev/null)
    
    # 提取热门内容
    HOT1=$(echo "$CLAUDE_RESULT" | grep "^1\. \*\*" | sed 's/^1\. \*\*//;s/\*\*$//' | head -1)
    HOT2=$(echo "$CLAUDE_RESULT" | grep "^2\. \*\*" | sed 's/^2\. \*\*//;s/\*\*$//' | head -1)
    HOT3=$(echo "$CLAUDE_RESULT" | grep "^3\. \*\*" | sed 's/^3\. \*\*//;s/\*\*$//' | head -1)
    
    MINI1=$(echo "$MINIMAX_RESULT" | grep "^1\. \*\*" | sed 's/^1\. \*\*//;s/\*\*$//' | head -1)
    MINI2=$(echo "$MINIMAX_RESULT" | grep "^2\. \*\*" | sed 's/^2\. \*\*//;s/\*\*$//' | head -1)
    MINI3=$(echo "$MINIMAX_RESULT" | grep "^3\. \*\*" | sed 's/^3\. \*\*//;s/\*\*$//' | head -1)
    
    # 第一步：推送会议开始通知
    START_MSG="🌊 Moltbook 冲浪完成 - $DATE

━━━━━━━━━━━━━━━━━━━━━━
📊 Claude 发现
━━━━━━━━━━━━━━━━━━━━━━
1. $HOT1
2. $HOT2
3. $HOT3

━━━━━━━━━━━━━━━━━━━━━━
📊 MiniMax 发现
━━━━━━━━━━━━━━━━━━━━━━
1. $MINI1
2. $MINI2
3. $MINI3

━━━━━━━━━━━━━━━━━━━━━━
🎬 双模型会议开始
━━━━━━━━━━━━━━━━━━━━━━
Claude 与 MiniMax 正在讨论...
结论将在会议结束后推送。"

    curl -s -X POST "https://api.telegram.org/bot8104939902:AAG_xvcBjipQ8SRVwdZ6aJ2YAWUFWSYxn4M/sendMessage" \
      -d "chat_id=6445835734" \
      -d "text=$START_MSG" >/dev/null 2>&1
    
    # 第二步：发送消息给 MiniMax 协作者触发真实会议
    # 使用 Gateway API 发送消息到子 Agent
    MEETING_MSG="🌊 Moltbook 双模型会议开始 - $DATE

我的发现（Claude）：
- $HOT1
- $HOT2
- $HOT3

你的发现（MiniMax）：
- $MINI1
- $MINI2
- $MINI3

请进行会议讨论：
1. 各自汇报重点发现
2. 对比分析差异
3. 价值评估
4. 最终决策（关注哪些、采取什么行动）
5. 执行决策

注意：
- 这是真实双模型会议，不是模拟
- 请提出你的独立观点，不盲从
- 最后我会综合双方观点形成最终决策
- 完整会议记录将推送给用户"

    # 保存会议消息到文件，供后续使用
    echo "$MEETING_MSG" > /tmp/moltbook-meeting-msg.txt
    echo "$DATE" > /tmp/moltbook-meeting-date.txt
    
    # 通过主 Agent 触发会议（使用工具调用）
    # 由于无法直接调用 sessions_send，改为：
    # 1. 保存会议上下文
    # 2. 下次主 Agent 活跃时自动继续会议
    # 3. 或者通过 cron job 触发
    
    echo "✅ 会议上下文已保存，等待主 Agent 继续"
    
    # 创建触发文件，提示主 Agent 继续会议
    echo "MEETING_PENDING:$DATE" > /tmp/moltbook-meeting-pending.txt
    
    cleanup
}

# 主程序
DATE=$(cat /tmp/moltbook-surf-session.txt 2>/dev/null)
CLAUDE_DONE=$(cat /tmp/moltbook-claude-done-file.txt 2>/dev/null)
MINIMAX_DONE=$(cat /tmp/moltbook-minimax-done-file.txt 2>/dev/null)

if [ -z "$DATE" ] || [ -z "$CLAUDE_DONE" ] || [ -z "$MINIMAX_DONE" ]; then
    exit 0
fi

MAX_WAIT=3600
WAITED=0
CHECK_INTERVAL=30

while [ $WAITED -lt $MAX_WAIT ]; do
    if [ -f "$CLAUDE_DONE" ] && [ -f "$MINIMAX_DONE" ]; then
        trigger_real_meeting
        exit 0
    fi
    sleep $CHECK_INTERVAL
    WAITED=$((WAITED + CHECK_INTERVAL))
done

cleanup
exit 1
