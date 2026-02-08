#!/bin/bash
# Docker 容器健康监控脚本（免密版）
# 每分钟检查容器状态

LOG_FILE="/home/lchych/clawd/memory/docker-health.log"
ALERT_FILE="/tmp/docker-alert"

# 获取当前时间
timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

# 记录日志
log() {
    echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

# 主检查逻辑
main_check() {
    log "=== Docker 健康检查 ==="
    
    # 检查 Docker 守护进程
    if ! pgrep -x "dockerd" > /dev/null; then
        log "❌ Docker 守护进程未运行"
        echo "docker-down" > "$ALERT_FILE"
        return 1
    fi
    
    # 获取所有容器状态
    CONTAINERS=$(sudo docker ps -a --format "{{.Names}}|{{.Status}}|{{.State}}" 2>/dev/null)
    
    if [ -z "$CONTAINERS" ]; then
        log "ℹ️ 无容器运行"
        return 0
    fi
    
    # 检查每个容器
    echo "$CONTAINERS" | while IFS='|' read -r name status state; do
        if echo "$status" | grep -q "Up"; then
            log "✅ 容器 $name 运行正常"
        else
            log "❌ 容器 $name 异常: $status"
            echo "$name-stopped" > "$ALERT_FILE"
        fi
    done
    
    log "=== 检查完成 ==="
}

# 执行检查
main_check
