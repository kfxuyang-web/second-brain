# 第二大脑

> 用 AI 自动维护你的知识库。说一句话，AI 帮你收藏、整理、分类。

[**🇺🇸 English**](README.md) · [**Twitter:** @zhiwehu](https://twitter.com/zhiwehu)

---

## 一句话安装

**在 OpenClaw 或 Claude Code 中说：**

```
请帮我从 https://github.com/zhiwehu/second-brain 安装第二大脑
```

AI 会自动：克隆 → 配置 → 注入 → 完成。

---

## 功能一览

| 怎么说 | 怎么做 |
|--------|--------|
| `帮我把这段话存到第二大脑：[内容]` | 保存内容并自动分类 |
| `帮我保存这个链接：[URL]` | 获取内容、摘要、保存 |
| `在第二大脑里搜索 AI 相关内容` | 语义搜索所有知识 |
| `帮我把截图存到第二大脑` | 提取文字、保存图片+元数据 |
| `帮我保存语音备忘` | 转录、摘要、存储 |
| `帮我保存会议记录` | 提取决策、行动项 |
| `运行健康检查` | 检查 wiki 健康、修复问题 |
| `编译 schema` | 从 wiki 构建知识图谱 |

**支持 7 种内容：** 推文 · 文章 · 图片 · 语音 · 文件 · 聊天 · 任务

---

## 工作原理

```
你说 "帮我保存" → AI 处理 → 存入知识库
         ↓
    原始文件保存（图片、音频、文档）
         ↓
    AI 提取关键信息
         ↓
    按 PARA 分类（项目/领域/资源/归档）
         ↓
    写入 wiki + 交叉链接 + 记录日志
```

**PARA 分类：** AI 自动判断内容归属：
- **Projects（项目）** — 有截止日期的活跃目标
- **Areas（领域）** — 持续承担责任
- **Resources（资源）** — 感兴趣的主题
- **Archives（归档）** — 已完成或放弃的内容

---

## 三层架构

```
第一层：raw/          → 原始文件（图片、音频、推文）
第二层：wiki/         → 处理后的知识（摘要、链接）
第三层：wiki/schema/  → 概念和关系（每周编译）
```

---

## 安装（一句话搞定）

**在 OpenClaw 或 Claude Code 中说：**

```
请帮我从 https://github.com/zhiwehu/second-brain 安装第二大脑
```

AI 会自动：
1. 克隆仓库
2. 运行安装脚本
3. 注入到你的 AI 系统
4. 完成

---

## 使用方法

安装好后，直接对 AI 说：

```
请帮我把这段话存入第二大脑：[内容]
请保存这个链接到第二大脑：[URL]
请在第二大脑里搜索 AI 相关内容
帮我把那张截图存到第二大脑
把今天的会议记录存入第二大脑
```

---

## 支持的内容类型

| 类型 | 示例 |
|------|------|
| 推文 | 微博、Twitter、灵感 |
| 文章 | 博客、新闻、网页 |
| 图片 | 截图、照片（提取 EXIF） |
| 语音 | 录音（转录成文字） |
| 文件 | PDF、Word、Excel |
| 聊天 | 会议记录、聊天记录 |
| 任务 | 日程、TODO（截止日期） |

---

## 升级

```
请帮我升级第二大脑
```

---

## 健康检查

```
请运行第二大脑的健康检查
```

或手动运行：

```bash
./tools/doctor.sh
./tools/doctor.sh --fix  # 自动修复问题
```

---

## 定时提醒

使用 OpenClaw cron 设置自动提醒：

```bash
# 每日待办提醒（早上9点）
openclaw cron add \
  --name "第二大脑-每日待办" \
  --cron "0 9 * * *" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "读取 wiki/log.md 列出今日待办" \
  --announce --channel <你的频道> --to "<目标>"

# 每周健康检查（周日晚上8点）
openclaw cron add \
  --name "第二大脑-周检" \
  --cron "0 20 * * 0" \
  --tz "Asia/Shanghai" \
  --session isolated \
  --message "运行 ./tools/doctor.sh 检查结果" \
  --announce --channel <你的频道> --to "<目标>"
```

---

## Schema 编译

第三层架构 — 从 Wiki 中提取概念和关系：

```
帮我编译第二大脑的 Schema
```

这会提取：
- **概念**（人名、产品名、方法论、技术名词）
- **关系**（影响、支持、使用、属于）
- **属性**（领域、类型、首次出现）

当你的 Wiki 积累了一定内容后运行：

```bash
./tools/compile_schema.sh --status  # 查看状态
./tools/compile_schema.sh --incremental  # 增量编译（推荐）
./tools/compile_schema.sh --full  # 全量编译
```

---

## 目录结构

第二大脑采用双目录架构：

```
second-brain-source/    # 源代码目录（从 GitHub clone）
├── tools/             # 工具脚本
├── process/           # AI 处理模板
├── setup.sh           # 安装脚本
├── upgrade.sh         # 升级脚本
└── CLAUDE.md          # AI 配置

~/second-brain/        # 数据目录（你的第二大脑）
├── .git/              # 独立 git 仓库（用 git 管理你的数据）
├── wiki/              # 你的知识库
│   ├── projects/      #   正在做的项目
│   ├── areas/         #   持续关注的事
│   ├── resources/     #   感兴趣的内容
│   ├── archives/      #   已完成/归档的
│   └── schema/        #   概念和关系
├── raw/               # 原始素材（图片/语音/文件等）
└── ...                # 复制的代码文件
```

**关键点：**
- `second-brain-source/` 是干净的源代码，用 git 管理你的 fork
- `~/second-brain/` 是你的数据，用独立的 git 管理你的知识库
- 运行 `setup.sh` 后自动创建数据目录

**Git 管理：**
```bash
# 管理你的数据
cd ~/second-brain
git status
git add .
git commit -m '添加新内容'
git push            # 推送到你的私有 GitHub/Gitee

# 升级源代码
cd second-brain-source
git fetch upstream
./upgrade.sh
```

---

## Obsidian 配合使用

用 **Obsidian** 可视化浏览你的知识库：

1. 打开 Obsidian
2. 点击"打开本地仓库" → 选择 `~/second-brain/` 文件夹（你的数据目录）
3. Obsidian 会显示 `wiki/` 下所有 `.md` 文件
4. 非 Markdown 文件（`.sh`、图片等）会自动隐藏

**推荐安装的 Obsidian 插件：**
- **Dataview** — 动态查询 wiki 数据
- **Templater** — 自动化模板
- **Obsidian Git** — 自动备份到 Git（推送到你的私有仓库）

**使用提示：** OpenClaw/Claude Code 和 Obsidian 共用你的数据目录（`~/second-brain/`）。OpenClaw 负责 AI 处理，Obsidian 提供可视化图谱视图。

---

## 可选工具

安装以下工具可获得完整功能：

| 工具 | 功能 | 安装 |
|------|------|------|
| Whisper | 语音转文字 | `pip3 install whisper` |
| exiftool | 图片元数据 | `brew install exiftool` |
| yt-dlp | YouTube/B站字幕 | `brew install yt-dlp` |
| agent-reach | Twitter/小红书/公众号 | 见下方 |
| qmd | 语义搜索（推荐）| `npm install -g @tobilu/qmd` |

**agent-reach 安装：**

```
请帮我安装 agent-reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

**qmd 安装：**

```bash
npm install -g @tobilu/qmd
qmd collection add $(pwd)/wiki --name second-brain
qmd embed
```

---

## 推荐浏览器插件

### Obsidian Web Clipper

一键将网页文章转为 Markdown：

1. 安装 [Obsidian Web Clipper](https://obsidian.md/clipper) 扩展
2. 配置保存到 `second-brain/raw/articles/`
3. 浏览时一键剪藏 → 直接进入 raw/

大幅提升摄入速度 — 先剪藏，后处理。

### 图片本地下载

剪藏文章后下载图片：
1. Obsidian 设置 → 文件与链接 → 设置"附件文件夹路径"为 `raw/assets/`
2. 绑定快捷键：搜索"下载" → "下载当前文件的附件"
3. 剪藏后按快捷键 → 所有图片本地保存

这样 LLMs 可以直接从本地文件查看图片。

---

## 从 Wiki 生成 PPT

用 [Marp](https://marp.app/) 从 wiki 内容生成演示文稿：

1. 在 Obsidian 中安装 Marp 插件
2. 用 Marp 语法写 markdown
3. 导出为 PPT/PDF

示例：
```markdown
---
marp: true
theme: default
---

# 我的演示

- 要点1
- 要点2
```

直接从积累的知识生成幻灯片。

---

## 常见问题

**Q: 我的数据存在哪里？**
A: 在 `~/second-brain/wiki/` 和 `~/second-brain/raw/` 目录里。数据用独立的 git 仓库管理，可以 push 到你私有的 GitHub/Gitee。

**Q: 源代码和数据为什么分开？**
A: 这样你可以在不影响数据的情况下升级代码。源代码在 `second-brain-source/`，你的数据在 `~/second-brain/`。

**Q: 需要手动维护吗？**
A: 不需要。AI 会自动更新索引和日志。你只需要定期 `git push` 备份你的数据。

**Q: 第二大脑和普通笔记有什么区别？**
A: 第二大脑会帮你自动分类（PARA 方法），记住内容之间的关系，还会定期检查健康状态。

**Q: 如何升级？**
A: 下载最新源代码到 `second-brain-source/`，然后运行 `./upgrade.sh`。你的 wiki/ 和 raw/ 数据不会丢失。

**Q: Schema 是什么？什么时候编译？**
A: Schema 是第三层架构 — 从你的 Wiki 内容中提取概念和关系。建议每周编译一次，用 `@compile` 命令或运行 `./tools/compile_schema.sh --incremental`。

---

## 理论基础

- [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [PARA Method — Forte Labs](https://fortelabs.com/blog/para/)

---

## Fork 和贡献

**想保持最新版本，同时想贡献代码？**

### 第一步：Fork 仓库
点击 [github.com/zhiwehu/second-brain](https://github.com/zhiwehu/second-brain) 上的 "Fork" 按钮

### 第二步：克隆你的 fork 到源代码目录
```bash
git clone https://github.com/YOUR_USERNAME/second-brain.git second-brain-source
cd second-brain-source
```

### 第三步：运行安装脚本
```bash
./setup.sh
```
这会：
1. 创建你的数据目录（`~/second-brain/`）
2. 初始化 git 仓库管理你的数据
3. 可选：推送到你的私有 GitHub

### 第四步：添加上游仓库（保持同步）
```bash
git remote add upstream https://github.com/zhiwehu/second-brain.git
```

### 第五步：升级
当有更新时，运行：
```bash
cd second-brain-source
./upgrade.sh
```
这会从原仓库拉取最新代码并覆盖到你的数据目录，**你的 wiki/ 和 raw/ 数据保持不变**。

### 第六步：贡献代码（可选）
如果你修复了 bug 或添加了新功能，可以在 GitHub 上提交 Pull Request！

---

## 给程序员的说明

如果你想手动安装或贡献代码，见 [README_DEV.md](README_DEV.md)（英文）或 [README_DEV_ZH.md](README_DEV_ZH.md)（中文）。

英文版：[English README](README.md) / [English Developer Guide](README_DEV.md)
