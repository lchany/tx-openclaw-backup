# Progress

## 2026-03-10
- 已确认用户要的是 OpenClaw Office 的公网前端画面，不是 gateway 端口。
- 已确认 `openclaw-office --help` 可用，当前 5180 初始未监听，8045 不是 OpenClaw Office。
- 之前用临时 exec 拉起 5180，后续因 SIGTERM 退出，导致页面 `fail to fetch`。
- 已创建并启用 `systemd --user` 服务：`~/.config/systemd/user/openclaw-office.service`。
- 当前服务状态：`active (running)`。
- 已验证：
  - `127.0.0.1:5180` → HTTP 200
  - `43.160.206.212:5180` → HTTP 200
  - `/gateway-ws` → WebSocket `101 Switching Protocols`
- 当前 5180 已可从公网稳定打开 OpenClaw Office 页面。
- 管理命令：
  - `systemctl --user status openclaw-office.service`
  - `systemctl --user restart openclaw-office.service`
  - `journalctl --user -u openclaw-office.service -n 100 --no-pager`
