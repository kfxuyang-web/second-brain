# Second Brain — LLM Wiki + PARA 双核驱动的个人知识库

> [English README](README_EN.md) | 用 OpenClaw 或 Claude Code 打造第二大脑，让 AI 自动维护你的知识库。

## 核心理念

这个项目整合两个强大理论：

1. **Karpathy's LLM Wiki** — AI 增量构建和维护知识库，不是每次重新检索，而是持续累积
2. **PARA 方法** (Tiago Forte) — 用 Projects/Areas/Resources/Archives 四类组织所有信息

## 特点

- **三层 Memory 架构** — Token 节省，不需要把全部内容给 LLM
- **自动分类** — 所有内容自动按 PARA 分类
- **本地存储** — 所有数据在本地，不上传云端
- **AI 辅助** — 把内容粘贴给 AI，AI 参考文档自动处理

---

## 快速开始

### 前置要求

- [OpenClaw](https://github.com/opencodeai/openclaw) 或 [Claude Code](https://claude.ai/code)
- 可选：SenseVoice / Whisper（语音识别）
- 可选：exiftool（图片元数据）
- 可选：yt-dlp（YouTube/B站字幕下载）
- 可选：[Agent-Reach](https://github.com/Panniantong/Agent-Reach)（Twitter/公众号/小红书）
- 可选：Obsidian（可视化浏览 wiki）

### 安装

```bash
git clone https://github.com/YOUR_USERNAME/second-brain.git
cd second-brain
./setup.sh
```

### 启动第二大脑

**方法 1：在 Claude Code 中（推荐）**

```bash
cd second-brain
claude
# Claude Code 会自动读取 CLAUDE.md
```

**方法 2：在 OpenClaw 中**

```bash
cd second-brain
openclaw
# OpenClaw 会自动读取 CLAUDE.md
```

**方法 3：复制粘贴**

1. 打开 `MEMORY.md`，复制全部内容
2. 粘贴给 AI："请用这个 MEMORY.md 作为参考处理我的内容"

### 测试

启动后，说：

```
请帮我把 https://example.com/article 摄入第二大脑
```

AI 会读取 MEMORY.md，按流程处理并写入 wiki。

---

## 使用方式

把内容粘贴给 OpenClaw/Claude Code，AI 会参考 MEMORY.md 自动处理：

```
# 摄入一篇网页文章
请帮我把 https://example.com/article 摄入第二大脑

# 保存一个想法
请把这个想法记录到第二大脑：我想研究 AI Agent 的设计模式

# 保存一张图片
请帮我保存这张图片到第二大脑 [附加图片]

# 设置日程提醒
下周三下午2点有个产品评审会，请记录到第二大脑

# 搜索知识库
请在第二大脑里搜索 AI Agent 相关内容

# 健康检查
请运行 ./tools/doctor.sh 检查第二大脑状态
```

---

## 目录结构

```
second-brain/
├── CLAUDE.md              # AI 配置（告诉 AI 这是什么项目）
├── MEMORY.md              # Layer 1: 入口路由
├── reference.md           # Layer 2: LLM Wiki + PARA 规则
├── README.md              # 本文件
│
├── wiki/                   # 你的知识库
│   ├── index.md          # 内容索引
│   ├── log.md            # 操作日志
│   ├── projects/         # PARA: Projects
│   ├── areas/            # PARA: Areas
│   ├── resources/         # PARA: Resources
│   └── archives/          # PARA: Archives
│
├── raw/                   # 原始素材（git 不跟踪）
│   ├── articles/
│   ├── tweets/
│   ├── voice/
│   ├── images/
│   └── files/
│
├── process/               # Layer 3: 类型处理脚本
│   ├── article.md
│   ├── tweet.md
│   ├── voice.md
│   ├── image.md
│   ├── file.md
│   ├── chat.md
│   └── task.md            # 日程/TODO
│
├── tools/                 # 命令行工具
│   ├── doctor.sh          # 健康检查 + 自我修复
│   ├── backup.sh          # raw/ 备份
│   ├── voice_to_text.sh   # 语音转文字
│   ├── extract_exif.sh    # 提取图片 EXIF
│   ├── extract_file_meta.sh # 提取文件元数据
│   ├── fetch_url.sh       # 抓取网页
│   └── extract_pdf_text.sh # 提取 PDF 文字
│
└── .claude/
    └── commands/          # 命令参考文档
```

---

## Content Types（7 种内容类型）

| 类型 | 处理文件 | 特色元数据 |
|------|---------|-----------|
| article | `process/article.md` | source URL |
| tweet/text | `process/tweet.md` | — |
| voice | `process/voice.md` | `duration`, `transcript` |
| image | `process/image.md` | `taken_at`, `location`, `camera` |
| file | `process/file.md` | `created_at`, `size`, `pages` |
| chat | `process/chat.md` | `participants`, `platform` |
| task | `process/task.md` | `due`, `deadline`, `status` |

---

## PARA 分类

| 类型 | 定义 | 示例 |
|------|------|------|
| **Projects** | 有目标 + 截止日期 | 产品发布、学习计划 |
| **Areas** | 持续责任，无截止日期 | 健康、财务、职业发展 |
| **Resources** | 感兴趣，暂无行动 | 研究主题、待读文章 |
| **Archives** | 已完成/放弃/休眠 | 旧项目、历史资料 |

---

## 工具使用

### Agent-Reach 安装（支持 Twitter/公众号/小红书）

```bash
# 告诉 Claude Code/OpenClaw：
# "帮我安装 Agent Reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md"

# 安装后验证：
agent-reach doctor
```

### 健康检查（定期运行）

```bash
# 检查
./tools/doctor.sh

# 自动修复问题
./tools/doctor.sh --fix
```

### 语音转文字

```bash
./tools/voice_to_text.sh recording.m4a transcript.txt
```

### 提取图片 EXIF

```bash
./tools/extract_exif.sh photo.jpg
```

### 备份 raw/ 目录

```bash
./tools/backup.sh                      # 备份到 ~/second-brain-backups
./tools/backup.sh /path/to/backups     # 备份到指定位置
```

---

## raw/ 文件备份

raw/ 目录包含原始素材（图片、语音、文件等），默认被 .gitignore 忽略，不会推送到 Git。

**备份方案：**

1. **本地备份**：定期运行 `./tools/backup.sh`
2. **云备份**：配置 rclone 备份到云存储（Google Drive、S3 等）
3. **Git LFS**：将 raw/ 改为用 Git LFS 跟踪（适合文件较少的场景）

**推荐工作流：**
```bash
# 1. 定期备份
./tools/backup.sh

# 2. 设置定时任务（每周日凌晨2点自动备份）
(crontab -l 2>/dev/null; echo "0 2 * * 0 cd $PWD && ./tools/backup.sh") | crontab -
```

---

## 与 Obsidian 配合

Obsidian 是浏览 wiki 的最佳工具：

1. 用 Obsidian 打开 `second-brain/` 目录
2. 享受图形化图谱视图
3. 安装推荐插件：
   - **Dataview** — 查询 wiki 数据（按日期/标签/PARA 筛选）
   - **Templater** — 自动化模板

### Obsidian Dataview 查询示例

```dataview
-- 上周的照片
TABLE taken_at, location, para
FROM "wiki"
WHERE type = "image" AND taken_at >= 2026-03-25
SORT taken_at DESC

-- 所有待完成的任务
TABLE due, deadline, status, para
FROM "wiki"
WHERE type = "task" AND status != "completed"
SORT due ASC
```

---

## 常见问题

**Q: AI 怎么知道要读取这些文件？**
A: Claude Code 会自动读取项目目录下的 CLAUDE.md。OpenClaw 需要设置工作目录为 second-brain。

**Q: 能自动处理内容吗？**
A: 目前是"参考文档模式"——把内容粘贴给 AI，AI 参考 MEMORY.md 自动处理。真正的自动化需要配置 MCP server 或文件监听。

**Q: raw/ 文件会被 git 跟踪吗？**
A: 默认不会（.gitignore 已配置）。运行 `./tools/backup.sh` 单独备份。

**Q: 支持中文吗？**
A: 完全支持。PARA 分类、图片 EXIF、语音识别（SenseVoice/Whisper）都支持中文。

---

## 理论参考

- [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [PARA Method — Forte Labs](https://fortelabs.com/blog/para/)

## License

MIT

---

*用 AI 构建知识，让知识产生智慧。*
