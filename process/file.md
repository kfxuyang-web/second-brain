# process/file.md — 文件

**适用**：PDF、Word、Excel、Markdown、文本等文档

## 获取内容

```bash
tools/extract_file_meta.sh <file>    # 元数据 + 内容提取
tools/extract_pdf_text.sh <pdf>      # PDF专用
```

**PDF/Word 特有**：`pages`、`author`
**Excel 特有**：`sheets`、`rows`
**图片/音视频**：调用对应的 extract 工具

## Wiki 格式

```markdown
---
date: {{date}}
type: file
para: {{para}}
tags: [{{tags}}]
source: raw/files/{{filename}}
format: {{pdf/docx/xlsx/md}}
size: {{大小}}
created_at: {{YYYY-MM-DD}}
pages: {{页数}}    # PDF特有
---

# {{文档标题}}

## 基本信息
- 格式: {{format}}
- 大小: {{size}}
- 创建: {{created_at}}
- 页数: {{pages}}

## 摘要
{{50-100字}}

## 关键摘录
{{1-3个值得引用的段落}}

## 行动项
{{待办/决策}}
```

## PARA 判断

| 文档类型 | 类型 |
|---------|------|
| 项目计划/会议纪要 | projects |
| 持续跟踪报告 | areas |
| 书籍/论文/参考 | resources |
| 历史文档 | archives |

## 更新 Log（必需！）

在 `wiki/log.md` 顶部插入：

```markdown
## [{{date}}] ingest | {{title}}

- **类型:** file
- **PARA:** {{para}}
- **文件:** wiki/{{para}}/{{slug}}.md
- **摘要:** {{一句话摘要}}
- **操作:** ingest
```
