#!/bin/bash
# extract_exif.sh — 提取图片 EXIF 元数据
# 用法: ./extract_exif.sh <image_file>
# 输出: JSON 格式

set -e

IMAGE_FILE="$1"

if [ -z "$IMAGE_FILE" ]; then
    echo "用法: $0 <image_file>"
    echo "示例: $0 photo.jpg"
    echo "支持的格式: jpg, jpeg, tiff, png, webp, heic"
    exit 1
fi

if [ ! -f "$IMAGE_FILE" ]; then
    echo "错误: 文件不存在: $IMAGE_FILE"
    exit 1
fi

# 检测可用工具
detect_tool() {
    if command -v exiftool &> /dev/null; then
        echo "exiftool"
    elif command -v identify &> /dev/null; then
        echo "imagemagick"
    elif command -v sips &> /dev/null; then
        echo "sips"
    else
        echo "none"
    fi
}

TOOL=$(detect_tool)

output_json() {
    echo "{"
    echo "  \"filename\": \"$(basename "$IMAGE_FILE")\","
    echo "  \"path\": \"$(realpath "$IMAGE_FILE")\","
    echo "  \"format\": \"$FORMAT\","
    echo "  \"dimensions\": \"$DIMENSIONS\","
    echo "  \"size_bytes\": $(stat -f%z "$IMAGE_FILE" 2>/dev/null || stat -c%s "$IMAGE_FILE" 2>/dev/null),"
    echo "  \"taken_at\": \"$TAKEN_AT\","
    echo "  \"location\": \"$LOCATION\","
    echo "  \"camera\": \"$CAMERA\","
    echo "  \"orientation\": \"$ORIENTATION\""
    echo "}"
}

case "$TOOL" in
    "exiftool")
        echo "使用 exiftool 提取..."
        # 提取各项元数据
        TAKEN_AT=$(exiftool -T -DateTimeOriginal "$IMAGE_FILE" 2>/dev/null || echo "")
        LOCATION=$(exiftool -T -GPSLatitude "$IMAGE_FILE" 2>/dev/null && exiftool -T -GPSLongitude "$IMAGE_FILE" 2>/dev/null | tr '\n' ',' || echo "")
        CAMERA=$(exiftool -T -Model "$IMAGE_FILE" 2>/dev/null || echo "")
        FORMAT=$(exiftool -T -FileType "$IMAGE_FILE" 2>/dev/null || echo "")
        DIMENSIONS=$(exiftool -T -ImageWidth "$IMAGE_FILE" 2>/dev/null)x$(exiftool -T -ImageHeight "$IMAGE_FILE" 2>/dev/null || echo "")
        ORIENTATION=$(exiftool -T -Orientation "$IMAGE_FILE" 2>/dev/null || echo "")

        output_json
        ;;
    "imagemagick")
        echo "使用 ImageMagick 提取..."
        DIMENSIONS=$(identify -format '%wx%h' "$IMAGE_FILE" 2>/dev/null || echo "unknown")
        FORMAT=$(identify -format '%m' "$IMAGE_FILE" 2>/dev/null || echo "unknown")
        TAKEN_AT=""
        LOCATION=""
        CAMERA=""
        ORIENTATION=""

        output_json
        ;;
    "sips")
        echo "使用 sips 提取..."
        # macOS 内置工具
        DIMENSIONS=$(sips -g pixelHeight -g pixelWidth "$IMAGE_FILE" 2>/dev/null | grep -E "pixel|Height" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
        FORMAT=$(sips -g format "$IMAGE_FILE" 2>/dev/null | grep format | awk '{print $2}')
        TAKEN_AT=""
        LOCATION=""
        CAMERA=""
        ORIENTATION=""

        output_json
        ;;
    "none")
        echo "错误: 未检测到 EXIF 提取工具"
        echo ""
        echo "请安装以下任一工具:"
        echo "  1. exiftool (推荐):"
        echo "     macOS: brew install exiftool"
        echo "     Linux: sudo apt install libimage-exiftool-perl"
        echo "  2. ImageMagick:"
        echo "     macOS: brew install imagemagick"
        echo "     Linux: sudo apt install imagemagick"
        exit 1
        ;;
esac
