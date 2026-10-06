# Spinor demo movie

Pasteable composition for the public Spinor 0 → 2π → 4π demo.

Ownership stays split:

- Spinor owns the semantic trajectory and numbered PPM frame renderer;
- Kitchen owns this human-facing composition script and the canonical
  `movie-from-stills` encoder;
- Flexible Pipes pins and invokes these exact scripts for repeatable runs.

Run from any directory:

```sh
SPINOR_ROOT=/path/to/functorial-games/spinor \
sh /path/to/kitchen/tasks/spinor-demo-movie/build.sh
```

The script preserves the stills, trajectory, and frame checksums in the Spinor
build tree, verifies the MP4 frame count with `ffprobe`, and writes a
`spinor-4pi-demo.mp4.receipt.tsv` file beside the movie.

Useful explicit overrides:

```sh
SPINOR_ROOT=/path/to/spinor \
SPINOR_MOVIE_FRAMES=120 \
SPINOR_MOVIE_FPS=30 \
SPINOR_MOVIE_WIDTH=360 \
SPINOR_MOVIE_HEIGHT=360 \
sh tasks/spinor-demo-movie/build.sh /tmp/spinor-demo.mp4
```
