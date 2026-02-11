#!/bin/bash

# OpenClaw Memory Auto-Archive Script
# 自动归档30天前的日志文件，节省存储空间

MEMORY_DIR="/home/lchych/clawd/memory"
ARCHIVE_DIR="$MEMORY_DIR/archive"
LOG_FILE="$MEMORY_DIR/.archive.log"

# 创建归档目录
mkdir -p "$ARCHIVE_DIR"

# 记录执行时间
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始归档任务" >> "$LOG_FILE"

# 统计归档前大小
BEFORE_SIZE=$(du -sh "$MEMORY_DIR" 2>/dev/null | cut -f1)

# 归档30天前的 .md 文件（排除 archive 目录和 MUST_READ.md）
find "$MEMORY_DIR" -maxdepth 1 -name "*.md" -type f -mtime +30 \
  ! -name "MUST_READ.md" \
  ! -name "MEMORY.md" \
  -exec gzip -v {} \; -exec mv {}.gz "$ARCHIVE_DIR/" \; 2>> "$LOG_FILE"

# 归档30天前的日志文件（按日期命名的文件）
find "$MEMORY_DIR" -maxdepth 1 -name "????-??-??.md" -type f -mtime +30 \
  -exec gzip -v {} \; -exec mv {}.gz "$ARCHIVE_DIR/" \; 2>> "$LOG_FILE"

# 归档高频日志（moltbook-surf 等）
find "$MEMORY_DIR" -maxdepth 1 -name "moltbook-surf-*.md" -type f -mtime +7 \
  -exec gzip -v {} \; -exec mv {}.gz "$ARCHIVE_DIR/" \; 2>> "$LOG_FILE"

# 统计归档后大小
AFTER_SIZE=$(du -sh "$MEMORY_DIR" 2>/dev/null | cut -f1)
ARCHIVED_COUNT=$(find "$ARCHIVE_DIR" -name "*.gz" -type f | wc -l)

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 归档完成" >> "$LOG_FILE"
echo "归档前: $BEFORE_SIZE, 归档后: $AFTER_SIZE, 归档文件数: $ARCHIVED_COUNT" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"

# 输出结果
echo "✅ 归档任务完成"
echo "📦 已归档文件数: $ARCHIVED_COUNT"
echo "📁 归档目录: $ARCHIVE_DIR"
echo "📊 存储变化: $BEFORE_SIZE → $AFTER_SIZE"
