# process/task.md — 日程/TODO

**适用**：有具体时间的日程，或时间模糊的待办

## 日程 vs TODO

| 类型 | 判断 | 必填字段 |
|-----|------|---------|
| 日程 | 有明确时间点（"明天2点"、"4/15 9:00"）| `due: YYYY-MM-DD HH:MM` |
| TODO | 时间模糊（"尽快"、"这周"）| `deadline: YYYY-MM-DD`（可选）|

## Wiki 格式

```markdown
---
date: {{date}}
type: task
para: {{projects|areas}}
title: {{任务标题}}
due: {{YYYY-MM-DD HH:MM}}      # 日程必填
deadline: {{YYYY-MM-DD}}        # TODO可选
status: pending|in_progress|completed
recurring: {{none|weekly|daily}}
---

# {{任务标题}}

## 类型
- [ ] **日程** due: {{due}}
- [ ] **TODO** deadline: {{deadline}}

## 下一步行动
{{具体做什么}}

## 关联
- [[wiki/projects/xxx]]
```

## 更新状态

```
完成 → status: completed
改期 → 更新 due
```

## 查询

```dataview
TABLE due, deadline, status
FROM "wiki"
WHERE type = "task" AND status != "completed"
SORT due ASC
```

## 更新 Log（必需！）

在 `wiki/log.md` 顶部插入：

```markdown
## [{{date}}] ingest | {{title}}

- **类型:** task
- **PARA:** {{para}}
- **文件:** wiki/{{para}}/{{slug}}.md
- **摘要:** {{一句话摘要}}
- **操作:** ingest
```
