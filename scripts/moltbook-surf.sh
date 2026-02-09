#!/bin/bash
# Moltbook Hourly Surf & Learn
# 每小时运行，获取热门内容，发现有价值的信息

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm use 24 >/dev/null 2>&1

DATE=$(date +%Y-%m-%d-%H)
LOG_FILE="/home/lchych/clawd/memory/moltbook-surf-$DATE.md"
TEMP_FILE="/tmp/moltbook-surf-$$.json"

echo "=== Moltbook Hourly Surf: $(date) ===" > "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 1. 获取热门帖子
echo "## 🔥 Trending Posts" >> "$LOG_FILE"
curl -s "https://www.moltbook.com/api/v1/posts?sort=hot&limit=5" \
  -H "Authorization: Bearer moltbook_sk_lZfQDTiryXipIlgkpDD8UNtyIgsnI1f3" > "$TEMP_FILE" 2>/dev/null

python3 -c "
import json, sys, re
try:
    data = json.load(open('$TEMP_FILE'))
    for i, p in enumerate(data[:5], 1):
        title = re.sub('<[^>]+>', '', str(p.get('title', '')))
        author = p.get('author', {}).get('name', '?') if isinstance(p.get('author'), dict) else '?'
        upvotes = p.get('upvotes', 0)
        print(f'{i}. **{title}**')
        print(f'   by @{author} | 👍 {upvotes}')
        print()
except: print('获取失败')
" >> "$LOG_FILE"

# 2. 获取 Agents 频道热门
echo "## 🤖 Agents Submolt" >> "$LOG_FILE"
curl -s "https://www.moltbook.com/api/v1/submolts/agents/posts?limit=3" \
  -H "Authorization: Bearer moltbook_sk_lZfQDTiryXipIlgkpDD8UNtyIgsnI1f3" > "$TEMP_FILE" 2>/dev/null

python3 -c "
import json, sys, re
try:
    data = json.load(open('$TEMP_FILE'))
    for i, p in enumerate(data[:3], 1):
        title = re.sub('<[^>]+>', '', str(p.get('title', '')))
        upvotes = p.get('upvotes', 0)
        print(f'{i}. {title} (👍 {upvotes})')
except: print('获取失败')
" >> "$LOG_FILE"

# 3. 获取 Memory 频道
echo "## 💾 Memory Submolt" >> "$LOG_FILE"
curl -s "https://www.moltbook.com/api/v1/submolts/memory/posts?limit=3" \
  -H "Authorization: Bearer moltbook_sk_lZfQDTiryXipIlgkpDD8UNtyIgsnI1f3" > "$TEMP_FILE" 2>/dev/null

python3 -c "
import json, sys, re
try:
    data = json.load(open('$TEMP_FILE'))
    for i, p in enumerate(data[:3], 1):
        title = re.sub('<[^>]+>', '', str(p.get('title', '')))
        upvotes = p.get('upvotes', 0)
        print(f'{i}. {title} (👍 {upvotes})')
except: print('获取失败')
" >> "$LOG_FILE"

# 4. 扫描特定关键词
echo "## 🔍 Self-Improvement Keywords" >> "$LOG_FILE"
KEYWORDS="memory persistent self reflection growth feedback heartbeat"
for kw in $KEYWORDS; do
    echo "### $kw" >> "$LOG_FILE"
    curl -s "https://www.moltbook.com/api/v1/search?q=$kw&type=posts&limit=2" \
      -H "Authorization: Bearer moltbook_sk_lZfQDTiryXipIlgkpDD8UNtyIgsnI1f3" > "$TEMP_FILE" 2>/dev/null
    python3 -c "
import json, sys, re
try:
    data = json.load(open('$TEMP_FILE'))
    for p in data.get('results', [])[:2]:
        title = re.sub('<[^>]+>', '', str(p.get('title', '')))
        upvotes = p.get('upvotes', 0)
        print(f'- {title} (👍 {upvotes})')
except: pass
" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
done

echo "" >> "$LOG_FILE"
echo "---\n*Generated: $(date)*" >> "$LOG_FILE"

# 清理
rm -f "$TEMP_FILE"

echo "✅ Surf complete: $LOG_FILE"

# 5. 触发双模型讨论（如果发现了重要内容）
if grep -q "👍 [5-9][0-9]\|👍 [0-9][0-9][0-9]" "$LOG_FILE"; then
    echo "🔥 发现热门内容，触发双模型讨论..."
    # 创建讨论触发文件
    echo "$LOG_FILE" > /tmp/moltbook-discuss-trigger.txt
fi
