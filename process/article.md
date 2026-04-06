# process/article.md — 文章/URL

**适用**：网页文章、博客、新闻、YouTube/B站字幕

## 第一步：保存原始内容（必需！）

**先保存到 raw/articles/，再创建 wiki 条目！**

```bash
# 普通网页
tools/fetch_url.sh <url> > raw/articles/$(date +%Y-%m-%d)-slug.txt

# YouTube/B站字幕
yt-dlp --write-auto-sub <url> -o "raw/articles/%(date)s-%(id)s.%(ext)s"
```

## 第二步：获取内容

Twitter 内容必须用 Jina Reader 抓取，格式：

```
https://r.jina.ai/https://twitter.com/user/status/123456
```

**步骤：**
1. 提取推文 URL：`https://twitter.com/user/status/123456`
2. 前缀 `https://r.jina.ai/`：`https://r.jina.ai/https://twitter.com/user/status/123456`
3. 用 `curl -L -s` 获取内容
4. 内容存入 `raw/tweets/`（不是 `raw/articles/`）

**示例：**
```bash
URL="https://twitter.com/user/status/123456"
JINA_URL="https://r.jina.ai/$URL"
CONTENT=$(curl -L -s "$JINA_URL")
echo "$CONTENT" > "raw/tweets/$(date +%Y-%m-%d)-tweet-$(echo $URL | grep -o '[0-9]*$').txt"
```

## Wiki 格式

```markdown
---
date: {{date}}
type: article
para: {{para}}
tags: [{{tags}}]
source: {{url}}
---

# {{标题}}

## 摘要
{{50字}}

## 核心要点
- {{要点1}}
- {{要点2}}

## 来源
- {{url}}

## 关联内容
{{从 wiki/ 搜索到的相关页面，每条一行 [[wiki/xxx]] 格式}}
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

| 内容 | 类型 |
|-----|------|
| 有行动+截止 | projects |
| 持续关注 | areas |
| 感兴趣暂无行动 | resources |
| 读完了无后续 | archives |

## 更新 Log（必需！）

在 `wiki/log.md` 顶部插入：

```markdown
## [{{date}}] ingest | {{title}}

- **类型:** article
- **PARA:** {{para}}
- **文件:** wiki/{{para}}/{{slug}}.md
- **摘要:** {{一句话摘要}}
- **操作:** ingest
```

