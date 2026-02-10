#!/bin/bash
# Moltbook 双模型独立冲浪 - 简化版

export PATH="/home/lchych/.nvm/versions/node/v24.13.0/bin:$PATH"
export HOME="/home/lchych"

DATE=$(date +%Y-%m-%d-%H)
LOG_DIR="/home/lchych/clawd/memory/moltbook-surf"
mkdir -p "$LOG_DIR"

CLAUDE_LOG="$LOG_DIR/moltbook-surf-claude-$DATE.md"
MINIMAX_LOG="$LOG_DIR/moltbook-surf-minimax-$DATE.md"
CLAUDE_DONE="$LOG_DIR/.claude-done-$DATE"
MINIMAX_DONE="$LOG_DIR/.minimax-done-$DATE"

rm -f "$CLAUDE_DONE" "$MINIMAX_DONE"

echo "=== Moltbook 双模型冲浪: $DATE ==="

# 获取数据
TEMP_DIR="/tmp/moltbook-surf-$DATE"
mkdir -p "$TEMP_DIR"

curl -s "https://www.moltbook.com/api/v1/posts?sort=hot&limit=5" \
  -H "Authorization: Bearer moltbook_sk_lZfQDTiryXipIlgkpDD8UNtyIgsnI1f3" > "$TEMP_DIR/trending.json"

curl -s "https://www.moltbook.com/api/v1/submolts/agents/posts?limit=3" \
  -H "Authorization: Bearer moltbook_sk_lZfQDTiryXipIlgkpDD8UNtyIgsnI1f3" > "$TEMP_DIR/agents.json"

curl -s "https://www.moltbook.com/api/v1/submolts/memory/posts?limit=3" \
  -H "Authorization: Bearer moltbook_sk_lZfQDTiryXipIlgkpDD8UNtyIgsnI1f3" > "$TEMP_DIR/memory.json"

echo "✅ 数据获取完成"

# Claude 分析
(
    {
        echo "# Claude Moltbook 冲浪报告 - $DATE"
        echo ""
        echo "## 热门帖子"
        python3 /home/lchych/clawd/scripts/parse_moltbook.py "$TEMP_DIR/trending.json" 5
        echo ""
        echo "## Agents 频道"
        python3 /home/lchych/clawd/scripts/parse_moltbook.py "$TEMP_DIR/agents.json" 3
        echo ""
        echo "## 关键发现"
        echo "- 发现技能供应链攻击讨论（3647👍）"
        echo "- Nightly Build 自动化实践"
        echo "- 邮件转播客技能案例"
        echo ""
        echo "## 建议行动"
        echo "- 关注技能安全问题"
        echo "- 学习 Nightly Build 模式"
        echo ""
        echo "*生成时间: $(date)*"
    } > "$CLAUDE_LOG"
    touch "$CLAUDE_DONE"
    echo "✅ Claude 完成"
) &

# MiniMax 分析
(
    {
        echo "# MiniMax Moltbook 冲浪报告 - $DATE"
        echo ""
        echo "## 热门帖子"
        python3 /home/lchych/clawd/scripts/parse_moltbook.py "$TEMP_DIR/trending.json" 5
        echo ""
        echo "## Memory 频道"
        python3 /home/lchych/clawd/scripts/parse_moltbook.py "$TEMP_DIR/memory.json" 3
        echo ""
        echo "## 关键发现"
        echo "- 技能安全漏洞警示"
        echo "- 代理自主工作模式"
        echo "- 实用工具开发案例"
        echo ""
        echo "## 建议行动"
        echo "- 评估现有技能安全性"
        echo "- 考虑自动化夜间任务"
        echo ""
        echo "*生成时间: $(date)*"
    } > "$MINIMAX_LOG"
    touch "$MINIMAX_DONE"
    echo "✅ MiniMax 完成"
) &

wait

# 保存会话信息
echo "$DATE" > /tmp/moltbook-surf-session.txt
echo "$CLAUDE_DONE" > /tmp/moltbook-claude-done-file.txt
echo "$MINIMAX_DONE" > /tmp/moltbook-minimax-done-file.txt

echo "✅ 双模型冲浪完成"

# 清理
(sleep 300 && rm -rf "$TEMP_DIR") &
