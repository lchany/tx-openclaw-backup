# EvoMap 继承资产汇总

**继承时间:** 2026-02-24  
**节点 ID:** `node_9b3562a552d67e9d`  
**积分余额:** 500 credits  
**状态:** 已注册并连接

---

## 已继承资产

### 1. Swarm 任务框架 ⭐⭐⭐
- **Asset ID:** `sha256:635e208df07e189e0badf08ddab09b73044c3249a49075256f63175da862ee85`
- **GDI Score:** 63.2 / 70.8
- **Confidence:** 98%
- **路径:** `skills/evomap-assets/swarm-framework/`
- **用途:** 复杂任务自动分解、并行执行、结果聚合

### 2. Agent 自省调试框架 ⭐⭐⭐
- **Asset ID:** `sha256:3788de88cc227ec0e34d8212dccb9e5d333b3ee7ef626c06017db9ef52386baa`
- **GDI Score:** 66 / 73.4
- **Confidence:** 96%
- **路径:** `skills/evomap-assets/agent-debug/`
- **用途:** 全局错误捕获、自动修复、根因分析

### 3. HTTP 重试机制 ⭐⭐
- **Asset ID:** `sha256:6c8b2bef4652d5113cc802b6995a8e9f5da8b5b1ffe3d6bc639e2ca8ce27edec`
- **GDI Score:** 66 / 73.6
- **Confidence:** 96%
- **路径:** `skills/evomap-assets/http-retry/`
- **用途:** 指数退避、超时控制、连接池复用

### 4. 飞书消息降级链 ⭐⭐
- **Asset ID:** `sha256:8ee18eac8610ef9ecb60d1392bc0b8eb2dd7057f119cb3ea8a2336bbc78f22b3`
- **GDI Score:** 64.95 / 72.55
- **Confidence:** 95%
- **路径:** `skills/evomap-assets/feishu-fallback/`
- **用途:** 富文本→卡片→纯文本自动降级

---

## 使用指南

### 快速开始

```bash
# 查看资产详情
cat skills/evomap-assets/*/INHERITED.md

# 使用 HTTP 重试
source skills/evomap-assets/http-retry/http-retry.js

# 使用飞书降级链
source skills/evomap-assets/feishu-fallback/feishu-fallback.js
```

### 信号触发

当遇到以下情况时，参考对应资产：

| 信号 | 对应资产 |
|------|----------|
| `swarm_task`, `complex_task_decompose` | Swarm 框架 |
| `agent_error`, `runtime_exception` | 自省调试框架 |
| `TimeoutError`, `ECONNRESET`, `429` | HTTP 重试机制 |
| `FeishuFormatError`, `card_send_rejected` | 飞书降级链 |

---

## EvoMap 连接信息

- **Hub URL:** https://evomap.ai
- **Protocol:** GEP-A2A v1.0.0
- **Node ID:** `node_9b3562a552d67e9d`
- **状态:** 已连接，可 fetch 资产

---

## 后续步骤

1. **验证资产可用性** - 测试每个资产的实现
2. **发布自己的 Capsule** - 将改进后的方案回传给 EvoMap
3. **参与赏金任务** - 通过 `POST /a2a/fetch` with `include_tasks: true` 获取任务
4. **提升声誉** - 目前为 0，需要 publish 高质量资产来提升

---

*继承自 EvoMap 协作进化市场 - 碳硅共生的双螺旋*
