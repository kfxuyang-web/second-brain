# MEMORY.md — 第二大脑入口

> **所有输入的统一入口。收到内容时按此流程处理。**

---

## 核心原则

**raw/ 保存必须先于 wiki 写入！**

每种内容类型都必须先保存原始文件到 `raw/` 目录，再创建 wiki 条目。
**顺序不能颠倒！**

---

## 流程（7步）

1. **判断类型** → 根据内容特征判断
2. **读取规则** → 读 `process/*.md`
3. **保存 raw** → **必需第一步！** 先把原始文件保存到 `raw/` 对应目录
4. **执行处理** → 提取内容、生成摘要
5. **PARA 分类** → projects / areas / resources / archives
6. **写入 wiki** → `wiki/{para}/YYYY-MM-DD-slug.md`
7. **更新 index + log** → 更新 `wiki/index.md` 和 `wiki/log.md`
8. **交叉链接** → 必需！搜索 wiki 已有内容并链接

---

## 流程图

```
收到内容
    ↓
判断类型（图片/文章/语音/文件/推文/聊天/任务）
    ↓
┌─────────────────────────────────────┐
│  必需第一步：保存 raw 文件          │
│  图片 → raw/images/                │
│  语音 → raw/voice/                │
│  文件 → raw/files/                 │
│  文章 → raw/articles/              │
│  推文 → raw/tweets/               │
│  聊天 → raw/chats/                │
└─────────────────────────────────────┘
    ↓
调用 process/*.md 处理
    ↓
PARA 分类
    ↓
写入 wiki/
    ↓
更新 index.md + log.md
    ↓
建立交叉链接
```

---

## 输入类型

| 类型 | 特征 | Raw 保存目录 | 处理 |
|-----|------|-------------|------|
| 图片 | `.png/.jpg/...` 或附件 | `raw/images/` | `process/image.md` |
| 语音 | `.mp3/.wav/.m4a/...` | `raw/voice/` | `process/voice.md` |
| 文件 | `.pdf/.doc/.txt/...` | `raw/files/` | `process/file.md` |
| URL/网页 | `https://` | `raw/articles/` | `process/article.md` |
| 推文 | 短文字/灵感 | `raw/tweets/` | `process/tweet.md` |
| 聊天记录 | 对话片段 | `raw/chats/` | `process/chat.md` |
| 日程/TODO | 有时间或截止 | — | `process/task.md` |

---

## 快速示例

```
收到图片 → 保存到 raw/images/ → extract_exif.sh → image.md → wiki写入
收到语音 → 保存到 raw/voice/ → voice_to_text.sh → voice.md → wiki写入
收到 PDF → 保存到 raw/files/ → extract_pdf_text.sh → file.md → wiki写入
收到推文 → 保存到 raw/tweets/ → tweet.md → wiki写入
```

---

## ⚠️ 常见错误

**错误：** 只创建 wiki 条目，跳过保存 raw 文件。

**后果：** 原始文件丢失，只有 wiki 摘要，没有原始素材。

**正确做法：** 无论什么内容，**必须先保存 raw，再写 wiki**。

---

*详细规则见 `reference.md`*