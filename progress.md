# Progress

## 2026-03-10
- 已确认用户要求：卸载当前 office 并重新安装。
- 已确认主实例健康，office profile 为半成品。
- 已启动 rollback-monitor。
- 已将旧 office 残留备份到 `/home/lchych/.openclaw/config-backups/openclaw-office-reinstall-20260310-085501/`。
- 已执行 `openclaw --profile office uninstall --state --workspace --yes --non-interactive`。
- 已清理旧的 `~/.openclaw/openclaw-office.json` sidecar。
- 已用 remote mode 重建 office profile，并成功生成 `~/.openclaw-office/openclaw.json`。
- 已补齐 workspace：`/home/lchych/.openclaw/workspace-office`，bootstrap 文件存在。
- `openclaw --profile office status --all` 验证通过：Gateway 为 remote，指向 `ws://127.0.0.1:18789`，Agent bootstrap file 为 PRESENT。
- 已关闭 rollback-monitor。
