# Ingest Command

> 摄入新内容到第二大脑。

## 使用方法

```
@ingest [内容类型] [内容]
```

## 示例

```
@ingest url https://example.com/article
@ingest text 我今天学到了关于 LLM Wiki 的重要概念
@ingest image [附加图片]
@ingest voice [附加语音]
@ingest file [附加文件]
```

## 执行流程

1. 判断输入类型（URL/文字/图片/语音/文件）
2. 读取 `MEMORY.md` 了解处理规则
3. 读取 `reference.md` 了解 PARA 分类
4. 调用对应的 `process/*.md` 进行处理
5. 在 `wiki/log.md` 记录操作
6. 更新 `wiki/index.md`

## 处理说明

### @ingest url [URL]
调用 `process/article.md`：
- 获取页面内容
- 生成摘要
- 判断 PARA 分类
- 写入 `wiki/{para}/`

### @ingest text [文字]
调用 `process/tweet.md`：
- 分析内容
- 判断 PARA 分类
- 写入 `wiki/{para}/`

### @ingest image [图片]
调用 `process/image.md`：
- 保存到 `raw/images/`
- 生成图片描述
- 判断 PARA 分类
- 写入 `wiki/{para}/`

### @ingest voice [语音]
调用 `process/voice.md`：
- 使用 SenseVoice 转录
- 调用 `process/tweet.md` 处理
- 判断 PARA 分类
- 写入 `wiki/{para}/`

### @ingest file [文件]
调用 `process/file.md`：
- 提取文件内容
- 生成摘要
- 判断 PARA 分类
- 写入 `wiki/{para}/`

## 自动触发

当用户发送任何内容时，如果内容值得保存，**自动调用此命令**，无需手动输入 `@ingest`。

---

*See also: `@search` 检索内容, `@lint` 健康检查*
