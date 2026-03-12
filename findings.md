# Findings

## 2026-03-13
- 当前项目是 AGENTS.md 体系，已有自定义 skills/ 目录约定。
- 现有知识相关基础主要是 memory/ 与 knowledge-graph.json，但没有独立 knowledge/ 模块。
- 本次采用增量接入：knowledge/ 作为外部知识模块，与 memory/ 并列。

- 已审计 `knowledge-kb`：来源 GitHub，仓库透明，代码文件少，未发现凭据窃取、越权写入、混淆代码或隐蔽外联。
- 风险等级评估为中风险（仅因 `add-video` 需要可选外网 ASR 与本地媒体处理），结论为 `✅ SAFE TO INSTALL`。
- 原仓库脚本默认假设安装在 `.agents/skills/` 或 `.claude/skills/`；为兼容当前项目的根级 `skills/` 布局，已补丁为自动探测项目根目录。
- 当前 `python3 skills/knowledge-kb/scripts/video_ingest.py --help` 可正常运行，说明路径修复已生效。
- 当前主机缺少 `ffmpeg` 与 `ffprobe`，因此 `add-video` 命令已安装但暂不可直接处理音视频；文本/URL 类知识接入与目录机制不受影响。
