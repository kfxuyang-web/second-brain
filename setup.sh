#!/bin/bash
# setup.sh — 第二大脑安装脚本
#
# 架构：
#   second-brain-source/ — 从 GitHub clone 的源代码（干净）
#   ~/second-brain/       — 你的第二大脑（用 git 管理你的数据）
#
# 用法: ./setup.sh [--fix] [--inject-only] [--auto-cron] [--data-dir <路径>]

set -e

AUTO_FIX=""
INJECT_ONLY=""
AUTO_CRON=""
DATA_DIR=""

# 解析参数
for arg in "$@"; do
    case "$arg" in
        --fix) AUTO_FIX="1" ;;
        --inject-only) INJECT_ONLY="1" ;;
        --auto-cron) AUTO_CRON="1" ;;
        --data-dir)
            shift
            DATA_DIR="$1"
            ;;
        --data-dir=*)
            DATA_DIR="${arg#--data-dir=}"
            ;;
    esac
done

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SOURCE_DIR/config.sh"

# 加载已有配置
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# 如果命令行没指定，用配置的或默认值
DATA_DIR="${DATA_DIR:-$SECOND_BRAIN_DATA_DIR}"
DATA_DIR="${DATA_DIR:-$HOME/second-brain}"

# 如果是 --inject-only，直接运行注入然后退出
if [ "$INJECT_ONLY" = "1" ] || [ "$1" = "--inject-only" ]; then
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

