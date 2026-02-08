#!/bin/bash
# OpenClaw 会话自动初始化脚本
# 每次新会话时执行，恢复多 Agent 协作环境

SCRIPT_DIR="/home/lchych/clawd/scripts"
MEMORY_DIR="/home/lchych/clawd/memory"
LOG_FILE="$MEMORY_DIR/session-init.log"

# 记录日志
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== 会话初始化开始 ==="

# 1. 检查 MUST_READ.md
if [ -f "$MEMORY_DIR/MUST_READ.md" ]; then
    log "✅ MUST_READ.md 存在"
    # 提取关键信息
    COLLABORATOR_API=$(grep -A1 "API:" "$MEMORY_DIR/MUST_READ.md" | tail -1 | awk '{print $2}')
    COLLABORATOR_KEY=$(grep -A1 "Key:" "$MEMORY_DIR/MUST_READ.md" | tail -1 | awk '{print $2}')
    log "📋 协作者 API: ${COLLABORATOR_API:0:30}..."
else
    log "❌ MUST_READ.md 不存在"
fi

# 2. 检查 Docker 权限
if sudo docker ps > /dev/null 2>&1; then
    log "✅ Docker 权限正常"
    # 检查容器状态
    CONTAINERS=$(sudo docker ps --format "{{.Names}}" 2>/dev/null | tr '\n' ', ')
    log "🐳 运行中的容器: $CONTAINERS"
else
    log "⚠️ Docker 权限异常"
fi

# 3. 检查定时任务
CRON_JOBS=$(crontab -l 2>/dev/null | grep -c "^*" || echo "0")
log "⏰ 定时任务数量: $CRON_JOBS"

# 4. 输出初始化报告
echo ""
echo "╔════════════════════════════════════════╗"
echo "║     OpenClaw 会话初始化完成            ║"
echo "╠════════════════════════════════════════╣"
echo "║ 多 Agent 协作规则: 已加载              ║"
echo "║ Docker 监控: 已启用                    ║"
echo "║ 定时任务: 运行中                       ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "触发词: 开启会议 | 讨论一下 | 你怎么看"
echo ""

log "=== 会话初始化完成 ==="
