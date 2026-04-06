#!/bin/bash
# upgrade.sh — 第二大脑升级脚本
# 安全升级：保留用户的 wiki/、raw/、log.md，只更新代码文件

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "============================================"
echo "       Second Brain 升级脚本"
echo "============================================"
echo ""

# 检查是否是 git 仓库
if [ ! -d ".git" ]; then
    echo -e "${RED}错误: 不是 Git 仓库，无法升级${NC}"
    echo "请用以下命令初始化："
    echo "  git init"
    echo "  git remote add origin https://github.com/zhiwehu/second-brain.git"
    exit 1
fi

# 检查是否有 remote
REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [ -z "$REMOTE" ]; then
    echo -e "${RED}错误: 未设置 remote origin${NC}"
    echo "请先设置："
    echo "  git remote add origin https://github.com/zhiwehu/second-brain.git"
    exit 1
fi

echo -e "${BLUE}当前仓库:${NC} $REMOTE"
echo ""

# 确认要升级
echo -e "${YELLOW}升级前请确保已提交所有更改！${NC}"
echo ""
read -p "继续升级？[y/N] " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "取消升级"
    exit 0
fi

echo ""
echo "--------------------------------------------"
echo "拉取最新代码..."
echo "--------------------------------------------"

# 先 stash 用户的数据（如果有未提交的更改）
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}发现未提交的更改，先 stash...${NC}"
    git stash push -m "auto-stash before upgrade $(date +%Y-%m-%d)"
fi

# Fetch latest
git fetch origin

# 查看有哪些文件会被更新
echo ""
echo -e "${BLUE}即将更新的文件:${NC}"
git diff --stat origin/main...HEAD -- ':!wiki' ':!raw' ':!wiki/log.md' 2>/dev/null || true

# 尝试 rebase 或 merge
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${YELLOW}当前在 $CURRENT_BRANCH 分支，切换到 main...${NC}"
    git checkout main
fi

echo ""
echo "执行 git pull..."
if git pull --rebase origin main; then
    echo -e "${GREEN}✓ 升级成功${NC}"
else
    echo -e "${RED}升级遇到冲突，请手动解决后运行 $0 重新升级${NC}"
    exit 1
fi

# 恢复 stash（如果之前有）
if git stash list | grep -q "auto-stash before upgrade"; then
    echo ""
    echo -e "${YELLOW}恢复之前暂存的更改...${NC}"
    git stash pop
fi

echo ""
echo "--------------------------------------------"
echo "检查是否需要重新注入 OpenClaw..."
echo "--------------------------------------------"

# 重新注入到 OpenClaw（会自动跳过已注入的）
if command -v bash &> /dev/null; then
    bash "$PROJECT_DIR/setup.sh" --inject-only 2>/dev/null || true
fi

echo ""
echo "============================================"
echo -e "     ${GREEN}升级完成！${NC}"
echo "============================================"
echo ""
echo "如需查看改动："
echo "  git log --oneline origin/main...HEAD"
echo ""
echo "如需查看升级说明："
echo "  git show origin/main:README.md | head -50"
echo ""
