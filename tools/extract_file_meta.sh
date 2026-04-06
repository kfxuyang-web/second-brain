#!/bin/bash
# extract_file_meta.sh — 提取文件元数据
# 用法: ./extract_file_meta.sh <file>
# 输出: JSON 格式

set -e

FILE="$1"

if [ -z "$FILE" ]; then
    echo "用法: $0 <file>"
    echo "示例: $0 document.pdf"
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "错误: 文件不存在: $FILE"
    exit 1
fi

# 获取基本信息
FILENAME=$(basename "$FILE")
REALPATH=$(realpath "$FILE")
EXT="${FILENAME##*.}"
EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
SIZE_BYTES=$(stat -f%z "$FILE" 2>/dev/null || stat -c%s "$FILE" 2>/dev/null)
CREATED_AT=$(stat -f%Sm -t%Y-%m-%d "$FILE" 2>/dev/null || stat -c%y "$FILE" 2>/dev/null | cut -d' ' -f1)
MODIFIED_AT=$(stat -f%Sm -t%Y-%m-%d "$FILE" 2>/dev/null || stat -c%y "$FILE" 2>/dev/null | cut -d' ' -f1)

# 格式化文件大小
format_size() {
    local size=$1
    if [ $size -lt 1024 ]; then
        echo "${size}B"
    elif [ $size -lt 1048576 ]; then
        echo "$((size/1024))KB"
    elif [ $size -lt 1073741824 ]; then
        echo "$((size/1048576))MB"
    else
        echo "$((size/1073741824))GB"
    fi
}

SIZE_HUMAN=$(format_size $SIZE_BYTES)

# 根据扩展名提取特定元数据
case "$EXT_LOWER" in
    pdf)
        if command -v pdfinfo &> /dev/null; then
            PAGES=$(pdfinfo "$FILE" 2>/dev/null | grep "Pages:" | awk '{print $2}')
            AUTHOR=$(pdfinfo "$FILE" 2>/dev/null | grep "Creator:" | awk -F': ' '{print $2}')
            TITLE=$(pdfinfo "$FILE" 2>/dev/null | grep "Title:" | awk -F': ' '{print $2}')
        elif command -v exiftool &> /dev/null; then
            PAGES=$(exiftool -T -PageCount "$FILE" 2>/dev/null || echo "")
            AUTHOR=$(exiftool -T -Author "$FILE" 2>/dev/null || echo "")
            TITLE=$(exiftool -T -Title "$FILE" 2>/dev/null || echo "")
        else
            PAGES=""
            AUTHOR=""
            TITLE=""
        fi
        ;;
    docx)
        if command -v python3 &> /dev/null; then
            AUTHOR=$(python3 -c "
import zipfile, xml.etree.ElementTree as ET
try:
    with zipfile.ZipFile('$FILE') as z:
        doc = ET.parse(z.open('docProps/core.xml'))
        ns = {'d': 'http://schemas.openxmlformats.org/package/2006/metadata/core-properties'}
        author = doc.find('.//d:creator', ns)
        print(author.text if author is not None else '')
except: print('')
" 2>/dev/null || echo "")
        else
            AUTHOR=""
        fi
        PAGES=""
        TITLE=""
        ;;
    xlsx)
        if command -v python3 &> /dev/null; then
            SHEETS=$(python3 -c "
import zipfile, xml.etree.ElementTree as ET
try:
    with zipfile.ZipFile('$FILE') as z:
        wb = ET.parse(z.open('xl/workbook.xml'))
        ns = {'w': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
        sheets = wb.findall('.//w:sheet', ns)
        print(len(sheets))
except: print('')
" 2>/dev/null || echo "")
        else
            SHEETS=""
        fi
        AUTHOR=""
        TITLE=""
        PAGES=""
        ;;
    md|txt)
        LINES=$(wc -l < "$FILE" 2>/dev/null || echo "")
        WORDS=$(wc -w < "$FILE" 2>/dev/null || echo "")
        PAGES=""
        AUTHOR=""
        TITLE=""
        ;;
    jpg|jpeg|png|gif|webp|heic)
        # 图片特有元数据，调用 extract_exif.sh
        if [ -f "$(dirname "$0")/extract_exif.sh" ]; then
            EXIF_JSON=$(bash "$(dirname "$0")/extract_exif.sh" "$FILE" 2>/dev/null)
        else
            EXIF_JSON=""
        fi
        ;;
    mp3|wav|m4a|aac|ogg)
        # 音频特有元数据
        if command -v ffprobe &> /dev/null; then
            DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FILE" 2>/dev/null || echo "")
            DURATION=$(printf "%.0f" "$DURATION" 2>/dev/null || echo "")
        else
            DURATION=""
        fi
        ;;
    mp4|mov|avi|mkv)
        # 视频特有元数据
        if command -v ffprobe &> /dev/null; then
            DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$FILE" 2>/dev/null || echo "")
            DURATION=$(printf "%.0f" "$DURATION" 2>/dev/null || echo "")
            DIMENSIONS=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$FILE" 2>/dev/null || echo "")
        else
            DURATION=""
            DIMENSIONS=""
        fi
        ;;
    *)
        PAGES=""
        AUTHOR=""
        TITLE=""
        ;;
esac

# 输出 JSON
echo "{"
echo "  \"filename\": \"$FILENAME\","
echo "  \"path\": \"$REALPATH\","
echo "  \"format\": \"$EXT_LOWER\","
echo "  \"size_bytes\": $SIZE_BYTES,"
echo "  \"size_human\": \"$SIZE_HUMAN\","
echo "  \"created_at\": \"$CREATED_AT\","
echo "  \"modified_at\": \"$MODIFIED_AT\","

case "$EXT_LOWER" in
    pdf)
        echo "  \"pages\": \"$PAGES\","
        echo "  \"author\": \"$AUTHOR\","
        echo "  \"title\": \"$TITLE\""
        ;;
    docx)
        echo "  \"author\": \"$AUTHOR\""
        ;;
    xlsx)
        echo "  \"sheets\": \"$SHEETS\""
        ;;
    md|txt)
        echo "  \"lines\": \"$LINES\","
        echo "  \"words\": \"$WORDS\""
        ;;
    mp3|wav|m4a|aac|ogg)
        echo "  \"duration_seconds\": \"$DURATION\""
        ;;
    mp4|mov|avi|mkv)
        echo "  \"duration_seconds\": \"$DURATION\","
        echo "  \"dimensions\": \"$DIMENSIONS\""
        ;;
    *)
        echo "  \"type\": \"generic\""
        ;;
esac

echo "}"
