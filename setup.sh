#!/bin/bash
# setup.sh — 第二大脑安装脚本
# 用法: ./setup.sh [--fix] [--inject-only] [--auto-cron]

set -e

AUTO_FIX=""
INJECT_ONLY=""
AUTO_CRON=""

for arg in "$@"; do
    case "$arg" in
        --fix) AUTO_FIX="1" ;;
        --inject-only) INJECT_ONLY="1" ;;
        --auto-cron) AUTO_CRON="1" ;;
    esac
done

# 如果是 --inject-only，直接运行注入然后退出
if [ "$AUTO_FIX" = "--inject-only" ] || [ "$1" = "--inject-only" ]; then
    PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
    inject_to_openclaw() {
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
            echo "未找到 OpenClaw MEMORY.md，跳过"
            return 0
        fi

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

        # 检查是否已有注入（通过标记行判断）
        if grep -q "## 🧠 第二大脑" "$OPENCLAW_MEMORY" 2>/dev/null; then
            # 已有注入，删除旧内容，替换新内容
            echo "发现已有注入，更新..."
            # 用 sed 删除旧注入块（从 "## 🧠 第二大脑" 到下一个 "---"）
            sed -i.bak '/^## 🧠 第二大脑/,/^---$/d' "$OPENCLAW_MEMORY"
            # 追加新内容
            echo "$INJECT_CONTENT" >> "$OPENCLAW_MEMORY"
            echo "已更新注入内容"
        else
            # 无注入，直接添加
            echo "$INJECT_CONTENT" >> "$OPENCLAW_MEMORY"
            echo "已注入到 $OPENCLAW_MEMORY"
        fi
    }
    inject_to_openclaw
    exit 0
fi

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
    check_dep "qmd" "qmd (语义搜索)" || true

    if [ $MISSING -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}建议安装缺失的工具以获得完整功能${NC}"
    fi
}

# 初始化 qmd 搜索
init_qmd() {
    echo ""
    echo "--------------------------------------------"
    echo "初始化 qmd 搜索..."
    echo "--------------------------------------------"

    if ! command -v qmd &> /dev/null; then
        echo -e "  ${YELLOW}⚠ qmd 未安装，跳过${NC}"
        echo "  如需语义搜索，安装: npm install -g @tobilu/qmd"
        return 0
    fi

    # 检查 wiki 目录是否存在
    if [ ! -d "wiki" ]; then
        echo -e "  ${YELLOW}⚠ wiki/ 目录不存在，跳过${NC}"
        return 0
    fi

    # 添加 wiki collection
    if qmd collection list 2>/dev/null | grep -q "second-brain"; then
        echo -e "  ${GREEN}✓${NC} qmd collection 'second-brain' 已存在"
    else
        echo "  添加 qmd collection..."
        if qmd collection add "$(pwd)/wiki" --name second-brain 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} qmd collection 'second-brain' 已添加"
        else
            echo -e "  ${YELLOW}⚠ 添加 collection 失败${NC}"
        fi
    fi

    # 生成 embeddings
    echo "  生成语义搜索索引..."
    if qmd embed 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} 索引生成完成"
    else
        echo -e "  ${YELLOW}⚠ 索引生成失败（可选，继续使用 grep）${NC}"
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
        "wiki/schema"
        "raw/articles"
        "raw/tweets"
        "raw/voice"
        "raw/images"
        "raw/files"
        "raw/chats"
        "process"
        ".claude/commands"
        "commands"
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

