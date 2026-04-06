#!/bin/bash
# extract_pdf_text.sh — 提取 PDF 文字
# 用法: ./extract_pdf_text.sh <pdf_file> [output_file]
# 输出: Markdown 格式

set -e

PDF_FILE="$1"
OUTPUT_FILE="${2:-}"

if [ -z "$PDF_FILE" ]; then
    echo "用法: $0 <pdf_file> [output_file]"
    echo "示例: $0 document.pdf"
    echo "      $0 document.pdf text.md"
    exit 1
fi

if [ ! -f "$PDF_FILE" ]; then
    echo "错误: 文件不存在: $PDF_FILE"
    exit 1
fi

EXT="${PDF_FILE##*.}"
if [ "$(echo "$EXT" | tr '[:upper:]' '[:lower:]')" != "pdf" ]; then
    echo "警告: 文件扩展名不是 .pdf"
fi

# 检测可用工具
detect_tool() {
    if command -v pdftotext &> /dev/null; then
        echo "poppler"
    elif command -v pdfinfo &> /dev/null; then
        echo "poppler-info"
    elif command -v python3 &> /dev/null; then
        echo "python"
    elif command -v pandoc &> /dev/null; then
        echo "pandoc"
    else
        echo "none"
    fi
}

TOOL=$(detect_tool)

case "$TOOL" in
    "poppler")
        echo "使用 pdftotext 提取..."
        if [ -z "$OUTPUT_FILE" ]; then
            pdftotext -layout "$PDF_FILE" -
        else
            pdftotext -layout "$PDF_FILE" "$OUTPUT_FILE"
            echo "已保存到: $OUTPUT_FILE"
        fi
        ;;
    "poppler-info")
        echo "使用 pdfinfo + pdftotext 提取..."
        if [ -z "$OUTPUT_FILE" ]; then
            pdftotext -layout "$PDF_FILE" -
        else
            pdftotext -layout "$PDF_FILE" "$OUTPUT_FILE"
            echo "已保存到: $OUTPUT_FILE"
        fi
        ;;
    "python")
        echo "使用 Python (pdfminer) 提取..."
        python3 << 'PYTHON_SCRIPT'
import sys
import os

pdf_file = sys.argv[1]
output_file = sys.argv[2] if len(sys.argv) > 2 else None

try:
    from pdfminer.high_level import extract_text
    text = extract_text(pdf_file)

    # 清理文本
    lines = text.split('\n')
    cleaned = []
    for line in lines:
        line = line.rstrip()
        if line:
            cleaned.append(line)

    result = '\n\n'.join(cleaned)

    if output_file:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(result)
        print(f"已保存到: {output_file}")
    else:
        print(result)

except ImportError:
    print("错误: 未安装 pdfminer.six")
    print("请运行: pip3 install pdfminer.six")
    sys.exit(1)
except Exception as e:
    print(f"错误: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON_SCRIPT
        ;;
    "pandoc")
        echo "使用 Pandoc 提取..."
        if [ -z "$OUTPUT_FILE" ]; then
            pandoc -f pdf -t markdown "$PDF_FILE" 2>/dev/null || echo "Pandoc 无法直接读取 PDF，请使用其他工具"
        else
            pandoc -f pdf -t markdown "$PDF_FILE" > "$OUTPUT_FILE" 2>/dev/null || echo "Pandoc 无法直接读取 PDF"
            echo "已保存到: $OUTPUT_FILE"
        fi
        ;;
    "none")
        echo "错误: 未检测到 PDF 工具"
        echo ""
        echo "请安装以下任一工具:"
        echo "  1. poppler (推荐):"
        echo "     macOS: brew install poppler"
        echo "     Linux: sudo apt install poppler-utils"
        echo "  2. Python pdfminer:"
        echo "     pip3 install pdfminer.six"
        echo "  3. Pandoc:"
        echo "     brew install pandoc"
        exit 1
        ;;
esac
