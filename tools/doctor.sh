#!/bin/bash
# doctor.sh — 第二大脑健康检查与自我修复
# 用法: ./doctor.sh [--fix]
# 不带 --fix 只检查，带 --fix 自动修复

set -e

AUTO_FIX="${1:-}"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 统计
ISSUES=0
FIXES=0

log_check() {
    echo -e "${GREEN}[检查]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[警告]${NC} $1"
    ISSUES=$((ISSUES+1))
}

log_error() {
    echo -e "${RED}[错误]${NC} $1"
    ISSUES=$((ISSUES+1))
}

log_fix() {
    echo -e "${GREEN}[已修复]${NC} $1"
    FIXES=$((FIXES+1))
}

echo "============================================"
echo "         Second Brain Doctor"
echo "============================================"
echo ""

# 1. 检查目录结构
log_check "检查目录结构..."
REQUIRED_DIRS=(
    "wiki/projects"
    "wiki/areas"
    "wiki/resources"
    "wiki/archives"
    "wiki/schema"
    "raw/articles"
    "raw/tweets"
    "raw/voice"
    "raw/images"
    "raw/files"
    "process"
    "commands"
    ".claude/commands"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        log_check "  ✓ $dir"
    else
        log_error "  ✗ 缺失目录: $dir"
        if [ "$AUTO_FIX" == "--fix" ]; then
            mkdir -p "$dir"
            log_fix "已创建: $dir"
        fi
    fi
done

# 2. 检查核心文件
log_check "检查核心文件..."
REQUIRED_FILES=(
    "MEMORY.md"
    "reference.md"
    "CLAUDE.md"
    "README.md"
    "wiki/index.md"
    "wiki/log.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        log_check "  ✓ $file"
    else
        log_error "  ✗ 缺失文件: $file"
    fi
done

# 3. 检查 process 文件
log_check "检查 process 文件..."
PROCESS_FILES=(
    "process/article.md"
    "process/tweet.md"
    "process/voice.md"
    "process/image.md"
    "process/file.md"
    "process/chat.md"
    "process/task.md"
)

for file in "${PROCESS_FILES[@]}"; do
    if [ -f "$file" ]; then
        log_check "  ✓ $file"
    else
        log_error "  ✗ 缺失文件: $file"
    fi
done

# 4. 检查工具依赖
log_check "检查工具依赖..."

check_command() {
    local cmd="$1"
    local name="$2"
    if command -v "$cmd" &> /dev/null; then
        log_check "  ✓ $name"
        return 0
    else
        log_warn "  ✗ $name (未安装)"
        return 1
    fi
}

check_command "curl" "curl"
check_command "git" "git"
check_command "bash" "bash"

# 可选工具
echo ""
log_check "可选工具 (建议安装):"

check_command "ollama" "Ollama (SenseVoice)" || true
check_command "whisper" "Whisper" || true
check_command "exiftool" "exiftool" || true
check_command "pdftotext" "pdftotext (poppler)" || true
check_command "pandoc" "Pandoc" || true
check_command "html2text" "html2text" || true

# 5. 检查 wiki 健康度
log_check "检查 wiki 健康度..."

# 孤儿页面检查（没有被引用的页面）
ORPHAN_COUNT=0
if [ -f "wiki/index.md" ]; then
    # 简单检查：index.md 中列出的页面是否存在
    while IFS= read -r line; do
        # 提取 [[wiki/xxx|yyy]] 格式的链接
        if [[ "$line" =~ \[\[wiki/([^|\]]+) ]]; then
            page="${BASH_REMATCH[1]}"
            if [ ! -f "wiki/$page" ] && [ ! -f "wiki/${page}.md" ]; then
                log_warn "  孤儿页面引用: wiki/$page (文件不存在)"
                ORPHAN_COUNT=$((ORPHAN_COUNT+1))
            fi
        fi
    done < wiki/index.md
fi

if [ $ORPHAN_COUNT -eq 0 ]; then
    log_check "  ✓ 无孤儿页面"
fi

# 6. 检查 log.md 格式
log_check "检查 log.md 格式..."
if [ -f "wiki/log.md" ]; then
    LAST_ENTRY=$(grep -m1 "^## \[" wiki/log.md 2>/dev/null || echo "")
    if [ -n "$LAST_ENTRY" ]; then
        if [[ "$LAST_ENTRY" =~ ^##\ \[202[0-9]-[0-9][0-9]-[0-9][0-9]\] ]]; then
            log_check "  ✓ log.md 格式正确"
        else
            log_warn "  ✗ log.md 最近条目格式可能不正确: $LAST_ENTRY"
        fi
    else
        log_warn "  ! log.md 暂无条目 (首次使用)"
    fi
else
    log_error "  ✗ wiki/log.md 不存在"
fi

# 7. 检查 index.md 同步
log_check "检查 index.md 同步..."
if [ -f "wiki/index.md" ]; then
    # 统计 PARA 目录下的实际文件数
    for para in projects areas resources archives; do
        ACTUAL_COUNT=$(find "wiki/$para" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$ACTUAL_COUNT" -gt 0 ]; then
            INDEXED_COUNT=$(grep -c "\[\[wiki/$para/" wiki/index.md 2>/dev/null || echo "0")
            log_check "  wiki/$para/: $ACTUAL_COUNT 个文件"
        fi
    done
fi

# 8. Git 状态检查
log_check "检查 Git 状态..."
if [ -d ".git" ]; then
    UNTRACKED=$(git status --porcelain 2>/dev/null | grep "^??" | wc -l | tr -d ' ')
    MODIFIED=$(git status --porcelain 2>/dev/null | grep "^.M" | wc -l | tr -d ' ')
    log_check "  ✓ Git 已初始化"
    log_check "  未跟踪文件: $UNTRACKED"
    log_check "  已修改文件: $MODIFIED"

    if [ "$UNTRACKED" -gt 10 ]; then
        log_warn "  未跟踪文件较多，建议检查 .gitignore"
    fi
else
    log_warn "  ! 未初始化 Git，建议运行: git init"
fi

# 9. raw 目录大小
log_check "检查 raw 目录..."
TOTAL_RAW_SIZE=$(du -sh raw 2>/dev/null | cut -f1 || echo "?")
log_check "  raw 目录总大小: $TOTAL_RAW_SIZE"

# 10. 自我修复
if [ "$AUTO_FIX" == "--fix" ]; then
    echo ""
    echo "============================================"
    echo "         开始自动修复"
    echo "============================================"

    # 修复目录权限
    for dir in "${REQUIRED_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            log_fix "创建目录: $dir"
        fi
    done

    # 确保 index.md 存在
    if [ ! -f "wiki/index.md" ]; then
        cat > wiki/index.md << 'INDEX_EOF'
# Wiki Index

> 第二大脑的内容总索引，按 PARA 分类。

## Projects

| 日期 | 标题 | 标签 | 状态 |
|------|------|------|------|

## Areas

| 日期 | 标题 | 标签 | 最后更新 |
|------|------|------|----------|

## Resources

| 日期 | 标题 | 标签 | 来源 |
|------|------|------|------|

## Archives

| 日期 | 标题 | 原分类 | 归档原因 |
|------|------|--------|----------|

INDEX_EOF
        log_fix "创建 wiki/index.md"
    fi

    # 确保 log.md 存在
    if [ ! -f "wiki/log.md" ]; then
        cat > wiki/log.md << 'LOG_EOF'
# Wiki Log

> 第二大脑的操作日志。

---

## 使用说明

每次摄入新内容后，在此文件顶部追加条目。

---
LOG_EOF
        log_fix "创建 wiki/log.md"
    fi
fi

# 总结
echo ""
echo "============================================"
echo "         检查完成"
echo "============================================"
echo ""
echo "问题数量: $ISSUES"
if [ "$AUTO_FIX" == "--fix" ]; then
    echo "已修复: $FIXES"
fi
echo ""

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ 第二大脑状态良好!${NC}"
    exit 0
else
    echo -e "${YELLOW}! 发现 $ISSUES 个问题${NC}"
    echo ""
    echo "运行 '$0 --fix' 进行自动修复"
    exit 1
fi
