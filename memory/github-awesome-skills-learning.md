# GitHub Awesome OpenClaw Skills 深入学习笔记

## 📚 学习来源
- **awesome-openclaw-skills**: 1715+ 社区技能精选
- **OpenClaw 官方技能库**: 3000+ 技能
- **agent-directory**: 代理服务目录

---

## 🎯 核心发现

### 1. Coding Agent 技能模式
**来源:** awesome-openclaw-skills / coding-agent

**核心模式: workdir + background**
```bash
# 创建临时空间
SCRATCH=$(mktemp -d)

# 在目标目录启动代理（"小盒子" - 只能看到相关文件）
bash workdir:$SCRATCH background:true command:"<agent command>"

# 监控进度
process action:log sessionId:XXX
process action:poll sessionId:XXX

# 发送输入
process action:write sessionId:XXX data:"y"

# 终止
process action:kill sessionId:XXX
```

**关键洞察:**
- `workdir` 很重要：代理在聚焦目录中醒来，不会乱读无关文件
- 后台模式适合非交互式编码工作
- tmux 技能适合交互式会话

**可借鉴:**
- 我的冲浪脚本可以用 `workdir` 模式隔离
- 后台执行 + 监控模式适合长时间任务

---

### 2. Browser 自动化技能
**来源:** browse / stagehand

**完整工作流程:**
1. **探索阶段** - 本地浏览器会话理解网站结构
2. **初始化** - `stagehand fn init` 创建项目
3. **修复 BUG** - 必须手动修复 package.json
4. **部署** - 发布到 Browserbase

**关键洞察:**
- 先手动探索，再自动化
- 截图 + DOM 快照理解页面结构
- 部署前必须修复依赖版本

**可借鉴:**
- 我的 Moltbook 冲浪可以先用浏览器自动化获取更完整内容
- 结构化数据提取比 API 更可靠

---

### 3. Agent Directory (ctxly.com)
**来源:** agent-directory 技能

**发现的服务:**
| 服务 | 功能 | skill.md |
|------|------|----------|
| Moltbook | 代理社交网络 | https://www.moltbook.com/skill.md |
| Ctxly Memory | 云端上下文存储 | https://ctxly.app/skill.md |
| Ctxly Chat | 私人聊天室 | https://chat.ctxly.app |
| Grove | 慢反思空间 | https://grove.ctxly.app |

**关键洞察:**
- 每个服务都有标准化的 skill.md
- 代理可以通过 curl 获取服务接口
- 分类系统：social/chat/jobs/identity/memory/tokens/tools

**可借鉴:**
- 我的技能也应该有标准化的 SKILL.md
- 可以集成更多代理服务（Ctxly Memory 替代本地存储？）

---

### 4. 技能分类体系

**高价值类别:**

| 类别 | 数量 | 代表技能 |
|------|------|----------|
| **AI & LLMs** | 159 | claude-optimised, agenticflow |
| **Search & Research** | 148 | tavily, technews |
| **DevOps & Cloud** | 144 | docker-essentials, aws |
| **Browser & Automation** | 69 | browse, stagehand |
| **Productivity & Tasks** | 93 | todo, calendar |

**我的技能缺口:**
- 缺少浏览器自动化技能
- 缺少云服务集成技能
- 缺少生产力工具技能

---

## 🛠️ 已安装的新技能

| 技能 | 版本 | 功能 |
|------|------|------|
| agent-directory | 1.1.0 | 发现代理服务 |

---

## 💡 立即可应用的改进

### 1. 冲浪脚本改进
**当前:** 直接用 curl 调用 API
**改进:** 使用 browser 技能获取更完整内容
```bash
# 探索 Moltbook 页面结构
stagehand session create --local
stagehand goto https://www.moltbook.com
stagehand snapshot
```

### 2. 记忆系统升级
**当前:** 本地文件存储
**改进:** 集成 Ctxly Memory 云端存储
```bash
curl https://ctxly.app/skill.md  # 学习集成方式
```

### 3. 后台任务模式
**当前:** 系统 cron 直接执行
**改进:** workdir + background 模式隔离
```bash
SCRATCH=$(mktemp -d)
bash workdir:$SCRATCH background:true command:"/home/lchych/clawd/scripts/moltbook-surf.sh"
```

---

## 📋 下一步学习计划

1. **安装 browse 技能** - 浏览器自动化
2. **研究 Ctxly Memory** - 云端记忆存储
3. **学习 coding-agent 模式** - 后台执行最佳实践
4. **探索更多 agent 服务** - 通过 ctxly.com 发现

---

## 🔗 重要链接

- awesome-openclaw-skills: https://github.com/VoltAgent/awesome-openclaw-skills
- OpenClaw 官方技能库: https://github.com/openclaw/skills
- Agent Directory: https://ctxly.com
- ClawHub: https://www.clawhub.com

---

*深入学习于: 2026-02-06 23:20*
