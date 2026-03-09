# Progress

## 2026-03-10
- 已确认用户希望“删除横幅”，不是仅改文案。
- 已定位横幅文本与发送函数：`buildResetSessionNoticeText()` / `sendResetSessionNotice()`。
- 已备份 5 个相关 bundle 到 `backups/openclaw-reset-banner-20260310-0706/`。
- 已将 5 个 bundle 中的 `sendResetSessionNotice()` 改为 no-op。
- Gateway 已重启并恢复正常，当前运行 pid 为 `859950`，`RPC probe: ok`。
- 已确认主 bundle 中 `sendResetSessionNotice()` 为 no-op，因此 `/new` 横幅不再发送。
- 下一步：提交工作区中的补丁脚本与记录文件。
