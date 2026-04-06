#!/bin/bash
# upgrade.sh — 第二大脑升级脚本
# 支持两种模式：
#   1. Fork 用户：从上游仓库（upstream）拉取更新
#   2. 原作者：从 origin 拉取更新
# 安全升级：保留用户的 wiki/、raw/、wiki/log.md

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
    echo ""
    echo "如需初始化："
    echo "  git init"
    echo "  git remote add origin https://github.com/zhiwehu/second-brain.git"
    exit 1
fi

# 检测升级模式
UPSTREAM_URL=$(git remote get-url upstream 2>/dev/null || echo "")
ORIGIN_URL=$(git remote get-url origin 2>/dev/null || echo "")

echo -e "${BLUE}检测 Git 远程仓库...${NC}"
echo "  origin:  $ORIGIN_URL"
echo "  upstream: $UPSTREAM_URL"
echo ""

if [ -n "$UPSTREAM_URL" ]; then
    # Fork 用户模式：从 upstream 拉取
    echo -e "${GREEN}检测为 Fork 用户模式${NC}"
    UPSTREAM_REMOTE="upstream"
    echo -e "${YELLOW}将从 upstream 拉取更新：$UPSTREAM_URL${NC}"
elif [ -n "$ORIGIN_URL" ]; then
    # 原作者模式：从 origin 拉取
    echo -e "${GREEN}检测为原作者模式${NC}"
    UPSTREAM_REMOTE="origin"
else
    echo -e "${RED}错误: 未设置任何 remote${NC}"
    echo "请确保已设置 remote："
    echo "  git remote add origin https://github.com/YOUR_USERNAME/second-brain.git"
    exit 1
fi

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
echo "保存当前分支状态..."
echo "--------------------------------------------"

# 检查未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}发现未提交的更改，先 stash...${NC}"
    git stash push -m "auto-stash before upgrade $(date +%Y-%m-%d)"
fi

# 获取远程更新
echo ""
echo "--------------------------------------------"
echo "从 $UPSTREAM_REMOTE 拉取最新代码..."
echo "--------------------------------------------"

git fetch "$UPSTREAM_REMOTE"

# 切换到 main 分支
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${YELLOW}切换到 main 分支...${NC}"
    git checkout main
fi

# 查看即将更新的内容
echo ""
echo -e "${BLUE}即将更新的文件:${NC}"
git diff --stat "$UPSTREAM_REMOTE/main...HEAD" -- ':!wiki' ':!raw' ':!wiki/log.md' 2>/dev/null || true

# 合并（使用 rebase 保持历史整洁）
echo ""
if git pull --rebase "$UPSTREAM_REMOTE" main; then
    echo -e "${GREEN}✓ 升级成功${NC}"
else
    echo -e "${RED}升级遇到冲突，请手动解决后运行 $0 重新升级${NC}"
    echo ""
    echo "手动解决冲突步骤："
    echo "  1. 编辑冲突文件"
    echo "  2. git add <冲突文件>"
    echo "  3. git rebase --continue"
    echo "  4. 解决完后运行 $0"
    exit 1
fi

# 恢复 stash（如果之前有）
if git stash list | grep -q "auto-stash before upgrade"; then
    echo ""
    echo -e "${YELLOW}恢复之前暂存的更改...${NC}"
    git stash pop
fi

# 重新注入 OpenClaw
echo ""
echo "--------------------------------------------"
echo "检查是否需要重新注入 OpenClaw..."
echo "--------------------------------------------"

if command -v bash &> /dev/null; then
    bash "$PROJECT_DIR/setup.sh" --inject-only 2>/dev/null || true
fi

# 可选：重新设置定时任务（仅当 openclaw 可用时）
if command -v openclaw &> /dev/null && [ -t 0 ]; then
    echo ""
    echo "--------------------------------------------"
    echo "检查定时任务..."
    echo "--------------------------------------------"
    CRON_COUNT=$(openclaw cron list 2>/dev/null | grep -c "第二大脑" || echo "0")
    if [ "$CRON_COUNT" -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} 已检测到 $CRON_COUNT 个第二大脑定时任务"
    else
        echo -e "  ${YELLOW}⚠ 未检测到第二大脑定时任务${NC}"
        read -p "是否现在设置？[y/N] " SETUP_CRON
        if [[ "$SETUP_CRON" =~ ^[Yy]$ ]]; then
            if command -v bash &> /dev/null; then
                bash "$PROJECT_DIR/setup.sh" 2>/dev/null
            fi
        fi
    fi
fi

echo ""
echo "============================================"
echo -e "     ${GREEN}升级完成！${NC}"
echo "============================================"
echo ""
echo "如需查看本次更新内容："
echo "  git log --oneline $UPSTREAM_REMOTE/main...HEAD"
echo ""
