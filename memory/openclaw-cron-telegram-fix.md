# OpenClaw Cron Telegram 发送问题 - 解决方案

## 🔍 问题根源

根据 GitHub issue #5531 和文档，发现 **OpenClaw 已知 Bug**:

> Cron jobs 在 `isolated` session 中使用 `message` 工具时，target 参数无法正确传递

### 错误现象
```
Unknown target "lchych" for Telegram
The message tool requires a target
```

### 根本原因
1. `delivery.mode = "announce"` 会**抑制** `message` 工具调用
2. `delivery.mode = "none"` 时，`message` 工具需要显式传递 `target` 参数
3. 但在 `isolated` session 中，`target` 参数可能无法正确解析

---

## ✅ 解决方案

### 方案 1: 使用 `delivery.announce` 模式（推荐）

不使用 `message` 工具，让 OpenClaw 自动发送 summary：

```json
{
  "delivery": {
    "mode": "announce",
    "channel": "telegram",
    "to": "6445835734"
  },
  "payload": {
    "kind": "agentTurn",
    "message": "生成要发送的内容，作为返回值"
  }
}
```

**注意**: 此时**不要**使用 `message` 工具，直接返回文本内容。

---

### 方案 2: 使用 `message` 工具显式指定 target

```json
{
  "delivery": {
    "mode": "none"
  },
  "payload": {
    "kind": "agentTurn",
    "message": "Use message tool with explicit target parameter"
  }
}
```

在任务中使用：
```javascript
message({ 
  action: "send", 
  channel: "telegram", 
  target: "6445835734", 
  message: "内容" 
})
```

---

### 方案 3: 使用 `systemEvent` + `main` session

改用 `main` session，让任务在 main session 中执行：

```json
{
  "sessionTarget": "main",
  "payload": {
    "kind": "systemEvent",
    "text": "触发 heartbeat 执行任务"
  }
}
```

然后在 HEARTBEAT.md 中处理任务。

---

## 🧪 当前测试任务

已创建测试任务 `test-message-tool` (09:55 执行)：
- `delivery.mode = "none"`
- 任务内使用 `message` 工具显式指定 target

等待测试结果...

---

## 📚 参考链接

- GitHub Issue #5339: Telegram unable to receive cron message
- GitHub Issue #5531: Session replies not routing to Telegram
- OpenClaw Docs: Cron Jobs - Announce delivery suppresses messaging tool

---

## 📝 关键教训

1. **announce 模式** = 自动发送 summary，抑制 message 工具
2. **none 模式** = 需显式使用 message 工具，需指定 target
3. **已知 Bug**: isolated session 中 target 解析可能有问题
4. **推荐**: 使用 announce 模式，让 OpenClaw 自动处理发送
