#!/bin/bash
# 混合搜索：FTS + 向量搜索

QUERY="$1"
MEMORY_DIR="/home/lchych/clawd/memory"

if [ -z "$QUERY" ]; then
    echo "Usage: $0 <query>"
    exit 1
fi

echo "=== FTS 搜索结果 ==="
grep -ri "$QUERY" "$MEMORY_DIR" --include="*.md" -l 2>/dev/null | head -10

echo ""
echo "=== 向量搜索结果 ==="
/home/lchych/.local/bin/memsearch search "$QUERY" 2>&1
