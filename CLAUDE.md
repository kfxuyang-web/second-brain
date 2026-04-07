# Second Brain — AI 配置

> 当 AI 在此目录下运行时，参考此文件。

---

## 架构说明

第二大脑采用双目录架构：

```
second-brain-source/    # 从 GitHub clone 的源代码（你的 fork）
├── tools/             #   工具脚本
├── process/           #   处理模板
├── CLAUDE.md          #   AI 配置
├── setup.sh           #   安装脚本
└── upgrade.sh         #   升级脚本

~/second-brain/        # 你的第二大脑（你的数据，用 git 管理）
├── .git/              #   独立 git 仓库
├── wiki/              #   知识库（你的数据）
├── raw/               #   原始素材（你的数据）
└── ...                #   复制的代码文件
```

**重要：** 源代码目录和数据目录是分离的。

---

## 数据位置

运行时从 `config.sh` 读取数据目录路径：

```bash
source "$(dirname "$0")/config.sh"
DATA_DIR="${SECOND_BRAIN_DATA_DIR:-$HOME/second-brain}"
```

- **默认：** `${HOME}/second-brain`
- **可配置：** 修改 `config.sh` 中的 `SECOND_BRAIN_DATA_DIR`

---

## PARA 分类

- **projects/** — 有目标 + 截止日期
- **areas/** — 持续责任
- **resources/** — 感兴趣，暂无行动
- **archives/** — 已完成/放弃/休眠

---

## 处理流程

```
收到内容 → MEMORY.md判断类型 → process/*.md处理 → PARA分类 → 写入$DATA_DIR/wiki/{para}/ → 交叉链接 → 更新index/log
```

---

## 7 种内容类型

`article` | `tweet` | `voice` | `image` | `file` | `chat` | `task`

详细模板见各 `process/*.md` 文件。

---

## 工具

```
tools/
├── doctor.sh              # 健康检查
├── backup.sh             # raw/ 备份
├── fetch_content.sh      # 智能获取（URL/推文/视频）
├── voice_to_text.sh     # 语音转文字
├── extract_exif.sh       # 图片 EXIF
├── extract_file_meta.sh # 文件元数据
└── init_data_repo.sh     # 初始化数据目录
```

---

## Git 管理

**用户的第二大脑使用独立的 git 仓库：**

```bash
cd ~/second-brain
git status        # 查看状态
git add .         # 添加更改
git commit -m '...'  # 提交
git push          # 推送到远程
```

**源代码目录**（second-brain-source/）用于：
- 从原作者仓库拉取更新
- 运行升级脚本

**不要** 将数据目录 push 到开源仓库！

---

## 交叉链接

**必须！** 写入新页面之前，搜索 wiki 是否有相关已有页面，有则链接。

---

*Last Updated: 2026-04-07*
