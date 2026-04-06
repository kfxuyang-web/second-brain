# process/voice.md — 语音

**适用**：录音、语音笔记

## 第一步：判断是否值得存储

**如果语音只是简单回应，跳过存储。**

简单回应特征（满足任一）：
- 时长 < 5 秒
- 内容是确认语：好的、知道了、嗯、OK、收到、是、对
- 无实际信息量

**值得存储的语音：**
- 时长 > 5 秒
- 有具体内容（想法、决定、事件、待办）
- 包含需要记忆的信息

**判断后：**
- 简单回应 → 直接回复用户，不需要存储
- 值得存储 → 继续下一步

## 第二步：保存语音文件（必需！）

**先保存到 raw/voice/，再处理！**

```bash
# 如果语音已在本地
cp /path/to/recording.m4a raw/voice/$(date +%Y-%m-%d)-voice.m4a

# 如果是 AI 收到的附件，正确命名后保存
```

## 第三步：转录

```bash
tools/voice_to_text.sh raw/voice/具体文件名.m4a
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
