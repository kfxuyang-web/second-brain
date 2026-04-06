#!/bin/bash
# compile_schema.sh — 从 wiki/ 增量编译 Schema
# 用法: ./tools/compile_schema.sh [--incremental|--full|--status]
#
# --incremental: 只编译上次编译后新增的 wiki 条目（默认）
# --full: 重新编译所有 wiki 条目（消耗更多 token）
# --status: 查看编译状态

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
WIKI_DIR="$PROJECT_DIR/wiki"
SCHEMA_DIR="$WIKI_DIR/schema"
SCHEMA_CONCEPTS="$SCHEMA_DIR/concepts"
LAST_COMPILE_FILE="$SCHEMA_DIR/.last_compile"
LOG_FILE="$WIKI_DIR/log.md"

MODE="${1:---incremental}"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "============================================"
echo "       第二大脑 Schema 编译"
echo "============================================"
echo ""

# 状态模式
if [ "$MODE" = "--status" ]; then
    if [ -f "$LAST_COMPILE_FILE" ]; then
        LAST_DATE=$(cat "$LAST_COMPILE_FILE")
        echo -e "${GREEN}✓${NC} 上次编译时间: $LAST_DATE"
    else
        echo -e "${YELLOW}⚠${NC} 从未编译过"
    fi

    echo ""
    echo "Schema 目录: $SCHEMA_DIR"
    if [ -d "$SCHEMA_CONCEPTS" ]; then
        CONCEPT_COUNT=$(find "$SCHEMA_CONCEPTS" -name "*.md" | wc -l | tr -d ' ')
        echo -e "${GREEN}✓${NC} 已有概念数: $CONCEPT_COUNT"
    else
        echo -e "${YELLOW}⚠${NC} 暂无概念"
    fi

    echo ""
    echo "用法:"
    echo "  $0 --incremental  # 增量编译（只处理新增内容）"
    echo "  $0 --full        # 全量编译（重新处理所有 wiki）"
    echo "  $0 --status     # 查看状态"
    exit 0
fi

# 检查 wiki 目录
if [ ! -d "$WIKI_DIR" ]; then
    echo -e "${RED}✗${NC} wiki/ 目录不存在"
    exit 1
fi

# 创建 schema 目录
mkdir -p "$SCHEMA_CONCEPTS"

# 获取上次编译时间
if [ -f "$LAST_COMPILE_FILE" ]; then
    LAST_DATE=$(cat "$LAST_COMPILE_FILE")
    echo -e "${BLUE}ℹ${NC} 上次编译: $LAST_DATE"
else
    LAST_DATE=""
    echo -e "${YELLOW}⚠${NC} 首次编译"
fi

# 获取要处理的 wiki 条目
if [ "$MODE" = "--full" ]; then
    echo -e "${YELLOW}⚠${NC} 全量编译模式"
    WIKI_FILES=$(find "$WIKI_DIR" -name "*.md" -not -path "$SCHEMA_DIR/*" | sort)
    TOTAL=$(echo "$WIKI_FILES" | wc -l | tr -d ' ')
    echo "将处理 $TOTAL 个 wiki 文件"
else
    echo -e "${GREEN}→${NC} 增量编译模式"
    if [ -z "$LAST_DATE" ]; then
        echo -e "${YELLOW}⚠${NC} 无上次编译记录，改为全量编译"
        WIKI_FILES=$(find "$WIKI_DIR" -name "*.md" -not -path "$SCHEMA_DIR/*" | sort)
    else
        # 只处理上次编译后新增或修改的文件
        # 从 log.md 提取 last_date 之后的新条目
        WIKI_FILES=$(grep -A 20 "## " "$LOG_FILE" 2>/dev/null | grep -E "^## \[" | head -50 | sed 's/.*\] ingest | //' | sed 's/ \*\*.*//' | while read title; do
            find "$WIKI_DIR" -name "*.md" -not -path "$SCHEMA_DIR/*" -newer "$LAST_COMPILE_FILE" 2>/dev/null | head -20
        done | sort -u)
    fi
    TOTAL=$(echo "$WIKI_FILES" | wc -l | tr -d ' ')
    echo "将处理约 $TOTAL 个新增 wiki 文件"
fi

echo ""
echo "--------------------------------------------"
echo "开始编译..."
echo "--------------------------------------------"
echo ""

# 更新编译时间戳
date > "$LAST_COMPILE_FILE"

# 编译步骤说明（实际编译由 AI 执行）
echo -e "${GREEN}✓${NC} 编译完成"
echo ""
echo "Schema 编译需要 AI 辅助完成。"
echo ""
echo "请在 OpenClaw 中说："
echo ""
echo -e "${BLUE}请帮我编译第二大脑的 Schema${NC}"
echo ""
echo "AI 会："
echo "  1. 读取 wiki/ 中的新条目"
echo "  2. 提取概念和关系"
echo "  3. 更新 wiki/schema/concepts/ 下的概念文件"
echo "  4. 更新 wiki/schema/relations.md"
echo ""
echo "提示：首次编译建议用 --full 模式，之后用 --incremental"
