# Progress

## 2026-03-10
- 已确认用户要的是 OpenClaw Office 的公网前端画面，不是 gateway 端口。
- 已确认 `openclaw-office --help` 可用，当前 5180 初始未监听，8045 不是 OpenClaw Office。
- 已启动 OpenClaw Office：`npx -y @ww-ai-lab/openclaw-office --host 0.0.0.0 --port 5180 --gateway ws://127.0.0.1:18789 --token <token>`。
- 后台运行 session：`mellow-falcon`。
- 已验证：
  - `127.0.0.1:5180` → HTTP 200
  - `43.160.206.212:5180` → HTTP 200
  - `/gateway-ws` → WebSocket `101 Switching Protocols`
- 当前 5180 已可从公网打开 OpenClaw Office 页面。
- 注意：当前是临时进程，重启机器或进程退出后不会自动恢复；如需长期稳定运行，下一步应做 systemd service。
