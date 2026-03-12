# knowledge/AGENTS.md

这个目录是**外部知识模块**，用于沉淀文章、摘录、URL、视频/音频转写等可复用知识。

它与现有记忆系统分工不同：

- `memory/`：会话、决策、复盘、用户偏好
- `knowledge/`：外部资料、学习材料、可检索知识条目
- `knowledge-graph.json`：结构化事实关系

## 默认检索规则

1. **先读 `knowledge/_index.md`**
2. 先按标签、摘要、最近收录定位候选条目
3. **只有需要细节时**，才打开单篇条目全文
4. **禁止默认全量扫描 `knowledge/*.md`**

## 条目命名规则

正式条目统一使用：

- `YYYY-MM-DD-简短描述.md`

例如：

- `2026-03-13-agent-memory-patterns.md`
- `2026-03-13-知识库索引设计.md`

## 正式条目结构

每条正式知识至少包含：

```markdown
---
date: 2026-03-13
source: X/@someone
source_type: article
source_url: "https://..."
tags:
  - AI学习
  - Agent
confidence: processed
---

# 标题

## 核心观点
[1-3 句摘要]

## 我的思考
[与当前工作关联，可选]

## 原始内容
[保留全文、转写或完整摘录]
```

规则：

- 不允许只存摘要，不存原文
- 不建议只存原文，不做摘要
- `_index.md` 只做检索摘要，不承载全文

## inbox 流转规则

### 手动资料

手动资料默认进入：

- `knowledge/inbox/manual/pending/`

流转规则：

- 可确认入库 → 生成正式条目 → 更新 `_index.md` → 原文移入 `processed/`
- 疑似重复 / 冲突 / 无法确认状态 → 移入 `review/`

目录：

- `knowledge/inbox/manual/pending/`
- `knowledge/inbox/manual/processed/`
- `knowledge/inbox/manual/review/`

### 视频 / 音频资料

原始素材进入：

- `knowledge/inbox/video/raw/`

处理中间产物：

- `knowledge/inbox/video/work/`
- `knowledge/inbox/video/transcripts/`
- `knowledge/inbox/video/logs/`

流转规则：

1. 原始素材放入 `raw/`
2. 转写与轻度清洗
3. 生成正式条目
4. 同步重建 `_index.md`
5. 若 `核心观点` 为空，由当前 Agent 基于条目补写

## skill 与脚本

已安装 skill：`skills/knowledge-kb/`

推荐触发方式：

- `/knowledge-kb add [内容或URL]`
- `/knowledge-kb find [查询]`
- `/knowledge-kb add-video [文件或目录]`

脚本入口：

```bash
python3 skills/knowledge-kb/scripts/video_ingest.py [路径]
```

视频/音频入库前置条件：

- 需要 `ffmpeg`
- 需要 `ffprobe`
- 需要 DashScope API Key（可放 `skills/knowledge-kb/config.local.json` 或环境变量）

## 索引维护规则

每次新增、修改、删除正式知识条目后：

1. 同步更新 `knowledge/_index.md`
2. 复用已有标签写法，避免同义词漂移
3. 检索时始终优先 `_index.md`

## 当前接入策略

本项目采用**增量接入**：

- 不改造 `memory/`
- 不迁移既有历史文件
- 只新增 `knowledge/` 模块及其检索/流转机制
