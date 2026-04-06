# Second Brain — AI 配置

> 当 AI 在此目录下运行时，参考此文件。

---

## 概述

第二大脑 = **LLM Wiki**（增量累积）+ **PARA**（分类）

**核心文件**：
- `MEMORY.md` — 入口流程（日常使用）
- `reference.md` — 规范规则（首次阅读）
- `process/*.md` — 7种内容类型的处理模板
- `wiki/` — 知识库（PARA 分类索引）

---

## PARA 分类

- **projects/** — 有目标 + 截止日期
- **areas/** — 持续责任
- **resources/** — 感兴趣暂无行动
- **archives/** — 已完成/放弃

---

## 处理流程

```
收到内容 → MEMORY.md判断类型 → process/*.md处理 → PARA分类 → 写入wiki/{para}/ → 交叉链接 → 更新index/log
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
└── extract_file_meta.sh # 文件元数据
```

---

## 交叉链接

**必须！** 写入新页面之前，搜索 wiki 是否有相关已有页面，有则链接。

---

*Last Updated: 2026-04-06*
