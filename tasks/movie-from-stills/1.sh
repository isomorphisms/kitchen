#!/bin/sh
set -eu

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

[ "$#" -eq 3 ] || [ "$#" -eq 4 ] ||
    fail 'usage: 1.sh FRAME_PATTERN FPS OUTPUT.mp4 [AUDIO]'

frames=$1
fps=$2
output=$3
audio=${4-}

case $frames in
    *%*d*) ;;
    *) fail 'FRAME_PATTERN must be a numbered ffmpeg image pattern such as frames/frame-%06d.png' ;;
esac

case $output in
    *.mp4) ;;
    *) fail 'OUTPUT must end in .mp4' ;;
esac

[ -n "$fps" ] || fail 'FPS must not be empty'
[ -z "$audio" ] || [ -f "$audio" ] || fail "audio file does not exist: $audio"
command -v ffmpeg >/dev/null 2>&1 || fail 'ffmpeg is not installed or not on PATH'

output_dir=$(dirname "$output")
[ -d "$output_dir" ] || mkdir -p "$output_dir"

if [ -n "$audio" ]; then
    ffmpeg \
        -hide_banner -loglevel error -y \
        -framerate "$fps" -start_number 0 -i "$frames" \
        -i "$audio" \
        -map 0:v:0 -map 1:a:0 \
        -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
        -c:a aac -b:a 192k -af apad -shortest \
        -map_metadata -1 -movflags +faststart \
        "$output"
else
    ffmpeg \
        -hide_banner -loglevel error -y \
        -framerate "$fps" -start_number 0 -i "$frames" \
        -an \
        -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
        -map_metadata -1 -movflags +faststart \
        "$output"
fi

[ -s "$output" ] || fail "ffmpeg returned success but did not create a nonempty movie: $output"
printf '%s\n' "$output"
