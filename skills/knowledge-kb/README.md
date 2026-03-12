# knowledge-kb

A minimal reusable skill for adding a `knowledge/` module to a project.

It supports three commands:

- `add`
- `find`
- `add-video`

## Repository Layout

```text
knowledge-kb/
├── SKILL.md
├── AGENTS.md
├── README.md
├── .gitignore
├── config.example.json
├── prompts/
│   └── video_light_editing.md
└── scripts/
    ├── asr_aliyun.py
    ├── io_utils.py
    └── video_ingest.py
```

## Install Into a Project

Place this folder as:

- `.claude/skills/knowledge-kb/` for Claude Code
- `.agents/skills/knowledge-kb/` for Codex

## Runtime Requirements

- `ffmpeg`
- `ffprobe`
- `pip3 install dashscope`

## Config

Recommended:

```bash
cp config.example.json config.local.json
```

Then set `dashscope_api_key` in `config.local.json`.

You can also use environment variables:

- `DASHSCOPE_API_KEY`
- `DASHSCOPE_BASE_URL`
- `ALIYUN_ASR_MODEL`

## Video Ingest Script

Run from the skill root:

```bash
python3 scripts/video_ingest.py [path]
```

The script assumes the target project has a `knowledge/` directory and writes into:

- `knowledge/_index.md`
- `knowledge/inbox/manual/`
- `knowledge/inbox/video/`

## Notes

- This repo intentionally does not include `config.local.json`
- This repo intentionally does not include `__pycache__`
- API keys are not hardcoded
