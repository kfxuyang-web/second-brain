# process/article.md — 文章/URL

**适用**：网页文章、博客、新闻、YouTube/B站字幕

## 获取内容

```bash
tools/fetch_content.sh <url>           # 智能识别平台
# 或
tools/fetch_url.sh <url>               # 普通网页
yt-dlp --write-auto-sub <url>          # YouTube/B站字幕
agent-reach --read <url>               # 公众号/小红书
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
- [[wiki/xxx]]   # 交叉链接
```

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

