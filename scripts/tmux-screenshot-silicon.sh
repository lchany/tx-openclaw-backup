#!/bin/bash
# 使用 silicon 截图当前 tmux 会话

TMUX_SOCKET="/tmp/openclaw-tmux-sockets/openclaw.sock"
SESSION="demo-session"
OUTPUT="/tmp/tmux-screenshot-$(date +%H%M%S).png"

# 捕获带颜色的终端内容
tmux -S "$TMUX_SOCKET" capture-pane -e -t "$SESSION":0.0 -p > /tmp/tmux-capture.txt

# 使用 silicon 生成截图（如果已安装）
if command -v silicon &> /dev/null; then
    silicon /tmp/tmux-capture.txt -o "$OUTPUT" --font "Droid Sans Fallback" 2>/dev/null
else
    # 回退到 termshot
    /tmp/termshot --filename "$OUTPUT" --raw-read /tmp/tmux-capture.txt
fi

echo "$OUTPUT"