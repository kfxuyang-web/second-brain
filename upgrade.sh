#!/bin/bash
# upgrade.sh — 第二大脑升级脚本
#
# 架构：
#   second-brain-source/ — 从 GitHub clone 的源代码（你的仓库）
#   ~/second-brain/       — 你的第二大脑（你的数据）
#
# 升级流程：
#   1. 从上游（原作者仓库）拉取最新源代码到 second-brain-source/
#   2. 将新代码覆盖到你的 ~/second-brain/
#   3. 你的 wiki/ 和 raw/ 数据保持不变
#
# 用法: ./upgrade.sh [--check]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SOURCE_DIR/config.sh"

# 加载数据目录配置
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

DATA_DIR="${SECOND_BRAIN_DATA_DIR:-$HOME/second-brain}"

echo "============================================"
echo "       Second Brain 升级脚本"
echo "============================================"
echo ""
echo -e "${BLUE}源代码目录:${NC} $SOURCE_DIR"
echo -e "${BLUE}数据目录:${NC} $DATA_DIR"
echo ""

# 检查是否在源代码目录
if [ ! -f "$SOURCE_DIR/MEMORY.md" ] || [ ! -f "$SOURCE_DIR/tools/init_data_repo.sh" ]; then
    echo -e "${RED}错误: 请在源代码目录运行此脚本${NC}"
    echo ""
    echo "如果你是在数据目录运行，请先切换到源代码目录："
    echo "  cd second-brain-source"
    echo "  ./upgrade.sh"
    exit 1
fi

# 检查数据目录是否存在
if [ ! -d "$DATA_DIR" ]; then
    echo -e "${RED}错误: 数据目录不存在${NC}"
    echo ""
    echo "请先运行 setup.sh 初始化数据目录："
    echo "  ./setup.sh"
    exit 1
fi

# 检查数据目录是否是 git 仓库
if [ ! -d "$DATA_DIR/.git" ]; then
    echo -e "${YELLOW}警告:${NC} 数据目录 $DATA_DIR 不是 git 仓库"
    echo "建议先初始化 git："
    echo "  cd $DATA_DIR"
    echo "  git init"
    echo "  git add ."
    echo "  git commit -m 'Initial commit'"
    echo ""
    read -p "继续升级？[y/N] " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# 检查上游仓库
check_upstream() {
    echo ""
    echo "--------------------------------------------"
    echo "检查上游仓库..."
    echo "--------------------------------------------"

    UPSTREAM_URL=$(git remote get-url upstream 2>/dev/null || echo "")
    ORIGIN_URL=$(git remote get-url origin 2>/dev/null || echo "")

    echo "  origin:   $ORIGIN_URL"
    echo "  upstream: $UPSTREAM_URL"

    if [ -z "$UPSTREAM_URL" ]; then
        echo ""
        echo -e "${YELLOW}未检测到上游仓库${NC}"
        echo ""
        echo "如果没有 fork 原作者的仓库，请先添加上游："
        echo "  git remote add upstream https://github.com/zhiwehu/second-brain.git"
        echo ""
        echo "如果有 fork，请确保 upstream 指向原作者仓库"
        echo ""
        read -p "是否继续（不拉取上游更新）？[y/N] " CONTINUE
        if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
            exit 0
        fi
        return 1
    fi

    return 0
}

# 拉取上游更新
fetch_upstream() {
    echo ""
    echo "--------------------------------------------"
    echo "拉取上游更新..."
    echo "--------------------------------------------"

    if ! check_upstream; then
        return 1
    fi

    echo "从 upstream 拉取..."
    if git fetch upstream 2>&1; then
        echo -e "${GREEN}✓${NC} 已拉取上游更新"
    else
        echo -e "${YELLOW}⚠ 拉取失败，继续使用本地代码${NC}"
        return 1
    fi

    # 检查是否有更新
    BEHIND=$(git rev-list --count HEAD..upstream/main 2>/dev/null || echo "0")
    if [ "$BEHIND" = "0" ] || [ "$BEHIND" = "" ]; then
        BEHIND=$(git rev-list --count HEAD..upstream/main 2>/dev/null || echo "0")
    fi

    if [ "$BEHIND" -gt 0 ] 2>/dev/null; then
        echo -e "${BLUE}ℹ${NC} 有 $BEHIND 个提交可以更新"
    else
        echo -e "${GREEN}✓${NC} 已是最新版本"
    fi

    return 0
}

