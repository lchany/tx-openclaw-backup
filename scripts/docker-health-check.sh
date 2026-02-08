#!/bin/bash
# Docker 容器健康监控脚本
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

# 检查 Docker 权限
check_docker_access() {
    # 尝试使用 sudo 或检查权限
    if groups | grep -q docker; then
        DOCKER_CMD="docker"
    elif sudo -n docker ps >/dev/null 2>&1; then
        DOCKER_CMD="sudo docker"
    else
        # 尝试直接访问（如果权限已更改）
        if docker ps >/dev/null 2>&1; then
            DOCKER_CMD="docker"
        else
            log "⚠️ 无法访问 Docker，需要权限"
            return 1
        fi
    fi
    return 0
}

# 主检查逻辑
main_check() {
    log "=== 开始健康检查 ==="
    
    # 检查 Docker 守护进程
    if ! pgrep -x "dockerd" >/dev/null; then
        log "❌ Docker 守护进程未运行"
        echo "docker-down" > "$ALERT_FILE"
        return 1
    fi
    
    # 检查容器访问权限
    if ! check_docker_access; then
        return 1
    fi
    
    # 获取所有容器状态
    CONTAINERS=$($DOCKER_CMD ps -a --format "{{.Names}}|{{.Status}}|{{.State}}" 2>/dev/null)
    
    if [ -z "$CONTAINERS" ]; then
        log "ℹ️ 无容器运行"
        return 0
    fi
    
    # 检查每个容器
    echo "$CONTAINERS" | while IFS='|' read -r name status state; do
        # 检查是否运行中
        if echo "$status" | grep -q "Up"; then
            # 检查健康状态
            health=$($DOCKER_CMD inspect --format='{{.State.Health.Status}}' "$name" 2>/dev/null || echo "none")
            
            if [ "$health" = "unhealthy" ]; then
                log "❌ 容器 $name 不健康"
                echo "$name-unhealthy" > "$ALERT_FILE"
            elif [ "$health" = "healthy" ] || [ "$health" = "none" ]; then
                log "✅ 容器 $name 运行正常 ($status)"
            fi
        else
            log "❌ 容器 $name 未运行 ($status)"
            echo "$name-stopped" > "$ALERT_FILE"
        fi
    done
    
    log "=== 检查完成 ==="
}

# 执行检查
main_check
