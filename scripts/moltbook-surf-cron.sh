#!/bin/bash
# Moltbook 每小时冲浪 - 双模型独立上网 + 智能完成检测 + 会议讨论

export PATH="/home/lchych/.nvm/versions/node/v24.13.0/bin:$PATH"
export HOME="/home/lchych"

echo "=== Moltbook 双模型冲浪启动: $(date) ==="

# 1. 启动双模型独立冲浪
/home/lchych/clawd/scripts/moltbook-dual-surf.sh

# 2. 启动智能完成检测（后台运行）
/home/lchych/clawd/scripts/moltbook-meeting-trigger.sh >> /home/lchych/clawd/logs/cron/moltbook-surf.log 2>&1 &

echo "✅ 双模型冲浪已启动，智能检测已启动"
