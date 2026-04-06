# process/tweet.md — 推文/短内容

**适用**：推文、微博、灵感碎片、想法、引用

## Twitter/X 专属抓取（优先使用 Jina Reader）

Twitter 内容必须用 Jina Reader 抓取：

```
https://r.jina.ai/https://twitter.com/user/status/123456
```

**步骤：**
1. 提取推文 URL
2. 前缀 `https://r.jina.ai/`
3. `curl -L -s` 获取内容
4. 内容存入 `raw/tweets/`

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

## 关联内容
{{从 wiki/ 搜索到的相关页面}}
```

## 写入前必做：交叉链接

**必需步骤！写入 wiki 前必须执行：**

1. 用关键词搜索 wiki/ 目录：
```bash
grep -r "关键词1\|关键词2" wiki/
```

2. 找到相关页面后，在 Wiki 页面的"## 关联内容"部分添加：
```markdown
## 关联内容
- [[wiki/相关页面文件名]] — 简要说明关联原因
```

3. 如果是同一主题的多篇内容，必须互相链接

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
