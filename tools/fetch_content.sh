#!/bin/bash
# fetch_content.sh — 智能识别平台并获取内容
# 用法: ./fetch_content.sh <url> [output_file]

set -e

URL="$1"
OUTPUT_FILE="${2:-}"

if [ -z "$URL" ]; then
    echo "用法: $0 <url> [output_file]"
    echo ""
    echo "支持的平台:"
    echo "  Twitter/X     - https://x.com/... 或 https://twitter.com/..."
    echo "  YouTube      - https://youtube.com/... 或 https://youtu.be/..."
    echo "  Bilibili     - https://bilibili.com/..."
    echo "  微信公众号    - https://mp.weixin.qq.com/..."
    echo "  小红书       - https://www.xiaohongshu.com/..."
    echo "  普通网页     - 任何 http/https URL"
    exit 1
fi

# 检测平台
detect_platform() {
    if [[ "$URL" =~ (x\.com|twitter\.com) ]]; then
        echo "twitter"
    elif [[ "$URL" =~ (youtube\.com|youtu\.be) ]]; then
        echo "youtube"
    elif [[ "$URL" =~ bilibili\.com ]]; then
        echo "bilibili"
    elif [[ "$URL" =~ mp\.weixin\.qq\.com ]]; then
        echo "wechat"
    elif [[ "$URL" =~ xiaohongshu\.com ]]; then
        echo "xiaohongshu"
    else
        echo "generic"
    fi
}

PLATFORM=$(detect_platform)

echo "检测到平台: $PLATFORM"
echo "URL: $URL"
echo ""

# 执行对应平台的获取
case "$PLATFORM" in
    twitter)
        echo "获取 Twitter/X 内容..."
        if command -v agent-reach &> /dev/null; then
            echo "使用 agent-reach 读取..."
            agent-reach --read "$URL" > "${OUTPUT_FILE:-/dev/stdout}"
        elif [ -f "$(dirname "$0")/fetch_url.sh" ]; then
            echo "使用 fetch_url.sh (可能无法获取完整内容)..."
            bash "$(dirname "$0")/fetch_url.sh" "$URL" "${OUTPUT_FILE:-}"
        else
            echo "错误: 需要安装 agent-reach 来获取 Twitter 内容"
            echo "请告诉 AI：'帮我安装 Agent Reach: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md'"
            exit 1
        fi
        ;;

    youtube)
        echo "获取 YouTube 视频..."
        if command -v yt-dlp &> /dev/null; then
            # 获取字幕/转录
            if [ -z "$OUTPUT_FILE" ]; then
                yt-dlp --write-auto-sub --sub-lang zh-Hans,en --skip-download --print "%(title)s\n\n%(description)s\n\n[Transcript]\n%( Subtitles )s" "$URL"
            else
                yt-dlp --write-auto-sub --sub-lang zh-Hans,en --skip-download -o "$OUTPUT_FILE" "$URL"
            fi
        else
            echo "错误: 未安装 yt-dlp"
            echo "安装: brew install yt-dlp"
            echo "或: pip install yt-dlp"
            exit 1
        fi
        ;;

    bilibili)
        echo "获取 Bilibili 视频..."
        if command -v yt-dlp &> /dev/null; then
            # yt-dlp 也支持 B站
            if [ -z "$OUTPUT_FILE" ]; then
                yt-dlp --write-auto-sub --sub-lang zh-Hans --skip-download --print "%(title)s\n\n%(description)s" "$URL"
            else
                yt-dlp --write-auto-sub --sub-lang zh-Hans --skip-download -o "$OUTPUT_FILE" "$URL"
            fi
        else
            echo "错误: 未安装 yt-dlp"
            echo "安装: brew install yt-dlp"
            exit 1
        fi
        ;;

    wechat)
        echo "获取微信公众号文章..."
        if command -v agent-reach &> /dev/null; then
            echo "使用 agent-reach 读取..."
            agent-reach --read "$URL" > "${OUTPUT_FILE:-/dev/stdout}"
        elif [ -f "$(dirname "$0")/fetch_url.sh" ]; then
            echo "使用 fetch_url.sh..."
            bash "$(dirname "$0")/fetch_url.sh" "$URL" "${OUTPUT_FILE:-}"
        else
            echo "警告: 微信公众号可能需要登录才能访问完整内容"
            echo "建议安装 agent-reach 或手动复制内容"
            exit 1
        fi
        ;;

    xiaohongshu)
        echo "获取小红书笔记..."
        if command -v agent-reach &> /dev/null; then
            echo "使用 agent-reach 读取..."
            agent-reach --read "$URL" > "${OUTPUT_FILE:-/dev/stdout}"
        elif [ -f "$(dirname "$0")/fetch_url.sh" ]; then
            echo "使用 fetch_url.sh..."
            bash "$(dirname "$0")/fetch_url.sh" "$URL" "${OUTPUT_FILE:-}"
        else
            echo "警告: 小红书可能需要登录才能访问完整内容"
            echo "建议安装 agent-reach 或手动复制内容"
            exit 1
        fi
        ;;

    generic)
        echo "获取普通网页..."
        if [ -f "$(dirname "$0")/fetch_url.sh" ]; then
            bash "$(dirname "$0")/fetch_url.sh" "$URL" "${OUTPUT_FILE:-}"
        else
            echo "错误: 未找到 fetch_url.sh"
            exit 1
        fi
        ;;
esac

echo ""
echo "完成!"
