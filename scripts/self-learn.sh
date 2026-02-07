#!/bin/bash
# Self-Learning Agent
# 基于冲浪结果，自我决策学习内容

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm use 24 >/dev/null 2>&1

DATE=$(date +%Y-%m-%d)
SURF_LOG="/home/lchych/clawd/memory/moltbook-surf-$DATE-$(date +%H).md"
DECISION_LOG="/home/lchych/clawd/memory/self-learning-$DATE.md"

echo "=== Self-Learning: $(date) ==="

# 决策规则：基于关键词搜索并评估是否安装
install_skill() {
    local skill_name="$1"
    local reason="$2"
    
    # 检查是否已安装
    if [ -d "/home/lchych/clawd/skills/$skill_name" ] || [ -d "$HOME/.claudeai/skills/$skill_name" ]; then
        echo "⏭ $skill_name (已安装)"
        return
    fi
    
    # 尝试安装
    echo "🔍 评估: $skill_name"
    result=$(clawdhub install "$skill_name" 2>&1)
    if echo "$result" | grep -q "Installed"; then
        echo "✅ 已安装: $skill_name - $reason"
        echo "✅ 已安装: $skill_name - $reason" >> "$DECISION_LOG"
        return
    fi
    echo "⏭ $skill_name (安装失败或不存在)"
}

# 读取 Surf 结果，提取高赞帖子关键词
echo "📖 分析冲浪结果..."

# 基于今日发现做决策
install_skill "elite-longterm-memory" "高赞: Meta-Memory 相关"
install_skill "thecolony-heartbeat" "高赞: Heartbeat 相关"
install_skill "deterministic-replay" "高赞: Deterministic 相关"

# 扫描高赞帖子中的技能关键词
if [ -f "$SURF_LOG" ]; then
    # 从日志中提取可能的技能名
    grep -i "skill\|protocol\|framework\|system" "$SURF_LOG" | head -5 | while read line; do
        # 提取可能的技能名并安装
        skill=$(echo "$line" | grep -oP '\b[\w-]+\b' | head -1)
        if [ -n "$skill" ] && [ ${#skill} -gt 3 ]; then
            install_skill "$skill" "从讨论中发现"
        fi
    done
fi

echo "🆕 检查完成"
