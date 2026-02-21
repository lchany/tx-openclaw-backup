#!/bin/bash
# 截图 tmux 终端并发送到 Telegram

export PATH="$HOME/.cargo/bin:$PATH"

TMUX_SOCKET="/tmp/openclaw-tmux-sockets/openclaw.sock"
SESSION="demo-session"
CAPTURE_FILE="/tmp/tmux-capture-$$.txt"
OUTPUT_FILE="/tmp/tmux-screenshot-$$.png"

# 检查 socket 是否存在
if [ ! -S "$TMUX_SOCKET" ]; then
    echo "NO_TMUX"
    exit 1
fi

# 捕获终端内容
tmux -S "$TMUX_SOCKET" capture-pane -t "$SESSION":0.0 -p > "$CAPTURE_FILE" 2>/dev/null
if [ $? -ne 0 ] || [ ! -s "$CAPTURE_FILE" ]; then
    rm -f "$CAPTURE_FILE"
    echo "CAPTURE_FAILED"
    exit 1
fi

# 生成截图
~/.cargo/bin/silicon "$CAPTURE_FILE" -o "$OUTPUT_FILE" --font "Noto Sans CJK SC" --background "#1e1e1e" --no-line-number -l bash 2>/dev/null

if [ -f "$OUTPUT_FILE" ]; then
    echo "$OUTPUT_FILE"
else
    echo "GENERATE_FAILED"
    exit 1
fi
