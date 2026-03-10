# Task Plan

## Goal
在无界面 Linux 主机上启动 OpenClaw Office 前端，使其可通过公网访问 5180 端口查看 Office 画面，并验证连通性。

## Phases
- [complete] 1. 确认 office profile 与 gateway 当前状态
- [complete] 2. 确认 openclaw-office 可执行入口与当前监听端口
- [complete] 3. 启动 OpenClaw Office 前端到 0.0.0.0:5180 并验证本机可访问
- [complete] 4. 验证公网可访问并记录入口信息
- [complete] 5. 记录结果并提交工作区变更

## Notes
- 当前主 Gateway 正常运行在 18789。
- OpenClaw Office 前端已启动在 `0.0.0.0:5180`。
- 浏览器入口通过同源 `/gateway-ws` 代理连接上游 Gateway `ws://127.0.0.1:18789`。
- 目前为临时前台进程转后台运行，尚未做 systemd 持久化。

## Errors Encountered
| Error | Attempt | Resolution |
|---|---:|---|
| 5180 未监听，无法公网访问 Office 画面 | 1 | 启动 `npx -y @ww-ai-lab/openclaw-office --host 0.0.0.0 --port 5180 --gateway ws://127.0.0.1:18789 --token <token>` |
