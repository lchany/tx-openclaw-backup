# Task Plan

## Goal
在当前 AGENTS.md 体系项目中，增量接入 knowledge 模块：安装 knowledge-kb skill，创建 knowledge/ 模块目录与索引/流转机制，补根路由，不重构现有 memory 体系。

## Phases
- [complete] 1. 安装 knowledge-kb 到现有 skills 体系
- [complete] 2. 创建 knowledge/ 模块目录与基础文件
- [complete] 3. 更新根 AGENTS.md 的 knowledge 路由
- [complete] 4. 验证结构与安装结果
- [in_progress] 5. 记录结果并提交工作区变更

## Notes
- 用户已明确同意执行，并同意安装技能。
- 采用增量接入，不改造现有 memory/ 与 knowledge-graph.json。
- skill 目标路径：skills/knowledge-kb/
- 已完成 skill 审计，结论为 ✅ SAFE TO INSTALL。
- 已修复 knowledge-kb 对标准 `.agents/.claude` 路径的假设，使其兼容当前项目的根级 `skills/` 布局。
- 当前主机缺少 ffmpeg/ffprobe，视频转写入口已接入但暂不具备执行条件。

## Errors Encountered
| Error | Attempt | Resolution |
|---|---:|---|
