# Lint Command

> 检查第二大脑 wiki 的健康度。

## 使用方法

```
@lint
@lint full      # 完整检查
@lint quick     # 快速检查
```

## 检查清单

### 快速检查 (quick)
- [ ] `wiki/index.md` 是否与实际页面同步
- [ ] `wiki/log.md` 格式是否正确
- [ ] 是否有孤儿页面（未被引用的页面）
- [ ] 是否有陈旧页面（超过 30 天未更新）

### 完整检查 (full)

#### 1. 矛盾检查
搜索可能存在矛盾的页面：
- 同一主题的不同页面说法是否一致
- 新内容是否推翻旧结论

#### 2. 陈旧检查
- 标记超过 30 天未更新的页面
- 确认是否需要更新或归档

#### 3. 孤儿检查
- 找出没有被任何页面引用的页面
- 判断是否需要添加引用或归档

#### 4. 引用检查
- 是否有提到某概念但没有链接到相关页面
- 建议添加交叉引用

#### 5. 数据空白检查
- 是否有重要主题尚未覆盖
- 建议下一步研究/收集方向

## 输出格式

```markdown
## Lint 结果 — {{date}}

### 快速检查
- [✓] index.md 已同步
- [✓] log.md 格式正确
- [⚠] 2 个孤儿页面
- [✓] 无陈旧页面

### 完整检查

#### ⚠ 需要关注
1. **wiki/resources/ai-agent.md** — 提到 OpenClaw 但无链接
2. **wiki/projects/second-brain.md** — 超过 30 天未更新

#### 💡 建议
1. 在 ai-agent.md 添加 [[wiki/projects/openclaw-research]] 链接
2. 更新 second-brain.md 或归档

#### 📊 统计
- 总页面: 12
- Projects: 3
- Areas: 2
- Resources: 5
- Archives: 2
```

## 自动执行

建议**每周运行一次** `@lint full`，保持 wiki 健康。

---

*See also: `@ingest` 摄入新内容, `@search` 检索内容*
