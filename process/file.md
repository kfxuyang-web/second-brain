# process/file.md — 文件

**适用**：PDF、Word、Excel、Markdown、文本等文档

## 第一步：保存文件（必需！）

**先保存到 raw/files/，再处理！**

```bash
# 保存文件到 raw/files/
cp /path/to/document.pdf raw/files/$(date +%Y-%m-%d)-document.pdf
```

## 第二步：提取元数据

```bash
tools/extract_file_meta.sh raw/files/具体文件名.pdf
tools/extract_pdf_text.sh raw/files/具体文件名.pdf    # PDF专用
```

**PDF/Word 特有**：`pages`、`author`
**Excel 特有**：`sheets`、`rows`

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
