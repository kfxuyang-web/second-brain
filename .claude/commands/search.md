# Search Command

> 检索第二大脑内容。

## 使用方法

```
@search [关键词]
@search [PARA类型] [关键词]
@search projects [关键词]    # 只搜索 Projects
@search areas [关键词]       # 只搜索 Areas
@search resources [关键词]   # 只搜索 Resources
@search archives [关键词]    # 只搜索 Archives
```

## 示例

```
@search LLM Wiki
@search resources AI Agent
@search projects 截止日期
```

## 执行流程

1. 读取 `wiki/index.md` 了解所有页面
2. 在 `wiki/` 目录下搜索关键词
3. 优先搜索文件名、标题、标签
4. 返回相关页面列表和相关度评分

## 搜索结果格式

```markdown
## 搜索结果: "{{关键词}}"

### wiki/projects/xxx.md
**相关度:** ★★★★☆
**摘要:** 内容摘要...
**标签:** #tag1 #tag2

### wiki/resources/yyy.md
**相关度:** ★★★☆☆
**摘要:** 内容摘要...
**标签:** #tag3
```

## 高级搜索

### 按日期范围
```@search from:2026-01 to:2026-03 AI```

### 按内容类型
```@search type:article AI```

### 按标签
```@search #AI #Agent```

## 搜索原理

在中等规模（~100 来源，~数百页面）下，`wiki/index.md` 的纯文本搜索已经足够有效。

如需更高级搜索，可使用 [qmd](https://github.com/tobi/qmd)：
```bash
qmd search "AI Agent" --rank
```

---

*See also: `@ingest` 摄入新内容, `@lint` 健康检查*
