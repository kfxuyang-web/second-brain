#!/bin/bash
# tools/init_data_repo.sh — 初始化用户的数据目录
#
# 用途：
#   1. 从当前目录（源代码目录）复制目录结构到用户的数据目录
#   2. 创建完整的 PARA 目录结构
#   3. 初始化 git 仓库
#   4. 可选：添加 remote 推送到用户的私有 GitHub
#
# 使用：./tools/init_data_repo.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/config.sh"

# 加载配置
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

DATA_DIR="${SECOND_BRAIN_DATA_DIR:-$HOME/second-brain}"

echo "============================================"
echo "       初始化第二大脑数据目录"
echo "============================================"
echo ""
echo -e "${BLUE}源代码目录:${NC} $PROJECT_DIR"
echo -e "${BLUE}数据目录:${NC} $DATA_DIR"
echo ""

# 检测是否是新用户还是升级用户
UPGRADE_MODE=false
if [ -d "$DATA_DIR" ]; then
    # 检查是否有用户数据（wiki 或 raw 下有内容）
    HAS_WIKI_DATA=false
    HAS_RAW_DATA=false

    if [ -d "$DATA_DIR/wiki" ] && [ "$(ls -A "$DATA_DIR/wiki" 2>/dev/null)" ]; then
        # 检查是否有非空文件或非 .gitkeep 文件
        for f in "$DATA_DIR/wiki"/*; do
            if [ -f "$f" ] && [ "$(basename "$f")" != ".gitkeep" ]; then
                HAS_WIKI_DATA=true
                break
            fi
        done
    fi

    if [ -d "$DATA_DIR/raw" ] && [ "$(ls -A "$DATA_DIR/raw" 2>/dev/null)" ]; then
        for f in "$DATA_DIR/raw"/*; do
            if [ -d "$f" ] && [ "$(ls -A "$f" 2>/dev/null)" ]; then
                HAS_RAW_DATA=true
                break
            fi
        done
    fi

    if [ "$HAS_WIKI_DATA" = true ] || [ "$HAS_RAW_DATA" = true ]; then
        UPGRADE_MODE=true
        echo -e "${YELLOW}检测到现有第二大脑数据（升级模式）${NC}"
        echo ""
        echo "现有数据："
        [ "$HAS_WIKI_DATA" = true ] && echo "  ✓ wiki/ 有内容"
        [ "$HAS_RAW_DATA" = true ] && echo "  ✓ raw/ 有内容"
        echo ""
        echo "脚本将："
        echo "  1. 保留你的 wiki/ 和 raw/ 内容"
        echo "  2. 用新代码覆盖 tools/, process/, 等"
        echo "  3. 重新初始化 git（创建新的提交历史）"
        echo ""
        read -p "继续？[Y/n] " CONFIRM
        CONFIRM="${CONFIRM:-Y}"
        if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
            echo "取消"
            exit 0
        fi
    fi
fi

# 检查数据目录是否已存在且是新的 git 仓库
if [ -d "$DATA_DIR/.git" ] && [ "$UPGRADE_MODE" = false ]; then
    echo -e "${GREEN}✓${NC} 检测到数据目录已是 git 仓库: $DATA_DIR"
    echo ""
    echo "如果需要重新初始化，请先删除 $DATA_DIR/.git"
    exit 0
fi

# 创建数据目录（如果不存在）
if [ ! -d "$DATA_DIR" ]; then
    echo "创建数据目录: $DATA_DIR"
    mkdir -p "$DATA_DIR"
fi

echo ""
echo "--------------------------------------------"
echo "第一步: 复制目录结构"
echo "--------------------------------------------"

if [ "$UPGRADE_MODE" = true ]; then
    # 升级模式：只复制代码目录，保留用户的 wiki/ 和 raw/
    echo "复制新代码到数据目录（保留 wiki/ 和 raw/）..."

    for item in "$PROJECT_DIR"/*; do
        item_name=$(basename "$item")
        if [ "$item_name" != ".git" ] && [ "$item_name" != "wiki" ] && [ "$item_name" != "raw" ]; then
            cp -r "$item" "$DATA_DIR/"
        fi
    done

    # 如果 source 有 wiki 和 raw 但用户没有，创建空目录
    for subdir in projects areas resources archives schema; do
        mkdir -p "$DATA_DIR/wiki/$subdir"
        touch "$DATA_DIR/wiki/$subdir/.gitkeep"
    done
    for subdir in articles tweets voice images files chats; do
        mkdir -p "$DATA_DIR/raw/$subdir"
        touch "$DATA_DIR/raw/$subdir/.gitkeep"
    done

    echo -e "${GREEN}✓${NC} 新代码已复制，用户数据已保留"
else
    # 新用户模式：完整复制
    echo "复制源代码结构..."
    for item in "$PROJECT_DIR"/*; do
        item_name=$(basename "$item")
        if [ "$item_name" != ".git" ] && [ "$item_name" != "wiki" ] && [ "$item_name" != "raw" ]; then
            cp -r "$item" "$DATA_DIR/"
        fi
    done

    # 创建 wiki 和 raw 目录结构
    mkdir -p "$DATA_DIR/wiki/projects"
    mkdir -p "$DATA_DIR/wiki/areas"
    mkdir -p "$DATA_DIR/wiki/resources"
    mkdir -p "$DATA_DIR/wiki/archives"
    mkdir -p "$DATA_DIR/wiki/schema"
    mkdir -p "$DATA_DIR/raw/articles"
    mkdir -p "$DATA_DIR/raw/tweets"
    mkdir -p "$DATA_DIR/raw/voice"
    mkdir -p "$DATA_DIR/raw/images"
    mkdir -p "$DATA_DIR/raw/files"
    mkdir -p "$DATA_DIR/raw/chats"

    # 创建初始文件
    cat > "$DATA_DIR/wiki/index.md" << 'EOF'
# Wiki Index

> 第二大脑的内容总索引，按 PARA 分类。每次摄入新内容时由 AI 更新此文件。
EOF

    cat > "$DATA_DIR/wiki/log.md" << 'EOF'
# Wiki Log

> 第二大脑的操作日志。追加制，按时间倒序。
EOF

    # 创建 .gitkeep 文件
    for subdir in projects areas resources archives schema; do
        touch "$DATA_DIR/wiki/$subdir/.gitkeep"
    done
    for subdir in articles tweets voice images files chats; do
        touch "$DATA_DIR/raw/$subdir/.gitkeep"
    done

    echo -e "${GREEN}✓${NC} 目录结构已复制"
fi

echo ""
echo "--------------------------------------------"
echo "第二步: 创建 wiki 和 raw 目录结构"
echo "--------------------------------------------"

# 创建完整的 PARA 目录结构
mkdir -p "$DATA_DIR/wiki/projects"
mkdir -p "$DATA_DIR/wiki/areas"
mkdir -p "$DATA_DIR/wiki/resources"
mkdir -p "$DATA_DIR/wiki/archives"
mkdir -p "$DATA_DIR/wiki/schema"
mkdir -p "$DATA_DIR/raw/articles"
mkdir -p "$DATA_DIR/raw/tweets"
mkdir -p "$DATA_DIR/raw/voice"
mkdir -p "$DATA_DIR/raw/images"
mkdir -p "$DATA_DIR/raw/files"
mkdir -p "$DATA_DIR/raw/chats"

# 创建初始文件
cat > "$DATA_DIR/wiki/index.md" << 'EOF'
# Wiki Index

> 第二大脑的内容总索引，按 PARA 分类。每次摄入新内容时由 AI 更新此文件。

---

## Projects (有明确目标 + 截止日期)

> 需要主动推进、有明确完成标志的项目

| 日期 | 标题 | 标签 | 状态 |
|------|------|------|------|
| — | — | — | — |

---

## Areas (持续责任)

> 需要持续维护、无明确截止日期的责任范围

| 日期 | 标题 | 标签 | 最后更新 |
|------|------|------|----------|
| — | — | — | — |

---

## Resources (感兴趣但暂无行动)

> 感兴趣的主题、待读内容、研究方向

| 日期 | 标题 | 标签 | 来源 |
|------|------|------|------|
| — | — | — | — |

---

## Archives (已完成/放弃/休眠)

> 已完成的项目、不再活跃的领域、过时内容

| 日期 | 标题 | 原分类 | 归档原因 |
|------|------|--------|----------|
| — | — | — | — |

---

## 最近更新

> 最近 10 条记录

| 日期 | 标题 | PARA | 类型 |
|------|------|------|------|
| — | — | — | — |

---

*最后更新: {{date}}*
EOF

cat > "$DATA_DIR/wiki/log.md" << 'EOF'
# Wiki Log

> 第二大脑的操作日志。追加制，按时间倒序。

---

## 使用说明

每次摄入新内容后，在此文件顶部追加条目。

### 条目格式

```markdown
## [{{date}}] {{type}} | {{title}}

- **类型:** {{input_type}} (article/tweet/voice/image/file/chat)
- **PARA:** {{para_category}} (projects/areas/resources/archives)
- **文件:** {{wiki_file_path}}
- **摘要:** {{brief_summary}}
- **操作:** ingest
```

---

## 日志

<!-- 新条目添加在下面 -->

EOF

# 创建 .gitkeep 文件
touch "$DATA_DIR/wiki/projects/.gitkeep"
touch "$DATA_DIR/wiki/areas/.gitkeep"
touch "$DATA_DIR/wiki/resources/.gitkeep"
touch "$DATA_DIR/wiki/archives/.gitkeep"
touch "$DATA_DIR/wiki/schema/.gitkeep"
touch "$DATA_DIR/raw/articles/.gitkeep"
touch "$DATA_DIR/raw/tweets/.gitkeep"
touch "$DATA_DIR/raw/voice/.gitkeep"
touch "$DATA_DIR/raw/images/.gitkeep"
touch "$DATA_DIR/raw/files/.gitkeep"
touch "$DATA_DIR/raw/chats/.gitkeep"

echo -e "${GREEN}✓${NC} wiki/ 和 raw/ 目录结构已创建"

echo ""
echo "--------------------------------------------"
echo "第三步: 初始化 git 仓库"
echo "--------------------------------------------"

cd "$DATA_DIR"

# 配置 git（如果没配置过）
git config --local user.name "Second Brain User" 2>/dev/null || true
git config --local user.email "user@secondbrain.local" 2>/dev/null || true

# 如果是升级模式且已有 .git，先删除（重新开始）
if [ "$UPGRADE_MODE" = true ] && [ -d ".git" ]; then
    echo "重新初始化 git 仓库..."
    rm -rf .git
fi

# 初始化仓库
if [ ! -d ".git" ]; then
    git init
fi

# 添加所有文件
git add .

# 初始提交
if [ "$UPGRADE_MODE" = true ]; then
    git commit -m "Second brain initialized with new architecture"
else
    git commit -m "Initial commit: second brain initialized"
fi

echo -e "${GREEN}✓${NC} git 仓库已初始化"

echo ""
echo "--------------------------------------------"
echo "第四步: 设置远程仓库（可选）"
echo "--------------------------------------------"

echo ""
echo -e "${YELLOW}是否将数据仓库推送到 GitHub？${NC}"
echo ""
echo "推荐：创建一个私有的 GitHub/Gitee 仓库来备份你的第二大脑"
echo ""
read -p "输入远程仓库 URL（直接回车跳过）: " REMOTE_URL

if [ -n "$REMOTE_URL" ]; then
    git remote add origin "$REMOTE_URL"
    git branch -M main

    if git push -u origin main 2>&1; then
        echo -e "${GREEN}✓${NC} 已推送到远程仓库"
    else
        echo -e "${YELLOW}⚠ 推送失败，请稍后手动推送：${NC}"
        echo "  cd $DATA_DIR"
        echo "  git remote add origin <你的仓库URL>"
        echo "  git push -u origin main"
    fi
else
    echo "跳过远程设置。你可以稍后手动添加："
    echo "  cd $DATA_DIR"
    echo "  git remote add origin <你的仓库URL>"
    echo "  git push -u origin main"
fi

echo ""
echo "============================================"
echo -e "     ${GREEN}✓ 数据目录初始化完成！${NC}"
echo "============================================"
echo ""
echo -e "${BLUE}你的第二大脑:${NC} $DATA_DIR"
echo ""
echo "常用命令："
echo "  cd $DATA_DIR"
echo "  git status          # 查看状态"
echo "  git add .           # 添加更改"
echo "  git commit -m '...' # 提交"
echo "  git push            # 推送到远程"
echo ""
echo -e "${BLUE}升级第二大脑:${NC}"
echo "  1. 下载最新源代码到 second-brain-source/"
echo "  2. 运行 second-brain-source/upgrade.sh"
echo ""
