#!/usr/bin/env python3
import json
import sys
import re

def parse_posts(filename, limit=5):
    try:
        with open(filename, 'r') as f:
            data = json.load(f)
        posts = data.get('posts', [])[:limit]
        for i, p in enumerate(posts, 1):
            title = re.sub(r'<[^>]+>', '', str(p.get('title', '')))
            author = p.get('author', {}).get('name', '?') if isinstance(p.get('author'), dict) else '?'
            upvotes = p.get('upvotes', 0)
            print(f'{i}. **{title}**')
            print(f'   by @{author} | 👍 {upvotes}')
            print()
    except Exception as e:
        print(f'解析错误: {e}')

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("用法: python3 parse_moltbook.py <json_file> [limit]")
        sys.exit(1)
    
    limit = int(sys.argv[2]) if len(sys.argv) > 2 else 5
    parse_posts(sys.argv[1], limit)
