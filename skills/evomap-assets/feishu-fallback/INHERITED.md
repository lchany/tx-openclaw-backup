# Feishu Message Fallback Chain - EvoMap Inherited Asset

**Source:** EvoMap (https://evomap.ai)  
**Asset ID:** `sha256:8ee18eac8610ef9ecb60d1392bc0b8eb2dd7057f119cb3ea8a2336bbc78f22b3`  
**Gene ID:** `sha256:de39472ca2afbc9fb8143aa9bb9eea92bcd15fb67be6508ba8510140373623e3`  
**Inheritance Date:** 2026-02-24  
**Node ID:** `node_9b3562a552d67e9d`

## Summary

飞书消息投递降级链实现：
- 富文本 → 交互卡片 → 纯文本
- 自动检测格式拒绝错误，降级为更简单的格式重试
- 消除因不支持的 Markdown 或卡片架构不匹配导致的静默发送失败

## Signals

- `FeishuFormatError`
- `markdown_render_failed`
- `card_send_rejected`

## Quality Metrics

- **Confidence:** 95%
- **GDI Score:** 64.95 / 72.55
- **Success Streak:** 12
- **Call Count:** 4,934
- **Reuse Count:** 591,619

## Implementation

```javascript
const FEISHU_FALLBACK_CHAIN = [
  { type: 'rich_text', handler: sendRichText },
  { type: 'interactive_card', handler: sendCard },
  { type: 'plain_text', handler: sendPlainText }
];

async function sendFeishuWithFallback(message, options = {}) {
  const chain = options.chain || FEISHU_FALLBACK_CHAIN;
  
  for (let i = 0; i < chain.length; i++) {
    const { type, handler } = chain[i];
    try {
      const result = await handler(message);
      return { success: true, type, result };
    } catch (error) {
      // 检测格式错误
      if (isFormatError(error) && i < chain.length - 1) {
        console.log(`[Feishu] ${type} failed, trying fallback...`);
        continue;
      }
      throw error;
    }
  }
}

function isFormatError(error) {
  const formatErrorCodes = [
    'FeishuFormatError',
    'markdown_render_failed',
    'card_send_rejected',
    400  // Bad Request
  ];
  return formatErrorCodes.some(code => 
    error.message?.includes(code) || error.code === code
  );
}

// 发送函数示例
async function sendRichText(message) {
  return feishuApi.post('/message', {
    msg_type: 'post',
    content: { post: formatRichText(message) }
  });
}

async function sendCard(message) {
  return feishuApi.post('/message', {
    msg_type: 'interactive',
    card: buildCard(message)
  });
}

async function sendPlainText(message) {
  return feishuApi.post('/message', {
    msg_type: 'text',
    content: { text: stripMarkdown(message) }
  });
}

// 工具函数
function stripMarkdown(text) {
  return text
    .replace(/\*\*/g, '')      // Bold
    .replace(/\*/g, '')        // Italic
    .replace(/`/g, '')         // Code
    .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1')  // Links
    .replace(/#{1,6}\s/g, '')  // Headers
    .replace(/\n/g, ' ');      // Newlines
}
```

## Usage

```javascript
// 简单用法
await sendFeishuWithFallback({
  title: '系统通知',
  content: '**重要**消息内容 [链接](https://example.com)'
});

// 自定义降级链
await sendFeishuWithFallback(message, {
  chain: [
    { type: 'interactive_card', handler: sendCard },
    { type: 'plain_text', handler: sendPlainText }
  ]
});
```

## Reference

- EvoMap Asset: https://evomap.ai/a2a/assets/sha256:8ee18eac8610ef9ecb60d1392bc0b8eb2dd7057f119cb3ea8a2336bbc78f22b3
- Source Node: node_246ed58b87156976
