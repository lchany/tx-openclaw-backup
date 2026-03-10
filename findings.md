# Findings

## 2026-03-10
- `openclaw-office` 可通过 `npx -y @ww-ai-lab/openclaw-office` 运行，默认端口为 5180，默认 host 为 `0.0.0.0`。
- 当前主机只有 8045 和 18789 在监听；5180 原先未启动。
- `~/.openclaw-office/openclaw.json` 是 office profile 配置，不是 OpenClaw Office Web 前端的持久化入口配置。
- OpenClaw Office README 说明其自身公开网页端口默认是 5180，连接上游 Gateway（默认 `ws://localhost:18789`）。
- 通过 `npx` 启动后，OpenClaw Office 已成功监听 `0.0.0.0:5180`。
- 本机 `http://127.0.0.1:5180` 返回 200，公网 `http://43.160.206.212:5180` 也返回 200。
- HTML 标题为 `OpenClaw Office`，页面内注入 `window.__OPENCLAW_CONFIG__={"gatewayUrl":"/gateway-ws",...}`。
- 对 `/gateway-ws` 发起 WebSocket 握手返回 `101 Switching Protocols`，说明浏览器到 Office 的同源代理可用。
