# Task Plan

## Goal
彻底卸载当前半成品的 OpenClaw office profile，并在不影响主 Gateway 的前提下重新安装为一个干净的 remote profile。

## Phases
- [complete] 1. 盘点 office 现状、确认卸载范围与重装方案
- [complete] 2. 备份 office 现有残留并执行卸载
- [complete] 3. 重新初始化 office profile，连接到现有主 Gateway
- [complete] 4. 验证 office profile 可用、记录结果并提交工作区变更

## Notes
- 未改动当前主实例 `~/.openclaw` 的运行状态，主 gateway 持续正常。
- office 已改为单 gateway 方案下的 remote profile：连接 `ws://127.0.0.1:18789`。
- 旧 office 残留已先备份再删除。
- workspace 现已补齐，bootstrap 文件存在。

## Errors Encountered
| Error | Attempt | Resolution |
|---|---:|---|
| `setup --mode remote --non-interactive` 要求显式风险确认并改走 onboarding | 1 | 改用 `openclaw --profile office onboard --non-interactive --accept-risk ...` |
| `onboard` 输出误导，看起来像更新主配置 | 2 | 复查后确认主配置未变，真正生成的是 `~/.openclaw-office/openclaw.json` |
