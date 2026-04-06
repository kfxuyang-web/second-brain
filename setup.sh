#!/bin/bash
# setup.sh — 第二大脑安装脚本
# 用法: ./setup.sh [--fix]

set -e

AUTO_FIX="${1:-}"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "============================================"
echo "       Second Brain 安装脚本"
echo "============================================"
echo ""

# 检查是否在正确的目录
check_directory() {
    if [ ! -f "MEMORY.md" ] || [ ! -f "reference.md" ]; then
        echo -e "${RED}错误: 请在 second-brain 目录下运行此脚本${NC}"
        echo "当前目录: $(pwd)"
        echo ""
        echo "正确步骤:"
        echo "  cd second-brain"
        echo "  ./setup.sh"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} 目录正确"
}

# 检查工具依赖
check_dependencies() {
    echo ""
    echo "--------------------------------------------"
    echo "检查依赖..."
    echo "--------------------------------------------"

    MISSING=0

    check_dep() {
        local cmd="$1"
        local name="$2"
        if command -v "$cmd" &> /dev/null; then
            echo -e "  ${GREEN}✓${NC} $name"
            return 0
        else
            echo -e "  ${YELLOW}⚠${NC} $name (未安装)"
            MISSING=$((MISSING+1))
            return 1
        fi
    }

    check_dep "git" "Git"
    check_dep "bash" "Bash"
    check_dep "curl" "curl"

    # 推荐工具
    echo ""
    echo "推荐安装的工具:"
    check_dep "ollama" "Ollama (运行 SenseVoice)" || true
    check_dep "whisper" "Whisper (语音识别)" || true
    check_dep "exiftool" "exiftool (图片元数据)" || true
    check_dep "pdftotext" "pdftotext (PDF 提取)" || true
    check_dep "yt-dlp" "yt-dlp (YouTube/B站字幕)" || true
    check_dep "agent-reach" "agent-reach (Twitter/公众号/小红书)" || true
    check_dep "rsync" "rsync (备份)" || true
    check_dep "yt-dlp" "yt-dlp (YouTube/B站字幕)" || true

    if [ $MISSING -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}建议安装缺失的工具以获得完整功能${NC}"
    fi
}

# 检查目录结构
check_structure() {
    echo ""
    echo "--------------------------------------------"
    echo "检查目录结构..."
    echo "--------------------------------------------"

    REQUIRED_DIRS=(
        "wiki/projects"
        "wiki/areas"
        "wiki/resources"
        "wiki/archives"
        "raw/articles"
        "raw/tweets"
        "raw/voice"
        "raw/images"
        "raw/files"
        "process"
        ".claude/commands"
        "tools"
    )

    ALL_OK=true
    for dir in "${REQUIRED_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            echo -e "  ${GREEN}✓${NC} $dir"
        else
            echo -e "  ${RED}✗${NC} $dir (缺失)"
            ALL_OK=false
        fi
    done

    if [ "$ALL_OK" = false ]; then
        if [ "$AUTO_FIX" == "--fix" ]; then
            echo ""
            echo "正在修复..."
            for dir in "${REQUIRED_DIRS[@]}"; do
                mkdir -p "$dir"
            done
            echo -e "${GREEN}✓ 目录结构已修复${NC}"
        else
            echo ""
            echo "运行 '$0 --fix' 自动修复"
        fi
    fi
}

# 检查工具脚本
check_tools() {
    echo ""
    echo "--------------------------------------------"
    echo "检查工具脚本..."
    echo "--------------------------------------------"

    TOOLS=(
        "tools/voice_to_text.sh"
        "tools/extract_exif.sh"
        "tools/extract_file_meta.sh"
        "tools/fetch_url.sh"
        "tools/extract_pdf_text.sh"
        "tools/doctor.sh"
        "tools/backup.sh"
    )

    for tool in "${TOOLS[@]}"; do
        if [ -f "$tool" ]; then
            if [ -x "$tool" ]; then
                echo -e "  ${GREEN}✓${NC} $tool"
            else
                echo -e "  ${YELLOW}⚠${NC} $tool (不可执行，将设置)"
                chmod +x "$tool"
            fi
        else
            echo -e "  ${RED}✗${NC} $tool (缺失)"
        fi
    done
}

# Git 初始化
init_git() {
    echo ""
    echo "--------------------------------------------"
    echo "Git 初始化..."
    echo "--------------------------------------------"

    if [ -d ".git" ]; then
        echo -e "  ${GREEN}✓${NC} Git 已初始化"
    else
        echo "  初始化 Git..."
        git init
        echo -e "${GREEN}✓${NC} Git 已初始化"
        echo ""
        echo -e "${YELLOW}建议: 创建一个 GitHub 仓库来备份你的第二大脑${NC}"
        echo ""
        read -p "是否现在创建 GitHub 仓库？[y/N] " CREATE_REPO
        if [[ "$CREATE_REPO" =~ ^[Yy]$ ]]; then
            echo "请在 GitHub 上创建仓库，然后运行:"
            echo "  git remote add origin https://github.com/YOUR_USERNAME/second-brain.git"
            echo "  git branch -M main"
            echo "  git push -u origin main"
        fi
    fi
}

