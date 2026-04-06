# process/tweet.md — 推文/短内容

**适用**：推文、微博、灵感碎片、想法、引用

## Wiki 格式

```markdown
---
date: {{date}}
type: tweet
para: {{para}}
tags: [{{tags}}]
source: {{tweet_url}}
---

# {{主题 or 首句}}

## 内容
{{完整文字}}

## 解读
{{为什么重要}}
```

## PARA 判断

| 内容特征 | 类型 |
|---------|------|
| 有目标+截止 | projects |
| 持续领域 | areas |
| 灵感/想法 | resources |
| 转发已完成 | archives |

## 合并策略

同一天多条相关内容 → 合并到一条汇总页，不单独建页

## 更新 Log（必需！）

在 `wiki/log.md` 顶部插入：

```markdown
## [{{date}}] ingest | {{title}}

- **类型:** tweet
- **PARA:** {{para}}
- **文件:** wiki/{{para}}/{{slug}}.md
- **摘要:** {{一句话摘要}}
- **操作:** ingest
```
