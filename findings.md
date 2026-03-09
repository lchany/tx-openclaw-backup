# Findings

## 2026-03-10
- OpenClaw 用户可见 `/new` 横幅由已编译 bundle 中的 `sendResetSessionNotice()` 发送。
- 当前安装路径：`/home/lchych/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw/dist/`
- 关键实现位于 `reply-Deht_wOB.js`，Gateway 运行时直接依赖该 bundle。
- 同类文案也存在于 `plugin-sdk` / `pi-embedded` / `subagent-registry` 的构建产物中。
- 已统一将 5 个构建产物中的 `sendResetSessionNotice()` 改为 no-op，避免不同运行路径下横幅复活。
