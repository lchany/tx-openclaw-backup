#!/bin/bash
# 截图当前 tmux 会话 - 使用 silicon 支持中文

export PATH="$HOME/.cargo/bin:$PATH"

TMUX_SOCKET="/tmp/openclaw-tmux-sockets/openclaw.sock"
SESSION="demo-session"
OUTPUT="/tmp/tmux-screenshot-$(date +%H%M%S).png"

# 捕获纯文本内容
tmux -S "$TMUX_SOCKET" capture-pane -t "$SESSION":0.0 -p > /tmp/tmux-capture.txt

# 使用 silicon 生成截图（支持中文）
silicon /tmp/tmux-capture.txt -o "$OUTPUT" --font "Noto Sans CJK SC" --background "#1e1e1e" --no-line-number -l bash 2>/dev/null || \
/tmp/termshot --filename "$OUTPUT" --raw-read /tmp/tmux-capture.txt

echo "$OUTPUT"