#!/bin/bash

# 遍历当前目录下的所有mp3文件
for file in *.mp3; do
    # 提取文件名（不包含扩展名）
    filename=$(basename "$file" .mp3)
    
    # 使用FFmpeg提取封面
    ffmpeg -i "$file" -an -vcodec copy "$filename.jpg" -y
    
    # 输出进度信息
    echo "提取封面: $filename.jpg"
done

