#!/bin/bash
# voice_to_text.sh — 语音转文字
# 用法: ./voice_to_text.sh <audio_file> [output_file]
# 支持格式: mp3, wav, m4a, aac, ogg

set -e

AUDIO_FILE="$1"
OUTPUT_FILE="${2:-}"

if [ -z "$AUDIO_FILE" ]; then
    echo "用法: $0 <audio_file> [output_file]"
    echo "示例: $0 recording.m4a transcript.txt"
    exit 1
fi

if [ ! -f "$AUDIO_FILE" ]; then
    echo "错误: 文件不存在: $AUDIO_FILE"
    exit 1
fi

# 检测可用工具
detect_tool() {
    if command -v ollama &> /dev/null && ollama list | grep -q "sensevoice"; then
        echo "ollama-sensevoice"
    elif command -v whisper &> /dev/null; then
        echo "whisper"
    else
        echo "none"
    fi
}

TOOL=$(detect_tool)

case "$TOOL" in
    "ollama-sensevoice")
        echo "使用 SenseVoice (Ollama) 转录..."
        if [ -z "$OUTPUT_FILE" ]; then
            ollama run sensevoice "$AUDIO_FILE"
        else
            ollama run sensevoice "$AUDIO_FILE" > "$OUTPUT_FILE"
        fi
        ;;
    "whisper")
        echo "使用 Whisper 转录..."
        LANG="${3:-auto}"
        if [ -z "$OUTPUT_FILE" ]; then
            whisper "$AUDIO_FILE" --language "$LANG"
        else
            whisper "$AUDIO_FILE" --language "$LANG" --output_file "$OUTPUT_FILE"
        fi
        ;;
    "none")
        echo "错误: 未检测到语音识别工具"
        echo ""
        echo "请安装以下任一工具:"
        echo "  1. SenseVoice (Ollama):"
        echo "     ollama pull sensevoice"
        echo "  2. Whisper:"
        echo "     pip3 install whisper"
        echo "     或: brew install whisper"
        exit 1
        ;;
esac

echo "完成!"
