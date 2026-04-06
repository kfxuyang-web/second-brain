# process/chat.md — 聊天记录

**适用**：群聊、私聊、会议记录、与 AI 的对话

## 第一步：保存聊天记录（必需！）

**先保存到 raw/chats/，再处理！**

```bash
# 如果是文本，保存为 txt
cat > raw/chats/$(date +%Y-%m-%d)-chat-topic.txt << 'EOF'
粘贴聊天内容
EOF

# 如果是文件，复制到 raw/chats/
cp /path/to/chat-file.raw raw/chats/
```

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

## 关联内容
{{从 wiki/ 搜索到的相关页面}}
```

## 写入前必做：交叉链接

**必需步骤！写入 wiki 前必须执行：**

1. 用关键词搜索 wiki/ 目录：
```bash
grep -r "关键词1\|关键词2" wiki/
```

2. 找到相关页面后添加链接：
```markdown
## 关联内容
- [[wiki/相关页面]] — 简要说明
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

## 更新 Log（必需！）

在 `wiki/log.md` 顶部插入：

```markdown
## [{{date}}] ingest | {{title}}

- **类型:** chat
- **PARA:** {{para}}
- **文件:** wiki/{{para}}/{{slug}}.md
- **摘要:** {{一句话摘要}}
- **操作:** ingest
```
