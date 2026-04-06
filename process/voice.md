# process/voice.md — 语音

**适用**：录音、语音笔记

## 获取内容

```bash
# 1. 转录
tools/voice_to_text.sh <audio_file>    # 自动检测可用工具

# 2. 备用：手动转录后粘贴文字 → 用 tweet.md 处理
```

## Wiki 格式

```markdown
---
date: {{date}}
type: voice
para: {{para}}
tags: [voice,{{language}}]
duration: {{X分钟Y秒}}
transcript: raw/voice/{{filename}}.md
---

# {{主题 or 首句}}

## 基本信息
- 时间: {{日期 时间}}
- 时长: {{X分钟Y秒}}
- 语言: {{zh/en/multi}}

## 转录摘要
{{50字}}

## 详细内容
{{完整转录}}

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

| 内容 | 类型 |
|-----|------|
| 有决定/待办 | projects |
| 持续领域讨论 | areas |
| 灵感/想法 | resources |
| 会议记录（无后续）| archives |

## 更新 Log（必需！）

在 `wiki/log.md` 顶部插入：

```markdown
## [{{date}}] ingest | {{title}}

- **类型:** voice
- **PARA:** {{para}}
- **文件:** wiki/{{para}}/{{slug}}.md
- **摘要:** {{一句话摘要}}
- **操作:** ingest
```