# 设置定时任务
setup_cron() {
    echo ""
    echo "--------------------------------------------"
    echo "设置定时提醒..."
    echo "--------------------------------------------"

    # 检查 openclaw 是否可用
    if ! command -v openclaw &> /dev/null; then
        echo -e "  ${YELLOW}⚠ openclaw CLI 未安装，跳过定时任务设置${NC}"
        echo "  如需设置定时提醒，先安装 OpenClaw CLI"
        return 0
    fi

    # 自动模式（升级时用，不交互）
    if [ "$AUTO_CRON" = "1" ]; then
        echo -e "  ${BLUE}ℹ${NC} 自动模式添加定时任务..."
        local TIMEZONE="Asia/Shanghai"

        openclaw cron add \
            --name "第二大脑-每日待办" \
            --cron "0 9 * * *" \
            --tz "$TIMEZONE" \
            --session isolated \
            --message "读取 wiki/log.md 列出今日 pending 待办，简洁列表格式" \
            2>/dev/null && echo -e "  ${GREEN}✓${NC} 每日待办提醒已添加" || echo -e "  ${YELLOW}⚠ 添加失败${NC}"

        openclaw cron add \
            --name "第二大脑-周检" \
            --cron "0 20 * * 0" \
            --tz "$TIMEZONE" \
            --session isolated \
            --message "运行 ./tools/doctor.sh 检查 wiki/ 目录，报告结果" \
            2>/dev/null && echo -e "  ${GREEN}✓${NC} 每周健康检查已添加" || echo -e "  ${YELLOW}⚠ 添加失败${NC}"

        return 0
    fi

    # 交互模式（手动安装时用）
    echo "OpenClaw cron 可以帮你自动："
    echo "  1. 每天早上提醒待办"
    echo "  2. 每周自动健康检查"
    echo ""
    read -p "是否设置定时提醒？[y/N] " SETUP_CRON

    if [[ ! "$SETUP_CRON" =~ ^[Yy]$ ]]; then
        echo "跳过定时任务设置"
        return 0
    fi

    # 选择时区
    echo ""
    echo "选择时区："
    echo "  1) Asia/Shanghai（北京时间）"
    echo "  2) Asia/Hong_Kong（香港时间）"
    echo "  3) 其他（手动输入）"
    read -p "请选择 [1]: " TZ_CHOICE
    TZ_CHOICE="${TZ_CHOICE:-1}"

    case "$TZ_CHOICE" in
        1) TIMEZONE="Asia/Shanghai" ;;
        2) TIMEZONE="Asia/Hong_Kong" ;;
        3) read -p "请输入时区（如 America/New_York）: " TIMEZONE ;;
        *) TIMEZONE="Asia/Shanghai" ;;
    esac
    echo "  使用时区: $TIMEZONE"

    # 选择推送方式
    echo ""
    echo "选择推送方式："
    echo "  1) 不发通知（仅内部执行）"
    echo "  2) Telegram"
    echo "  3) Slack"
    read -p "请选择 [1]: " PUSH_CHOICE
    PUSH_CHOICE="${PUSH_CHOICE:-1}"

    local ANNOUNCE_FLAG=""
    local CHANNEL_FLAG=""
    local TO_FLAG=""

    case "$PUSH_CHOICE" in
        2)
            read -p "请输入 Telegram 频道或用户名（如 @your_channel）: " TELEGRAM_TARGET
            ANNOUNCE_FLAG="--announce"
            CHANNEL_FLAG="--channel telegram"
            TO_FLAG="--to ${TELEGRAM_TARGET:-self}"
            ;;
        3)
            read -p "请输入 Slack 频道 ID（如 C0123456789）: " SLACK_TARGET
            ANNOUNCE_FLAG="--announce"
            CHANNEL_FLAG="--channel slack"
            TO_FLAG="--to ${SLACK_TARGET:-self}"
            ;;
        *)
            echo "  将使用静默模式（不发通知）"
            ;;
    esac

    # 设置每日待办提醒
    echo ""
    echo "设置每日待办提醒（每天 9:00）..."

    local CRON_CMD="openclaw cron add \
      --name \"第二大脑-每日待办\" \
      --cron \"0 9 * * *\" \
      --tz \"$TIMEZONE\" \
      --session isolated \
      --message \"读取 wiki/log.md 列出今日 pending 待办，简洁列表格式\""

    if [ -n "$ANNOUNCE_FLAG" ]; then
        CRON_CMD="$CRON_CMD $ANNOUNCE_FLAG $CHANNEL_FLAG $TO_FLAG"
    fi

    if eval "$CRON_CMD" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} 每日待办提醒已设置"
    else
        echo -e "  ${YELLOW}⚠ 命令执行失败，请检查 openclaw 配置${NC}"
    fi

    # 设置每周健康检查
    echo ""
    echo "设置每周健康检查（每周日 20:00）..."

    CRON_CMD="openclaw cron add \
      --name \"第二大脑-周检\" \
      --cron \"0 20 * * 0\" \
      --tz \"$TIMEZONE\" \
      --session isolated \
      --message \"运行 ./tools/doctor.sh 检查 wiki/ 目录，报告结果\""

    if [ -n "$ANNOUNCE_FLAG" ]; then
        CRON_CMD="$CRON_CMD $ANNOUNCE_FLAG $CHANNEL_FLAG $TO_FLAG"
    fi

    if eval "$CRON_CMD" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} 每周健康检查已设置"
    else
        echo -e "  ${YELLOW}⚠ 命令执行失败，请检查 openclaw 配置${NC}"
    fi

    echo ""
    echo "查看已设置的定时任务: openclaw cron list"
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

# 初始化 qmd 搜索（非交互式，失败不影响主流程）
if [ "$AUTO_CRON" = "1" ] || [ ! -t 0 ]; then
    init_qmd 2>/dev/null || true
fi

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

# 设置定时任务（非交互式跳过）
setup_cron

show_usage
