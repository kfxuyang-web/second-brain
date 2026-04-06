# MEMORY.md — 第二大脑入口

> **所有输入的统一入口。收到内容时按此流程处理。**

---

## 输入类型

| 类型 | 特征 | 处理 |
|-----|------|------|
| URL/网页 | `https://` | `process/article.md` + `tools/fetch_content.sh` |
| 图片 | `.png/.jpg/...` 或 base64 | `process/image.md` |
| 语音 | `.mp3/.wav/.m4a/...` | `process/voice.md` |
| 文件 | `.pdf/.doc/.txt/...` | `process/file.md` |
| 推文/短文字 | 灵感碎片 | `process/tweet.md` |
| 聊天记录 | 对话片段 | `process/chat.md` |
| 日程/TODO | 有时间或截止 | `process/task.md` |

---

## 流程（6步）

1. **判断类型** → 用上表判断
2. **读取规则** → 首次/不确定时读 `reference.md`，日常直接用 `process/*.md`
3. **执行处理** → 调用对应 `process/*.md`
4. **PARA 分类** → projects(有截止) / areas(持续) / resources(感兴趣) / archives(已完成)
5. **写入 wiki** → `wiki/{para}/YYYY-MM-DD-slug.md` + 更新 `wiki/index.md`
6. **交叉链接** → 必需！写入前搜索 wiki，已有相关内容必须链接

---

## 快速示例

```
摄入 https://x.com/user/status/123 → fetch_content.sh → tweet.md → PARA判断 → wiki写入
摄入 https://youtube.com/watch?v=xxx → yt-dlp字幕 → article.md → PARA判断 → wiki写入
"4月底完成产品" → tweet.md → projects/ (有截止) → wiki/projects/
"下周三2点会议" → task.md → 日程 due: → wiki/projects/
```

---

*详细规则见 `reference.md`（首次阅读，日常不用重复读）*