# 执行升级
do_upgrade() {
    echo ""
    echo "--------------------------------------------"
    echo "执行升级..."
    echo "--------------------------------------------"

    echo "升级步骤："
    echo "  1. 保存当前数据目录状态"
    echo "  2. 从源代码目录复制新代码"
    echo "  3. 保留你的 wiki/ 和 raw/ 数据"
    echo ""
    read -p "确认升级？[Y/n] " CONFIRM
    CONFIRM="${CONFIRM:-Y}"
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "取消升级"
        exit 0
    fi

    # 进入数据目录，提交当前更改
    echo ""
    echo "步骤 1: 提交当前数据..."
    cd "$DATA_DIR"

    if [ -n "$(git status --porcelain)" ]; then
        echo "有未提交的更改，先暂存..."
        git stash push -m "auto-stash before upgrade $(date +%Y-%m-%d)" 2>/dev/null || true
    fi

    # 复制新代码（排除 wiki/ 和 raw/）
    echo ""
    echo "步骤 2: 复制新代码到数据目录..."
    echo "  保留: wiki/ (你的知识库)"
    echo "  保留: raw/ (你的原始素材)"

    for item in "$SOURCE_DIR"/*; do
        item_name=$(basename "$item")
        if [ "$item_name" != ".git" ] && [ "$item_name" != "wiki" ] && [ "$item_name" != "raw" ]; then
            cp -r "$item" "$DATA_DIR/"
        fi
    done

    echo -e "${GREEN}✓${NC} 新代码已复制"

    # 恢复 stash
    if git stash list | grep -q "auto-stash before upgrade"; then
        echo ""
        echo "步骤 3: 恢复未提交的更改..."
        git stash pop 2>/dev/null || true
    fi

    echo ""
    echo "--------------------------------------------"
    echo "创建升级提交..."
    echo "--------------------------------------------"

    cd "$DATA_DIR"
    git add -A
    git commit -m "Upgrade: updated code from second-brain-source

Updated at: $(date +%Y-%m-%d)
Source: $SOURCE_DIR" 2>/dev/null || true

    echo -e "${GREEN}✓${NC} 升级完成"
}

# 检查模式（只检查，不升级）
check_only() {
    echo ""
    echo "--------------------------------------------"
    echo "检查更新..."
    echo "--------------------------------------------"

    if ! check_upstream; then
        echo -e "${YELLOW}无法检查更新${NC}"
        exit 0
    fi

    git fetch upstream 2>/dev/null || true

    BEHIND=0
    if git rev-parse --verify upstream/main >/dev/null 2>&1; then
        BEHIND=$(git rev-list --count HEAD..upstream/main 2>/dev/null || echo "0")
    fi

    if [ "$BEHIND" -gt 0 ] 2>/dev/null; then
        echo -e "${YELLOW}有 $BEHIND 个提交可以更新${NC}"
        echo ""
        echo "运行 ./upgrade.sh 进行升级"
    else
        echo -e "${GREEN}✓${NC} 已是最新版本"
    fi
}

# 显示帮助
show_help() {
    echo ""
    echo "用法: ./upgrade.sh [选项]"
    echo ""
    echo "选项:"
    echo "  --check    只检查更新，不执行升级"
    echo "  --help     显示此帮助"
    echo ""
    echo "示例:"
    echo "  ./upgrade.sh          # 完整升级"
    echo "  ./upgrade.sh --check  # 检查更新"
}

# 主流程
case "${1:-}" in
    --check)
        check_only
        ;;
    --help)
        show_help
        ;;
    "")
        fetch_upstream
        do_upgrade
        ;;
    *)
        echo -e "${RED}未知选项: $1${NC}"
        show_help
        exit 1
        ;;
esac

echo ""
echo "============================================"
echo -e "     ${GREEN}升级流程结束${NC}"
echo "============================================"
echo ""
echo "后续操作："
echo "  cd $DATA_DIR"
echo "  git status          # 查看状态"
echo "  git log --oneline   # 查看升级历史"
echo "  git push            # 推送到你的远程仓库"
