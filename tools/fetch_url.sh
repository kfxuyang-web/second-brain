#!/bin/bash
# fetch_url.sh — 抓取网页内容
# 用法: ./fetch_url.sh <url> [output_file]
# 输出: Markdown 格式

set -e

URL="$1"
OUTPUT_FILE="${2:-}"

if [ -z "$URL" ]; then
    echo "用法: $0 <url> [output_file]"
    echo "示例: $0 https://example.com/article"
    echo "      $0 https://example.com/article article.md"
    exit 1
fi

# 验证 URL 格式
if [[ ! "$URL" =~ ^https?:// ]]; then
    echo "错误: URL 必须以 http:// 或 https:// 开头"
    exit 1
fi

# 检测可用工具
detect_tool() {
    if command -v curl &> /dev/null; then
        # 检查是否有 html2text 或 pandoc
        if command -v html2text &> /dev/null; then
            echo "curl+html2text"
        elif command -v pandoc &> /dev/null; then
            echo "curl+pandoc"
        elif command -v python3 &> /dev/null; then
            echo "curl+python"
        else
            echo "curl-only"
        fi
    elif command -v wget &> /dev/null; then
        echo "wget"
    else
        echo "none"
    fi
}

TOOL=$(detect_tool)

# 抓取并转换为 Markdown
fetch_with_curl_python() {
    # 使用 Python 的 html2text 库
    python3 << 'PYTHON_SCRIPT'
import sys
import urllib.request
import html2text
import re

url = sys.argv[1]
output = sys.argv[2] if len(sys.argv) > 2 else None

try:
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
    }
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=30) as response:
        html = response.read().decode('utf-8', errors='ignore')

    h = html2text.HTML2Text()
    h.ignore_links = False
    h.ignore_images = False
    h.body_width = 0  # 不换行
    markdown = h.handle(html)

    # 清理
    markdown = re.sub(r'\n{3,}', '\n\n', markdown)
    markdown = markdown.strip()

    if output:
        with open(output, 'w', encoding='utf-8') as f:
            f.write(markdown)
        print(f"已保存到: {output}")
    else:
        print(markdown)

except Exception as e:
    print(f"错误: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON_SCRIPT
}

fetch_with_curl_html2text() {
    CONTENT=$(curl -sL "$URL" -A "Mozilla/5.0" | html2text -utf8)
    if [ -z "$OUTPUT_FILE" ]; then
        echo "$CONTENT"
    else
        echo "$CONTENT" > "$OUTPUT_FILE"
        echo "已保存到: $OUTPUT_FILE"
    fi
}

fetch_with_curl_pandoc() {
    if [ -z "$OUTPUT_FILE" ]; then
        curl -sL "$URL" -A "Mozilla/5.0" | pandoc -f html -t markdown
    else
        curl -sL "$URL" -A "Mozilla/5.0" | pandoc -f html -t markdown > "$OUTPUT_FILE"
        echo "已保存到: $OUTPUT_FILE"
    fi
}

fetch_with_wget() {
    if [ -z "$OUTPUT_FILE" ]; then
        wget -qO- "$URL"
    else
        wget -qO "$OUTPUT_FILE" "$URL"
        echo "已保存到: $OUTPUT_FILE"
    fi
}

echo "正在抓取: $URL"

case "$TOOL" in
    "curl+python")
        fetch_with_curl_python "$URL" "$OUTPUT_FILE"
        ;;
    "curl+html2text")
        fetch_with_curl_html2text
        ;;
    "curl+pandoc")
        fetch_with_curl_pandoc
        ;;
    "wget")
        fetch_with_wget
        ;;
    "curl-only")
        echo "警告: 未检测到 HTML 转 Markdown 工具，输出原始 HTML"
        if [ -z "$OUTPUT_FILE" ]; then
            curl -sL "$URL" -A "Mozilla/5.0"
        else
            curl -sL "$URL" -A "Mozilla/5.0" > "$OUTPUT_FILE"
            echo "已保存到: $OUTPUT_FILE"
        fi
        ;;
    "none")
        echo "错误: 未检测到 curl 或 wget"
        echo "请安装以下任一工具:"
        echo "  curl: macOS/Linux 通常已预装"
        echo "  wget: brew install wget / sudo apt install wget"
        exit 1
        ;;
esac
