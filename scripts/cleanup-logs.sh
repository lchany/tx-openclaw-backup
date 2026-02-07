#!/bin/bash
# 安全日志清理脚本 - 每月月初执行
# 只清理非关键日志，系统日志不清理

echo "=== 日志清理: $(date) ==="

# 1. 清理 OpenClaw 旧日志（保留30天）
if [ -d "/tmp/openclaw" ]; then
    find /tmp/openclaw -name "*.log" -type f -mtime +30 -exec rm -f {} \;
    echo "✅ 清理 /tmp/openclaw 超过30天的日志"
fi

# 2. 清理 Moltbook surf 旧日志（保留30天）
if [ -d "/home/lchych/clawd/memory" ]; then
    find /home/lchych/clawd/memory -name "moltbook-surf-*.md" -type f -mtime +30 -exec rm -f {} \;
    echo "✅ 清理 moltbook-surf 超过30天的日志"
fi

# 3. 清理脚本临时日志（保留7天）
find /tmp -name "moltbook-*.log" -type f -mtime +7 -exec rm -f {} \; 2>/dev/null
find /tmp -name "moltbook-*.json" -type f -mtime +7 -exec rm -f {} \; 2>/dev/null
echo "✅ 清理 /tmp 超过7天的临时日志"

# 4. 清理用户级 systemd 日志（保留30天）
if command -v journalctl &> /dev/null; then
    journalctl --user --vacuum-time=30d --quiet 2>/dev/null
    echo "✅ 清理用户级 systemd 日志（保留30天）"
fi

# ⚠️ 以下日志不清理（需要用户决策）：
# - /var/log/* (系统日志)
# - /var/log/syslog
# - /var/log/auth.log
# - /var/log/kern.log
# - dpkg/apt 日志
# - 任何需要 sudo 权限的系统级日志

echo ""
echo "📋 跳过的日志（需要手动决策）："
echo "   - /var/log/* 系统日志"
echo "   - /var/log/syslog, auth.log, kern.log"
echo "   - dpkg/apt 安装日志"
echo ""
echo "✅ 清理完成: $(date)"
