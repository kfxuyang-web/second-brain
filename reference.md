# reference.md — LLM Wiki 规范 + PARA 规则

> 新 session 开始时阅读一次。日常使用只需参考 MEMORY.md。

---

## PARA 分类

| 类型 | 定义 | 判断 |
|-----|------|------|
| **P** Projects | 有明确目标 + 截止日期 | 全部条件满足？目标+截止+主动行动 |
| **A** Areas | 持续责任，无截止日期 | 持续维护的责任范围 |
| **R** Resources | 感兴趣，暂无行动 | 有趣但无行动 |
| **A** Archives | 已完成/放弃/休眠 | 已完成或 >3个月无更新 |

**核心：Resources → Areas → Projects → Archives**（按行动程度流动）

---

## Wiki 页面格式

```markdown
---
date: {{date}}
type: {{type}}       # article/tweet/voice/image/file/chat/task
para: {{para}}       # projects/areas/resources/archives
tags: [{{tags}}]
source: {{url}}     # 可选
---

# {{标题}}

## 摘要
{{50字内核心}}

## 关键内容
{{要点}}

## 相关
- [[wiki/{para}/xxx]]   # 交叉链接
- 来源: {{url}}
```

**Task 特有字段**：`due: YYYY-MM-DD HH:MM`（日程）或 `deadline: YYYY-MM-DD`（TODO）

---

## 目录结构

```
wiki/
├── index.md          # PARA 分类索引（自动更新）
├── log.md            # 操作日志
├── projects/         # 有目标+截止
├── areas/           # 持续责任
├── resources/       # 感兴趣
└── archives/        # 已完成
```

**命名**：`YYYY-MM-DD-{slug}.md`

---

## 交叉链接（必须）

写入新页面之前：**必须**搜索 wiki 是否有相关已有页面。

- 有 → 添加 `[[wiki/{para}/xxx]]` 链接
- 新内容推翻/补充旧内容 → 在旧页面也添加注释
- 无 → 创建新页面

---

## 平台内容获取

| 平台 | 命令 |
|-----|------|
| 普通网页 | `tools/fetch_url.sh <url>` |
| Twitter/X | `agent-reach --read <url>` |
| YouTube/B站 | `yt-dlp --write-auto-sub --skip-download <url>` |
| 公众号/小红书 | `agent-reach --read <url>` |

**安装**：`brew install yt-dlp`；agent-reach 见 README

---

## 工具位置

```
tools/
├── doctor.sh           # 健康检查 + 修复
├── backup.sh          # raw/ 备份
├── fetch_content.sh   # 智能识别平台获取
├── voice_to_text.sh  # 语音转文字
├── extract_exif.sh   # 图片 EXIF
├── extract_file_meta.sh # 文件元数据
└── extract_pdf_text.sh # PDF 文字
```

---

*详细处理模板见各 `process/*.md` 文件*
