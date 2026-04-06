# 第二大脑 — 开发者指南

> 给需要手动安装或贡献代码的开发者的详细说明。

---

## 手动安装

### 克隆仓库

```bash
git clone https://github.com/zhiwehu/second-brain.git
cd second-brain
```

### 运行安装脚本

```bash
./setup.sh
./setup.sh --fix  # 自动修复目录结构等问题
```

安装脚本会：
- 检查依赖工具
- 创建 `wiki/` 和 `raw/` 目录结构
- 设置工具脚本权限
- 注入第二大脑引用到 OpenClaw 全局 MEMORY.md
- 初始化 Git 仓库（可选）

### 启动第二大脑

**在 Claude Code 中：**

```bash
cd second-brain
claude
# Claude Code 会自动读取 CLAUDE.md
```

**在 OpenClaw 中：**

```bash
cd second-brain
openclaw
# OpenClaw 会自动读取 CLAUDE.md
```

**手动复制粘贴：**

1. 打开 `MEMORY.md`，复制全部内容
2. 粘贴给 AI："请用这个 MEMORY.md 作为参考处理我的内容"

---

## 目录结构详解

```
second-brain/
├── CLAUDE.md              # AI 配置（Claude Code/OpenClaw 专用）
├── MEMORY.md              # Layer 1: 入口路由（通用）
├── reference.md           # Layer 2: LLM Wiki + PARA 规则
│
├── wiki/                  # 知识库（用户数据，不推送到 Git）
│   ├── index.md         # 内容索引（AI 每次摄入时更新）
│   ├── log.md          # 操作日志（追加制）
│   ├── projects/       # PARA: Projects（有目标+截止）
│   ├── areas/          # PARA: Areas（持续责任）
│   ├── resources/      # PARA: Resources（感兴趣暂无行动）
│   └── archives/        # PARA: Archives（已完成/放弃）
│
├── raw/                   # 原始素材（用户数据，不推送到 Git）
│   ├── articles/       # 网页文章
│   ├── tweets/          # 推文
│   ├── voice/           # 语音
│   ├── images/          # 图片
│   └── files/           # 文档
│
├── process/              # Layer 3: 内容类型处理器
│   ├── article.md       # 网页文章
│   ├── tweet.md         # 推文/短内容
│   ├── voice.md         # 语音
│   ├── image.md         # 图片
│   ├── file.md          # 文件
│   ├── chat.md          # 聊天记录
│   └── task.md          # 日程/TODO
│
├── tools/               # 命令行工具
│   ├── doctor.sh        # 健康检查 + 自动修复
│   ├── backup.sh        # raw/ 备份
│   ├── voice_to_text.sh # 语音转文字（SenseVoice/Whisper）
│   ├── extract_exif.sh  # 图片 EXIF 提取
│   ├── extract_file_meta.sh # 文件元数据
│   ├── fetch_url.sh    # 网页抓取
│   ├── fetch_content.sh # 智能内容获取
│   └── extract_pdf_text.sh # PDF 文本提取
│
└── .claude/
    └── commands/         # OpenClaw 命令参考
```

---

## 三层 Memory 架构

```
Layer 1: MEMORY.md（入口路由）
    ↓ 判断类型
Layer 2: reference.md（PARA 规则 + Wiki 格式）
    ↓ 按类型分发
Layer 3: process/*.md（具体处理器）
    ↓ 写入
wiki/{para}/（知识库）
```

详见 `reference.md`。

---

## PARA 方法

| 类型 | 定义 | 示例 |
|------|------|------|
| **Projects** | 有目标 + 截止日期 | 产品发布、学习计划 |
| **Areas** | 持续责任，无截止日期 | 健康、财务、职业发展 |
| **Resources** | 感兴趣，暂无行动 | 研究主题、待读文章 |
| **Archives** | 已完成/放弃/休眠 | 旧项目、历史资料 |

---

## 升级

```bash
./upgrade.sh
```

upgrade.sh 会：
1. 检查未提交的更改并 stash
2. `git fetch + pull --rebase` 获取最新代码
3. 恢复 stash
4. 重新注入 OpenClaw MEMORY.md

**重要：** `wiki/` 和 `raw/` 目录被 .gitignore 忽略，用户的知识库数据不会被覆盖。

---

## 工具详情

### 语音转文字

```bash
./tools/voice_to_text.sh recording.m4a transcript.txt
```

支持：SenseVoice（Ollama）、Whisper

### 备份

```bash
./tools/backup.sh                      # 备份到 ~/second-brain-backups
./tools/backup.sh /path/to/backups     # 备份到指定位置

# 定时备份（每周日凌晨2点）
(crontab -l 2>/dev/null; echo "0 2 * * 0 cd $PWD && ./tools/backup.sh") | crontab -
```

### 健康检查

```bash
./tools/doctor.sh        # 检查
./tools/doctor.sh --fix  # 自动修复
```

---

## 内容摄入流程

当用户说"帮我存到第二大脑"时：

1. **判断类型** → 根据内容特征判断（推文/文章/图片等）
2. **获取内容** → 抓取 URL / 保存附件 / 转录音频
3. **生成摘要** → LLM 生成 50 字摘要 + 核心要点
4. **PARA 分类** → 判断属于 Projects/Areas/Resources/Archives
5. **写入 wiki** → `wiki/{para}/YYYY-MM-DD-slug.md`
6. **交叉链接** → 搜索 wiki 已有内容，添加链接
7. **更新 index** → 在 `wiki/index.md` 添加条目
8. **记录 log** → 在 `wiki/log.md` 顶部追加条目

---

## 理论参考

- [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [PARA Method — Forte Labs](https://fortelabs.com/blog/para/)

---

## License

MIT
