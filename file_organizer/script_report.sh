#!/bin/bash


if [ $# -eq 0 ]; then
    echo "Error: No directory provided." >&2
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: $1 is not a valid directory." >&2
    exit 1
fi

DIR="$1"


TEXT_EXTS=("txt" "md" "csv" "log")
IMAGE_EXTS=("jpg" "jpeg" "png" "gif" "bmp")
VIDEO_EXTS=("mp4" "avi" "mkv" "mov")

TEXT_COUNT=0
IMAGE_COUNT=0
VIDEO_COUNT=0
OTHER_COUNT=0

for FILE in "$DIR"/*; do
    if [ -f "$FILE" ]; then
        EXT="${FILE##*.}"
        
        if [[ " ${TEXT_EXTS[@]} " =~ " ${EXT} " ]]; then
         
            ((TEXT_COUNT++))
        elif [[ " ${IMAGE_EXTS[@]} " =~ " ${EXT} " ]]; then
            ((IMAGE_COUNT++))
        elif [[ " ${VIDEO_EXTS[@]} " =~ " ${EXT} " ]]; then
            ((VIDEO_COUNT++))
        else
            ((OTHER_COUNT++))
        fi
    fi
done


mkdir -p "$DIR/Text" "$DIR/Images" "$DIR/Videos" "$DIR/Others"


for FILE in "$DIR"/*; do
    if [ -f "$FILE" ]; then
        EXT="${FILE##*.}"
        
        if [[ " ${TEXT_EXTS[@]} " =~ " ${EXT} " ]]; then
            mv "$FILE" "$DIR/Text/"
        elif [[ " ${IMAGE_EXTS[@]} " =~ " ${EXT} " ]]; then
            mv "$FILE" "$DIR/Images/"
        elif [[ " ${VIDEO_EXTS[@]} " =~ " ${EXT} " ]]; then
            mv "$FILE" "$DIR/Videos/"
        else
            mv "$FILE" "$DIR/Others/"
        fi
    fi
done


REPORT="$DIR/script_report.txt"
{
    echo "=== Script Execution Report ==="
    echo "Date and Time: $(date)"
    echo "Total Files Processed: $((TEXT_COUNT + IMAGE_COUNT + VIDEO_COUNT + OTHER_COUNT))"
    echo "Text Files: $TEXT_COUNT"
    echo "Image Files: $IMAGE_COUNT"
    echo "Video Files: $VIDEO_COUNT"
    echo "Other Files: $OTHER_COUNT"
} > "$REPORT"

echo "Script executed successfully. Report generated: $REPORT"
