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

## 定时自动提醒（OpenClaw Cron）

OpenClaw 支持 cron 定时任务，可以自动提醒你待办事项。

### 查看 cron 命令

```bash
openclaw cron --help
openclaw cron list        # 查看已有任务
openclaw cron runs        # 查看执行历史
```

### 设置每日待办提醒

每天早上 9 点自动检查 wiki/log.md 里的 pending 任务，推送到你的频道：

```bash
openclaw cron add \
  --name "第二大脑-每日待办" \
  --cron "0 9 * * *" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "读取 wiki/log.md 里所有 status=pending 的任务，以简洁列表格式输出今日待办，列出每个任务的时间、标题和关联项目" \
  --announce \
  --channel <你的频道> \
  --to "<目标ID>"
```

### 设置每周健康检查

每周日晚上 8 点自动运行健康检查：

```bash
openclaw cron add \
  --name "第二大脑-周检" \
  --cron "0 20 * * 0" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "运行 ./tools/doctor.sh 检查 wiki/ 目录结构，报告：1) 缺失的目录 2) 本周新增内容数量 3) 是否有未完成的任务" \
  --announce \
  --channel <你的频道> \
  --to "<目标ID>"
```

### Cron 表达式说明

| 表达式 | 含义 |
|--------|------|
| `0 9 * * *` | 每天 9:00 |
| `0 20 * * 0` | 每周日 20:00 |
| `30 9 * * 1-5` | 工作日 9:30 |
| `0 */2 * * *` | 每 2 小时 |

### 执行模式

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| `isolated` | 隔离子会话，推荐 | 后台任务、报告生成 |
| `main` | 主会话 | 简单提醒、系统事件 |

### 交付方式

| 方式 | 说明 |
|------|------|
| `--announce --channel telegram` | 发送到 Telegram |
| `--announce --channel slack` | 发送到 Slack |
| `--webhook https://xxx` | POST 到 URL |

### 实用定时任务示例

```bash
# 重要日程提前 1 小时提醒
openclaw cron add \
  --name "日程提醒-产品评审" \
  --at "2026-04-10T14:00:00+08:00" \
  --session main \
  --system-event "日程提醒：今天下午3点产品评审会议" \
  --wake now

# 每月末整理归档
openclaw cron add \
  --name "第二大脑-月末归档" \
  --cron "0 22 28-31 * *" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "检查 wiki/ 下所有超过3个月未更新的页面，列出可归档的内容建议" \
  --announce \
  --channel <你的频道> \
  --to "<目标ID>"
```

---

*详细处理模板见各 `process/*.md` 文件*