**源代码目录：** \`$SOURCE_DIR/\`
**数据目录：** \`$DATA_DIR/\`

当需要知识积累、内容收藏时，使用第二大脑系统。

**重要：** 处理前先读取 \`$SOURCE_DIR/MEMORY.md\`（统一入口，定义完整处理流程）
**数据位置：** 运行时从 config.sh 读取，数据在 \`$DATA_DIR/\`

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
            sed -i.bak '/^## 🧠 第二大脑/,/^---$/d' "$OPENCLAW_MEMORY"
            echo "$INJECT_CONTENT" >> "$OPENCLAW_MEMORY"
            echo "已更新注入内容"
        else
            echo "$INJECT_CONTENT" >> "$OPENCLAW_MEMORY"
            echo "已注入到 $OPENCLAW_MEMORY"
        fi
    }
    inject_to_openclaw
    exit 0
fi

echo "============================================"
echo "       Second Brain 安装脚本"
echo "============================================"
echo ""
echo -e "${BLUE}源代码目录:${NC} $SOURCE_DIR"
echo -e "${BLUE}数据目录:${NC} $DATA_DIR"
echo ""

# 检查是否在源代码目录
check_directory() {
    if [ ! -f "$SOURCE_DIR/MEMORY.md" ] || [ ! -f "$SOURCE_DIR/reference.md" ]; then
        echo -e "${RED}错误: 源代码目录缺少核心文件${NC}"
        echo "当前目录: $(pwd)"
        echo ""
        echo "如果你是在数据目录运行，请到源代码目录运行此脚本："
        echo "  cd second-brain-source"
        echo "  ./setup.sh"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} 源代码目录正确"
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
    check_dep "qmd" "qmd (语义搜索)" || true

    if [ $MISSING -gt 0 ]; then
        echo ""
        echo -e "${YELLOW}建议安装缺失的工具以获得完整功能${NC}"
    fi
}

# 检查源代码目录结构
check_source_structure() {
    echo ""
    echo "--------------------------------------------"
    echo "检查源代码目录结构..."
    echo "--------------------------------------------"

    REQUIRED_DIRS=(
        "tools"
        "process"
        "commands"
    )

    REQUIRED_FILES=(
        "MEMORY.md"
        "reference.md"
        "CLAUDE.md"
        "tools/init_data_repo.sh"
    )

    ALL_OK=true
    for dir in "${REQUIRED_DIRS[@]}"; do
        if [ -d "$SOURCE_DIR/$dir" ]; then
            echo -e "  ${GREEN}✓${NC} $dir/"
        else
            echo -e "  ${RED}✗${NC} $dir/ (缺失)"
            ALL_OK=false
        fi
    done

    for file in "${REQUIRED_FILES[@]}"; do
        if [ -f "$SOURCE_DIR/$file" ]; then
            echo -e "  ${GREEN}✓${NC} $file"
        else
            echo -e "  ${RED}✗${NC} $file (缺失)"
            ALL_OK=false
        fi
    done

    if [ "$ALL_OK" = false ]; then
        echo ""
        echo -e "${RED}错误: 源代码目录不完整${NC}"
        exit 1
    fi
}

# 初始化数据目录
init_data_directory() {
    echo ""
    echo "--------------------------------------------"
    echo "初始化数据目录..."
    echo "--------------------------------------------"

    # 检查是否已有 config.sh
    if [ -f "$CONFIG_FILE" ] && [ "$DATA_DIR" != "$HOME/second-brain" ]; then
        echo -e "${GREEN}✓${NC} 使用已有配置: $CONFIG_FILE"
        echo "  数据目录: $DATA_DIR"
    else
        # 询问数据目录位置
        echo "第二大脑的数据将保存在哪里？"
        echo ""
        echo "  1) ~/second-brain (默认)"
        echo "  2) 当前目录下的 second-brain/"
        echo "  3) 自定义路径"
        read -p "请选择 [1]: " DIR_CHOICE
        DIR_CHOICE="${DIR_CHOICE:-1}"

        case "$DIR_CHOICE" in
            1) DATA_DIR="$HOME/second-brain" ;;
            2) DATA_DIR="$SOURCE_DIR/second-brain" ;;
            3)
                read -p "请输入数据目录路径: " DATA_DIR
                ;;
            *) DATA_DIR="$HOME/second-brain" ;;
        esac

        # 保存配置
        echo ""
        echo "保存配置到 $CONFIG_FILE..."
        cat > "$CONFIG_FILE" << EOF
#!/bin/bash
# config.sh — 第二大脑数据目录配置
# 此文件由 setup.sh 自动生成，用户也可以手动修改

# 数据目录路径
SECOND_BRAIN_DATA_DIR="$DATA_DIR"
EOF
        echo -e "${GREEN}✓${NC} 配置已保存"
    fi

    echo ""
    echo "数据目录: $DATA_DIR"
    echo ""

    # 运行初始化脚本
    if [ -f "$SOURCE_DIR/tools/init_data_repo.sh" ]; then
        # 临时修改 DATA_DIR 让 init_data_repo.sh 使用我们的配置
        export SECOND_BRAIN_DATA_DIR="$DATA_DIR"
        bash "$SOURCE_DIR/tools/init_data_repo.sh"
    else
        echo -e "${RED}错误: 找不到初始化脚本${NC}"
        exit 1
    fi
}

# 设置定时任务
setup_cron() {
    echo ""
    echo "--------------------------------------------"
    echo "设置定时提醒..."
    echo "--------------------------------------------"

    if ! command -v openclaw &> /dev/null; then
        echo -e "  ${YELLOW}⚠ openclaw CLI 未安装，跳过${NC}"
        return 0
    fi

    # 自动模式
    if [ "$AUTO_CRON" = "1" ]; then
        echo -e "  ${BLUE}ℹ${NC} 自动模式..."
        local TIMEZONE="Asia/Shanghai"

        openclaw cron add \
            --name "第二大脑-每日待办" \
            --cron "0 9 * * *" \
            --tz "$TIMEZONE" \
            --session isolated \
            --message "读取 $DATA_DIR/wiki/log.md 列出今日 pending 待办，简洁列表格式" \
            2>/dev/null && echo -e "  ${GREEN}✓${NC} 每日待办提醒已添加" || true

        openclaw cron add \
            --name "第二大脑-周检" \
            --cron "0 20 * * 0" \
            --tz "$TIMEZONE" \
            --session isolated \
            --message "运行 $SOURCE_DIR/tools/doctor.sh 检查 $DATA_DIR/wiki/ 目录，报告结果" \
            2>/dev/null && echo -e "  ${GREEN}✓${NC} 每周健康检查已添加" || true

        return 0
    fi

    # 交互模式
    echo "OpenClaw cron 可以帮你自动提醒待办和健康检查"
    read -p "是否设置定时提醒？[y/N] " SETUP_CRON

    if [[ ! "$SETUP_CRON" =~ ^[Yy]$ ]]; then
        return 0
    fi

    local TIMEZONE="Asia/Shanghai"

    openclaw cron add \
        --name "第二大脑-每日待办" \
        --cron "0 9 * * *" \
        --tz "$TIMEZONE" \
        --session isolated \
        --message "读取 $DATA_DIR/wiki/log.md 列出今日 pending 待办" \
        2>/dev/null && echo -e "  ${GREEN}✓${NC} 每日待办提醒已设置" || true

    openclaw cron add \
        --name "第二大脑-周检" \
        --cron "0 20 * * 0" \
        --tz "$TIMEZONE" \
        --session isolated \
        --message "运行 $SOURCE_DIR/tools/doctor.sh 检查 $DATA_DIR/wiki/" \
        2>/dev/null && echo -e "  ${GREEN}✓${NC} 每周健康检查已设置" || true
}

# 使用指引
show_usage() {
    echo ""
    echo "============================================"
    echo -e "     ${GREEN}✓ 安装完成！${NC}"
    echo "============================================"
    echo ""
    echo -e "${BLUE}你的第二大脑:${NC}"
    echo "  路径: $DATA_DIR"
    echo "  Git:  独立 git 仓库管理你的数据"
    echo ""
    echo -e "${BLUE}源代码目录:${NC}"
    echo "  路径: $SOURCE_DIR"
    echo "  用途: 存放代码，升级时从此目录更新"
    echo ""
    echo "============================================"
    echo "       日常使用"
    echo "============================================"
    echo ""
    echo -e "${BLUE}1. 存入内容${NC}"
    echo "  对 AI 说：'帮我把这段话存入第二大脑：...'"
    echo ""
    echo -e "${BLUE}2. 查看状态${NC}"
    echo "  cd $DATA_DIR"
    echo "  git status"
    echo ""
    echo -e "${BLUE}3. 提交更改${NC}"
    echo "  cd $DATA_DIR"
    echo "  git add ."
    echo "  git commit -m '添加新内容'"
    echo "  git push"
    echo ""
    echo -e "${BLUE}4. 升级第二大脑${NC}"
    echo "  1) 下载最新源代码到 second-brain-source/"
    echo "  2) cd second-brain-source && ./upgrade.sh"
    echo ""
    echo -e "${BLUE}5. 健康检查${NC}"
    echo "  cd $DATA_DIR && $SOURCE_DIR/tools/doctor.sh"
    echo ""
    echo "============================================"
}

# 主流程
check_directory
check_dependencies
check_source_structure

# 创建数据目录
init_data_directory

# 设置定时任务
setup_cron

show_usage
