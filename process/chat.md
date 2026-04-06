# process/chat.md — 聊天记录

**适用**：群聊、私聊、会议记录、与 AI 的对话

## Wiki 格式

```markdown
---
date: {{date}}
type: chat
para: {{para}}
tags: [{{tags}}]
participants: [{{names}}]
platform: {{wechat|slack|meeting|wechat}}
---

# {{聊天主题}}

## 决策
{{提取的所有决定}}

## 行动项
- [ ] {{待办1}} — {{负责人}}
- [ ] {{待办2}} — {{负责人}}

## 关键讨论
{{有价值的观点摘要}}

## 待跟进
{{悬而未决的事项}}
```

## PARA 判断

| 内容 | 类型 |
|-----|------|
| 项目讨论+行动项 | projects |
| 持续话题 | areas |
| 信息分享 | resources |
| 已完成会议 | archives |

## 隐私注意

保存时脱敏（手机号/地址等可删除）

## 与 AI 对话

用户与 OpenClaw/Claude Code 的对话中，有价值的内容也应处理
