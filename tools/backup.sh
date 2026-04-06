#!/bin/bash
# backup.sh — raw/ 目录备份工具
# 用法: ./backup.sh [dest]
# dest: 备份目标路径（默认: ~/second-brain-backups）

set -e

DEST="${1:-$HOME/second-brain-backups}"
SOURCE="$(cd "$(dirname "$0")/.." && pwd)/raw"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="raw-backup-$TIMESTAMP"
BACKUP_PATH="$DEST/$BACKUP_NAME"

echo "============================================"
echo "         Second Brain 备份工具"
echo "============================================"
echo ""
echo "源目录: $SOURCE"
echo "目标: $BACKUP_PATH"
echo ""

# 检查源目录是否存在
if [ ! -d "$SOURCE" ]; then
    echo "错误: 源目录不存在: $SOURCE"
    exit 1
fi

# 检查是否有文件需要备份
FILE_COUNT=$(find "$SOURCE" -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$FILE_COUNT" -eq 0 ]; then
    echo "源目录为空，无需备份"
    exit 0
fi

echo "待备份文件数: $FILE_COUNT"

# 创建备份目录
mkdir -p "$DEST"

# 选择备份方式
backup_tar() {
    echo "使用 tar 压缩备份..."
    tar -czf "$BACKUP_PATH.tar.gz" -C "$(dirname "$SOURCE")" raw
    SIZE=$(du -h "$BACKUP_PATH.tar.gz" | cut -f1)
    echo "✓ 备份完成: $BACKUP_PATH.tar.gz ($SIZE)"
}

backup_rsync() {
    echo "使用 rsync 增量备份..."
    mkdir -p "$BACKUP_PATH"
    rsync -av --delete "$SOURCE/" "$BACKUP_PATH/"
    SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
    echo "✓ 备份完成: $BACKUP_PATH ($SIZE)"
}

backup_cloud() {
    # 检测云备份工具
    if command -v rclone &> /dev/null; then
        echo "使用 rclone 备份到云存储..."
        read -p "请输入 rclone remote 名称: " REMOTE
        if [ -n "$REMOTE" ]; then
            rclone copy "$SOURCE" "$REMOTE:/second-brain-raw" --progress
            echo "✓ 已备份到: $REMOTE:/second-brain-raw"
        else
            echo "未指定 remote，取消云备份"
        fi
    else
        echo "未检测到 rclone，跳过云备份"
        echo "安装 rclone: https://rclone.org/install/"
    fi
}

# 主流程
if command -v rsync &> /dev/null; then
    read -p "使用 rsync 增量备份 (r) 还是 tar 压缩备份 (t)？[r] " CHOICE
    CHOICE="${CHOICE:-r}"
else
    CHOICE="t"
fi

case "$CHOICE" in
    r|R)
        backup_rsync
        ;;
    t|T)
        backup_tar
        ;;
    c|C)
        backup_cloud
        ;;
    *)
        echo "无效选择，使用 tar"
        backup_tar
        ;;
esac

# 清理旧备份（保留最近 5 个）
echo ""
echo "清理旧备份（保留最近 5 个）..."
if command -v rsync &> /dev/null; then
    ls -t "$DEST"/raw-backup-* 2>/dev/null | tail -n +6 | xargs -r rm -rf
    ls -t "$DEST"/*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f
fi

echo ""
echo "当前备份列表:"
ls -lh "$DEST" 2>/dev/null | grep -E "raw-backup|total" || echo "  (无备份)"

echo ""
echo "============================================"
echo "备份建议:"
echo "  1. 定期运行此脚本自动备份"
echo "  2. 考虑使用 crontab 定时备份"
echo "  3. 可选: 配置 rclone 备份到云存储"
echo "============================================"
