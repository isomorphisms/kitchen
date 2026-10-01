#!/bin/sh
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
candidate=$root/tasks/movie-from-stills/build.sh

tmp=${TMPDIR:-/tmp}/kitchen-movie-from-stills-$$
fakebin=$tmp/bin
mkdir -p "$fakebin" "$tmp/frames" "$tmp/out"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

cat > "$fakebin/ffmpeg" <<'FAKE'
#!/bin/sh
set -eu
: "${FAKE_FFMPEG_ARGS:?}"
printf '%s\n' "$@" > "$FAKE_FFMPEG_ARGS"
[ "${FAKE_FFMPEG_NO_OUTPUT:-0}" = 1 ] && exit 0
last=
for arg do last=$arg; done
mkdir -p "$(dirname "$last")"
printf 'fake movie\n' > "$last"
FAKE
chmod +x "$fakebin/ffmpeg"

assert_line() {
    needle=$1
    file=$2
    grep -F -x -- "$needle" "$file" >/dev/null || {
        printf 'missing argument %s in %s\n' "$needle" "$file" >&2
        cat "$file" >&2
        exit 1
    }
}

args=$tmp/no-audio.args
FAKE_FFMPEG_ARGS=$args PATH="$fakebin:$PATH" \
    sh "$candidate" "$tmp/frames/frame-%06d.ppm" 24 "$tmp/out/no-audio.mp4" >/dev/null
assert_line 24 "$args"
assert_line 0 "$args"
assert_line "$tmp/frames/frame-%06d.ppm" "$args"
assert_line libx264 "$args"
assert_line yuv420p "$args"
assert_line -an "$args"
printf 'PASS no-audio command\n'

printf 'audio' > "$tmp/audio.wav"
args=$tmp/audio.args
FAKE_FFMPEG_ARGS=$args PATH="$fakebin:$PATH" \
    sh "$candidate" "$tmp/frames/frame-%06d.png" 30 "$tmp/out/audio.mp4" "$tmp/audio.wav" >/dev/null
assert_line "$tmp/audio.wav" "$args"
assert_line aac "$args"
assert_line apad "$args"
assert_line -shortest "$args"
printf 'PASS audio command\n'

args=$tmp/refusal.args
set +e
FAKE_FFMPEG_ARGS=$args PATH="$fakebin:$PATH" \
    sh "$candidate" "$tmp/frames/frame.png" 24 "$tmp/out/bad.mp4" >"$tmp/refusal.out" 2>&1
status=$?
set -e
[ "$status" -ne 0 ] || { printf 'expected non-numbered pattern refusal\n' >&2; exit 1; }
[ ! -e "$args" ] || { printf 'ffmpeg ran despite pattern refusal\n' >&2; exit 1; }
printf 'PASS pattern refusal\n'

args=$tmp/no-output.args
set +e
FAKE_FFMPEG_ARGS=$args FAKE_FFMPEG_NO_OUTPUT=1 PATH="$fakebin:$PATH" \
    sh "$candidate" "$tmp/frames/frame-%06d.ppm" 24 "$tmp/out/no-output.mp4" >"$tmp/no-output.out" 2>&1
status=$?
set -e
[ "$status" -ne 0 ] || { printf 'expected missing-output refusal\n' >&2; exit 1; }
printf 'PASS missing-output refusal\n'

if command -v ffmpeg >/dev/null 2>&1 && command -v ffprobe >/dev/null 2>&1; then
    real=$tmp/real
    mkdir -p "$real/frames"
    n=0
    while [ "$n" -lt 4 ]; do
        frame=$real/frames/frame-$(printf '%06d' "$n").ppm
        printf 'P6\n2 2\n255\n' > "$frame"
        printf '\377\000\000\000\377\000\000\000\377\377\377\377' >> "$frame"
        n=$((n + 1))
    done
    PATH=$(printf '%s' "$PATH" | awk -v RS=: -v ORS=: '$0 != "'"$fakebin"'" {print}' | sed 's/:$//') \
        sh "$candidate" "$real/frames/frame-%06d.ppm" 2 "$real/movie.mp4" >/dev/null
    frames=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nw=1:nk=1 "$real/movie.mp4")
    [ "$frames" = 4 ] || { printf 'expected 4 encoded frames, got %s\n' "$frames" >&2; exit 1; }
    printf 'PASS real ffmpeg smoke\n'
fi
