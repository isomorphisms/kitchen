# Movie from numbered stills

Target context: a host or GitHub runner with `ffmpeg` on `PATH`.

This is the canonical movie-assembly boundary for the mathematical visualization
repositories. The mathematical repository owns the state trajectory and the
renderer. It writes numbered still files. Kitchen owns the ordinary media
assembly command.

Do not create a project-local Python/C/D movie writer merely to turn rendered
stills into an MP4. Do not stream a private in-memory frame protocol into a
project-local wrapper when ordinary numbered image files are sufficient.

Keeping the stills is allowed. A repository may commit the still sequence, the
movie, both, or neither according to that project's artifact policy. The movie
builder does not delete or rewrite the input stills.

## Canonical frame boundary

Render a contiguous sequence beginning at zero, for example:

```text
frames/frame-000000.png
frames/frame-000001.png
frames/frame-000002.png
...
```

PNM/PPM is equally valid:

```text
frames/frame-000000.ppm
frames/frame-000001.ppm
...
```

The repository that owns the mathematics also owns what changes from one frame
to the next: camera position, coefficients, roots, poles, sound-analysis time,
orbital state, or any other model parameter. Kitchen does not know those things.

## Requirements

The canonical builder must:

- consume a numbered FFmpeg image pattern beginning at frame zero;
- leave the still files unchanged;
- use the requested frames per second as the input clock;
- encode H.264 video in an MP4 container with `yuv420p` playback compatibility;
- strip inherited input metadata from the output;
- overwrite the named output rather than inventing another filename;
- fail if FFmpeg fails or no nonempty output is produced;
- optionally mux one audio file;
- when audio is present, preserve the full still sequence: shorter audio is
  padded and longer audio is cut at the video end;
- contain no mathematical state evolution or still rendering.

The exact MP4 bytes are not promised to be identical across different FFmpeg or
codec builds. Reproducibility here means the same explicit still sequence,
frame rate, audio input, and canonical command path, not a claim that unrelated
FFmpeg versions emit byte-identical containers.

## Stable entry point

Use:

```sh
sh /path/to/kitchen/tasks/movie-from-stills/build.sh \
  'frames/frame-%06d.png' 30 movie.mp4
```

With audio:

```sh
sh /path/to/kitchen/tasks/movie-from-stills/build.sh \
  'frames/frame-%06d.png' 30 movie.mp4 sound.wav
```

`build.sh` is the stable entry point. It dispatches to the current numbered
Kitchen candidate. The current candidate is `1.sh`.

Run `sh tests/movie-from-stills.sh` to test the command contract. When a real
`ffmpeg` and `ffprobe` are available, that test also performs a four-frame PPM
smoke render and verifies that the resulting MP4 contains four video frames.
