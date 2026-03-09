# Task Plan

## Goal
删除 OpenClaw `/new` / `/reset` 后发送给用户的 `✅ New session started · model: ...` 横幅，保留正常的新会话问候。

## Phases
- [complete] 1. 定位实际生效的横幅发送逻辑与目标 bundle
- [complete] 2. 备份相关 bundle 并应用补丁
- [complete] 3. 重启 Gateway 并验证横幅发送逻辑已失效、Gateway 正常运行
- [in_progress] 4. 在工作区保存可重打补丁并提交 git

## Notes
- 目标是删除用户可见横幅，不修改 `/new` 的核心重置能力。
- 优先做最小改动，避免影响其他回复流程。

## Errors Encountered
| Error | Attempt | Resolution |
|---|---:|---|
