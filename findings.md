# Findings

## 2026-03-10
- 主 OpenClaw 实例正常运行，Gateway 位于 `ws://127.0.0.1:18789`，RPC probe 正常。
- `office` 不是独立 CLI 子命令，而是一个独立 profile（`openclaw --profile office ...`）。
- 旧的 `office` profile 是半成品：`~/.openclaw-office/openclaw.json` 缺失，仅有 `identity/` 与 `memory/` 残留。
- 卸载 `office` profile 的有效命令是：`openclaw --profile office uninstall --state --workspace --yes --non-interactive`。
- 为避免脏状态影响重装，还需要清理旧 sidecar：`~/.openclaw/openclaw-office.json`。
- 重装 office 的合理方式是保留现有主 Gateway，使用 remote mode 重新初始化 office profile，而不是再起第二个 gateway。
- 可行的重装流程：
  1. `openclaw --profile office onboard --non-interactive --accept-risk --mode remote --remote-url ws://127.0.0.1:18789 --remote-token <token> --skip-channels --skip-skills --skip-health --skip-ui --no-install-daemon`
  2. `openclaw --profile office setup --workspace /home/lchych/.openclaw/workspace-office`
- 重装完成后的关键文件：
  - 配置：`~/.openclaw-office/openclaw.json`
  - workspace：`~/.openclaw/workspace-office`
  - sessions：`~/.openclaw-office/agents/main/sessions/`
