---
name: knowledge-kb
description: 用于在项目中收录、检索和整理 knowledge/ 模块里的外部知识，特别是在需要 add、find 或 add-video 这三个命令时使用。
---

# /knowledge-kb — Knowledge 模块管理

管理 `knowledge/` 下的外部知识，默认用于 AI 学习内容，也可扩展到其他主题。

## 触发方式

- `/knowledge-kb add [内容或URL]`
- `/knowledge-kb find [查询]`
- `/knowledge-kb add-video [视频文件或目录]`

## 通用约束

- 不全量扫描 `knowledge/*.md`，优先读取 `knowledge/_index.md`
- 新条目命名：`YYYY-MM-DD-简短描述.md`
- 标签优先复用 `_index.md` 中已有写法，避免同义词漂移
- 写入路径只使用 `knowledge/`，不写入 `workspace-human/`
- `核心观点` 提炼默认由当前会话 Agent 完成，不调用第三方模型
- `原始内容` 必须保留全量正文/全量转写，供人学习与 AI 深读参考
- AI 检索优先使用 `_index.md`；仅在需要细节时读取条目全文 `原始内容`
- 若原始内容不是中文，默认保留原文；仅在用户明确要求时才提供全量中文译文（不允许仅部分翻译）
- 手动收集文档默认放入 `knowledge/inbox/manual/pending/`
- 手动文档成功入库后，应将原文移动到 `knowledge/inbox/manual/processed/`
- 无法确认入库状态、疑似重复或需人工判断的文档，移动到 `knowledge/inbox/manual/review/`

## 子命令

### 1) add（MVP 已实现）

用于收录新知识，输入可以是文本、摘录或 URL。

执行流程：
1. 识别输入类型和来源（tweet/thread/article/video/note/image_text）
2. 读取 `knowledge/_index.md`，参考已有标签与相近条目
3. 生成结构化条目，至少包含：
   - `核心观点`（1-3 句，由当前 Agent 提炼，不调用第三方模型）
   - `原始内容`（默认保留全量正文/全量转写原文；仅在用户明确要求翻译时，提供全量中文译文）
   - frontmatter（date/source/source_type/source_url/tags/confidence）
4. 写入 `knowledge/YYYY-MM-DD-标题.md`，默认 `confidence: processed`
5. 更新 `knowledge/_index.md`：
   - 更新「最后更新」与「条目数」
   - 在对应标签下新增一行摘要 + 全文链接
   - 在「最近收录」表插入一行
6. 若输入来自 `knowledge/inbox/manual/pending/` 的原文，则将该原文移动到 `knowledge/inbox/manual/processed/`
7. 返回结果：新文件路径、标签、与已有条目的关联建议

仅在以下情况需要询问用户：
- 来源无法识别且无法判断真实性
- 同一主题存在明显冲突观点，无法确定是否应合并
- 原文是否已入库无法确认，此时不要猜测，改放 `knowledge/inbox/manual/review/`

### 2) find（MVP 已实现）

用于快速检索知识，不先读全文。

执行流程：
1. 读取 `knowledge/_index.md`
2. 基于关键词、标签和摘要匹配候选条目
3. 返回 Top-N 命中（标题、来源、标签、一句话摘要、全文路径）
4. 用户要求细节时，再读取对应条目全文并总结

输出格式建议：
- `命中条目`
- `关键观点`
- `建议延伸阅读`

### 3) add-video（已实现）

用于处理视频或音频素材，流程为：转写 → 轻度校对排版 → 直接入知识库。

#### 前置条件

1. 安装依赖：
   - `pip3 install dashscope`
2. 配置 API Key（推荐本地配置文件）：
   - 复制模板：`cp config.example.json config.local.json`
   - 编辑 `config.local.json` 填入 `dashscope_api_key`
   - 也支持环境变量：`DASHSCOPE_API_KEY`
3. 机器可用：
   - `ffmpeg`
   - `ffprobe`

#### 素材路径

- 推荐默认投喂目录：`knowledge/inbox/video/raw/`
- 支持单文件或目录批处理

#### 执行命令

```bash
python3 scripts/video_ingest.py [路径]
```

#### 执行策略（Codex/受限沙箱）

- 当任务由 Codex 在受限沙箱中执行时，`add-video` 默认**直接提权运行**，不要先在沙箱内盲试。
- 原因：ASR 依赖 DashScope 外网调用，沙箱内常见 `dashscope.aliyuncs.com` DNS 解析失败会导致长时间重试后才报错。
- 推荐动作：首次执行就使用带网络权限的命令，减少一次完整失败重试周期。
- 如用户明确要求“不提权”，再退回沙箱执行并告知可能失败风险。

可选参数：
- `--source-url`：原始来源链接
- `--title`：覆盖自动标题
- `--tags`：逗号分隔标签
- `--chunk-seconds`：分片秒数（默认 240）
- `--model`：ASR 模型（优先级：参数 > 环境变量 > config）
- `--base-url`：可选 API 地址覆盖（优先级：参数 > 环境变量 > config）
- `--api-key`：可选 API Key 覆盖（优先级：参数 > 环境变量 > config）

#### 执行结果

1. 转写与中间产物：
   - `knowledge/inbox/video/transcripts/*.raw.txt`
   - `knowledge/inbox/video/transcripts/*.clean.txt`
   - `knowledge/inbox/video/transcripts/*.meta.json`
2. 日志：
   - `knowledge/inbox/video/logs/ingest.log`
3. 最终入库：
   - 新增 `knowledge/YYYY-MM-DD-标题.md`
   - 自动重建 `knowledge/_index.md`

#### 质量规则

- 仅轻度校对（错别字、标点、断句、口头禅清理）
- 不新增事实
- 脚本阶段不调用第三方模型提炼 `核心观点`，该字段保持留空
- `add-video` 完成后由当前 Agent 基于条目 `原始内容` 补全 `核心观点`
- `_index.md` 摘要从 `核心观点` 聚合；若未补全则显示“待当前Agent提炼”
- 不确定术语用 `[?术语]` 标注并保留上下文
- 输出纯文本段落，不加时间戳

## 失败处理

- 若 `knowledge/_index.md` 缺失：先创建模板再继续
- 若输入只有 URL 且无法读取正文：保留 URL，标记 `confidence: raw`，提示用户补充摘要
- 若标题冲突：文件名追加短后缀避免覆盖
- 若 `add-video` 失败：检查 `config.local.json` / `DASHSCOPE_API_KEY`、`ffmpeg`、素材音频是否正常
- 若报错含 `NameResolutionError` 或 `Could not resolve host`：优先判定为沙箱网络限制，直接改为提权重跑，不做重复沙箱重试
