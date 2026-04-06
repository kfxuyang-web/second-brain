# 第二大脑

> 用 AI 自动维护你的知识库。说一句话，AI 帮你收藏、整理、分类。

**Twitter:** [@zhiwehu](https://twitter.com/zhiwehu)

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

**支持的内容类型：**
- 推文 / 灵感 / 想法
- 文章 / 链接
- 截图 / 图片
- 语音备忘
- PDF / 文档
- 聊天记录 / 会议记录
- 日程 / TODO

**AI 会自动：**
- 获取内容
- 判断类型（推文/文章/图片等）
- 按 PARA 分类（Projects/Areas/Resources/Archives）
- 写入知识库
- 更新索引和日志

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

## 目录结构

```
second-brain/
├── wiki/           # 你的知识库（按 PARA 分类）
│   ├── projects/   # 正在做的项目
│   ├── areas/     # 持续关注的事
│   ├── resources/ # 感兴趣的内容
│   └── archives/  # 已完成/归档的
├── raw/           # 原始素材（图片/语音/文件等）
└── tools/         # 工具（健康检查/备份等）
```

---

## 可选工具

安装以下工具可获得完整功能：

| 工具 | 功能 | 安装 |
|------|------|------|
| Whisper | 语音转文字 | `pip3 install whisper` |
| exiftool | 图片元数据 | `brew install exiftool` |
| yt-dlp | YouTube/B站字幕 | `brew install yt-dlp` |
| agent-reach | Twitter/小红书/公众号 | 见下方 |

**agent-reach 安装：**

```
请帮我安装 agent-reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
```

---

## 常见问题

**Q: 我的数据存在哪里？**
A: 在 `wiki/` 和 `raw/` 目录里，都在本地，不上传到云端。

**Q: 需要手动维护吗？**
A: 不需要。AI 会自动更新索引和日志。

**Q: 第二大脑和普通笔记有什么区别？**
A: 第二大脑会帮你自动分类（PARA 方法），记住内容之间的关系，还会定期检查健康状态。

---

## 理论基础

- [Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [PARA Method — Forte Labs](https://fortelabs.com/blog/para/)

---

## Fork 和贡献

**想保持最新版本，同时想贡献代码？**

### 第一步：Fork 仓库
点击 [github.com/zhiwehu/second-brain](https://github.com/zhiwehu/second-brain) 上的 "Fork" 按钮

### 第二步：克隆你的 fork
```bash
git clone https://github.com/YOUR_USERNAME/second-brain.git
cd second-brain
```

### 第三步：添加上游仓库
```bash
git remote add upstream https://github.com/zhiwehu/second-brain.git
```

### 第四步：升级
当有更新时，运行：
```bash
./upgrade.sh
```
这会从原仓库拉取最新更改并合并到你的版本。

### 第五步：贡献代码（可选）
如果你修复了 bug 或添加了新功能，可以在 GitHub 上提交 Pull Request！

---

## 给程序员的说明

如果你想手动安装或贡献代码，见 [README_DEV.md](README_DEV.md)（英文）或 [README_DEV_ZH.md](README_DEV_ZH.md)（中文）。

英文版：[English README](README.md) / [English Developer Guide](README_DEV.md)
