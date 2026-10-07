#!/bin/sh
set -eu

fail() {
    printf '%s\n' "$*" >&2
    exit 2
}

: "${SPINOR_ROOT:?set SPINOR_ROOT to a functorial-games/spinor checkout}"

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
kitchen_root=$(CDPATH= cd -- "$here/../.." && pwd)

output=${1:-"$SPINOR_ROOT/build/movie/spinor-4pi-demo.mp4"}
fps=${SPINOR_MOVIE_FPS:-30}
frame_count=${SPINOR_MOVIE_FRAMES:-240}
frames_directory=${SPINOR_MOVIE_FRAMES_DIR:-"$SPINOR_ROOT/build/movie/frames"}

[ -f "$SPINOR_ROOT/movie/render-frames.sh" ] ||
    fail "missing Spinor frame renderer: $SPINOR_ROOT/movie/render-frames.sh"
[ -f "$kitchen_root/tasks/movie-from-stills/build.sh" ] ||
    fail "missing canonical Kitchen movie builder"

case $fps in
    ''|*[!0-9]*) fail "invalid SPINOR_MOVIE_FPS: $fps" ;;
esac
case $frame_count in
    ''|*[!0-9]*) fail "invalid SPINOR_MOVIE_FRAMES: $frame_count" ;;
esac

sh "$SPINOR_ROOT/movie/render-frames.sh" "$frames_directory"

sh "$kitchen_root/tasks/movie-from-stills/build.sh" \
    "$frames_directory/frame-%06d.ppm" \
    "$fps" \
    "$output"

command -v ffprobe >/dev/null 2>&1 ||
    fail "ffprobe is required to verify the Spinor movie"

actual_frames=$(
    ffprobe \
        -v error \
        -select_streams v:0 \
        -count_frames \
        -show_entries stream=nb_read_frames \
        -of default=nokey=1:noprint_wrappers=1 \
        "$output"
)

[ "$actual_frames" = "$frame_count" ] ||
    fail "expected $frame_count movie frames, found $actual_frames"

receipt=$output.receipt.tsv
{
    printf 'field\tvalue\n'
    printf 'spinor_commit\t%s\n' "$(
        git -C "$SPINOR_ROOT" rev-parse HEAD
    )"
    printf 'kitchen_commit\t%s\n' "$(
        git -C "$kitchen_root" rev-parse HEAD
    )"
    printf 'frame_count\t%s\n' "$frame_count"
    printf 'fps\t%s\n' "$fps"
    printf 'movie_sha256\t%s\n' "$(
        sha256sum "$output" |
        cut -d ' ' -f 1
    )"
    printf 'trajectory_sha256\t%s\n' "$(
        sha256sum "$frames_directory/trajectory.tsv" |
        cut -d ' ' -f 1
    )"
    printf 'frame_checksums_sha256\t%s\n' "$(
        sha256sum "$frames_directory/frames.sha256" |
        cut -d ' ' -f 1
    )"
} > "$receipt"

printf '%s\n' "$output" "$receipt"
