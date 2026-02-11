#!/bin/bash
# 截图当前 tmux 会话并发送

TMUX_SOCKET="/tmp/openclaw-tmux-sockets/openclaw.sock"
SESSION="demo-session"
OUTPUT="/tmp/tmux-screenshot-$(date +%H%M%S).png"

# 捕获带颜色的终端内容
tmux -S "$TMUX_SOCKET" capture-pane -e -t "$SESSION":0.0 -p > /tmp/tmux-capture.txt

# 生成 PNG 截图
/home/lchych/.nvm/versions/node/v24.13.0/bin/termshot --filename "$OUTPUT" --raw-read /tmp/tmux-capture.txt 2>/dev/null || \
/tmp/termshot --filename "$OUTPUT" --raw-read /tmp/tmux-capture.txt

echo "$OUTPUT"
