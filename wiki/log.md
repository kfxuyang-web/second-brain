# Wiki Log

> 第二大脑的操作日志。追加制，按时间倒序。

---

## 使用说明

每次摄入新内容后，在此文件顶部追加条目。

### 条目格式

```markdown
## [{{date}}] {{type}} | {{title}}

- **类型:** {{input_type}} (article/tweet/voice/image/file/chat)
- **PARA:** {{para_category}} (projects/areas/resources/archives)
- **文件:** {{wiki_file_path}}
- **摘要:** {{brief_summary}}
- **操作:** ingest
```

### 快速查看

```bash
# 最后 5 条
grep "^## \[" wiki/log.md | head -5

# 按类型筛选
grep "^## \[" wiki/log.md | grep "| tweet"

# 按 PARA 筛选
grep "PARA: projects" wiki/log.md
```

---

## 日志

<!-- 新条目添加在下面 -->

