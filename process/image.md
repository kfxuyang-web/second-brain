# process/image.md — 图片

**适用**：照片、截图、图表、PPT截图

## 获取元数据

```bash
tools/extract_exif.sh <image_file>    # 自动检测 exiftool/imagemagick/sips
```

**必提字段**：`taken_at`、`location`、`camera`
**截图/网络图片**：从文件名推断日期，标注 `source: 截图`

## Wiki 格式

```markdown
---
date: {{date}}
type: image
para: {{para}}
tags: [{{tags}}]
source: raw/images/{{filename}}
taken_at: {{YYYY-MM-DD HH:MM}}    # 拍摄时间
location: {{地点}}                 # 拍摄地点
camera: {{相机/手机}}              # 可选
---

# {{主题}}

![{{描述}}](raw/images/{{filename}})

## 基本信息
- 时间: {{taken_at}}
- 地点: {{location}}
- 设备: {{camera}}

## 描述
{{LLM详细描述}}

## 分析
{{为什么重要}}
```

## PARA 判断

| 图片类型 | 类型 |
|---------|------|
| 产品原型/项目截图 | projects |
| 健康/财务数据截图 | areas |
| 灵感图/知识图表 | resources |
| 历史截图 | archives |

## 查询示例

```
# 上周在合肥拍的关于鸟的照片
grep -r "location: 合肥" wiki/ | grep -r "鸟"
grep -r "taken_at: 2026-03" wiki/
```