# 关键文件检查
check_core_files() {
    echo ""
    echo "--------------------------------------------"
    echo "检查核心文件..."
    echo "--------------------------------------------"

    FILES=(
        "MEMORY.md"
        "reference.md"
        "CLAUDE.md"
        "README.md"
        "wiki/index.md"
        "wiki/log.md"
    )

    for file in "${FILES[@]}"; do
        if [ -f "$file" ]; then
            echo -e "  ${GREEN}✓${NC} $file"
        else
            echo -e "  ${RED}✗${NC} $file (缺失)"
        fi
    done
}

# 注入到 OpenClaw 全局 MEMORY.md
inject_to_openclaw() {
    echo ""
    echo "--------------------------------------------"
    echo "注入到 OpenClaw..."
    echo "--------------------------------------------"

    # 尝试多个可能的 OpenClaw MEMORY.md 位置
    OPENCLAW_MEMORY=""
    for path in \
        "$HOME/.openclaw/workspace/MEMORY.md" \
        "$HOME/.claude/projects/MEMORY.md" \
        "$HOME/MEMORY.md"
    do
        if [ -f "$path" ]; then
            OPENCLAW_MEMORY="$path"
            break
        fi
    done

    if [ -z "$OPENCLAW_MEMORY" ]; then
        echo -e "  ${YELLOW}⚠ 未找到 OpenClaw MEMORY.md，跳过注入${NC}"
        echo "  如需手动集成，参考: https://github.com/zhiwehu/second-brain"
        return 0
    fi

    # 检查是否已经注入过
    if grep -q "second-brain\|第二大脑" "$OPENCLAW_MEMORY" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} 已注入过第二大脑引用"
        return 0
    fi

    # 构建注入内容
    INJECT_CONTENT="

---

## 🧠 第二大脑 (Second Brain)

**仓库路径：** \`$PROJECT_DIR/\`

当需要知识积累、内容收藏时，使用第二大脑系统。

**重要：** 处理前先读取 \`$PROJECT_DIR/MEMORY.md\`（统一入口，定义完整处理流程）

**使用场景：**
- 推文/微博/灵感收集
- 文章/链接摄入
- 截图/图片保存
- 语音备忘
- 文档/文件整理
- 聊天记录归档
- 日程/TODO 管理

**用法：** 直接把内容或链接发给 AI，说"存入第二大脑"。

"

    # 追加到文件
    echo "$INJECT_CONTENT" >> "$OPENCLAW_MEMORY"
    echo -e "  ${GREEN}✓${NC} 已注入到 $OPENCLAW_MEMORY"

    # 尝试更新文件最后更新时间
    if [ -n "$(which sed)" ]; then
        # 更新 Last Updated 日期（如果存在）
        sed -i.bak "s/\*\*最后更新：\*\*.*/\*\*最后更新：\*\*/" "$OPENCLAW_MEMORY" 2>/dev/null || true
    fi
}

# 使用指引
show_usage() {
    echo ""
    echo "============================================"
    echo "       安装完成! 接下来:"
    echo "============================================"
    echo ""
    echo -e "${BLUE}第一步: 测试第二大脑${NC}"
    echo ""
    echo "  说: '请帮我把这段话存入第二大脑：测试内容'"
    echo "  AI 会自动路由到第二大脑流程处理"
    echo ""
    echo -e "${BLUE}第二步: 运行健康检查${NC}"
    echo ""
    echo "  ./tools/doctor.sh"
    echo "  ./tools/doctor.sh --fix  # 自动修复问题"
    echo ""
    echo -e "${BLUE}其他工具${NC}"
    echo ""
    echo "  语音转文字: ./tools/voice_to_text.sh audio.m4a"
    echo "  提取图片元数据: ./tools/extract_exif.sh photo.jpg"
    echo "  提取文件元数据: ./tools/extract_file_meta.sh doc.pdf"
    echo "  备份 raw/ 目录: ./tools/backup.sh"
    echo ""
    echo "============================================"
}

# 主流程
check_directory
check_dependencies
check_structure
check_tools
check_core_files

if [ "$AUTO_FIX" == "--fix" ]; then
    echo ""
    echo -e "${GREEN}✓ 自动修复完成${NC}"
fi

# Git 初始化（可选）
if [ ! -d ".git" ]; then
    echo ""
    read -p "是否初始化 Git 仓库？[Y/n] " INIT_GIT
    INIT_GIT="${INIT_GIT:-y}"
    if [[ "$INIT_GIT" =~ ^[Yy]$ ]]; then
        git init
    fi
fi

# 注入到 OpenClaw 全局 MEMORY.md
inject_to_openclaw

show_usage
