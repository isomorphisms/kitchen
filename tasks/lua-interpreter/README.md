# Lua interpreter

Target context: a Unix-like host or GitHub runner with an ISO C compiler, `make`,
`tar`, HTTPS `curl`, and a SHA-256 utility. Installation is into an explicit
prefix; the task does not use root or a system package manager.

This task gives Kitchen a reproducible Lua interpreter without treating whatever
`lua` happens to be on a host as good enough. The source release and digest are
pinned, the archive is verified before extraction, and the interpreter is
smoke-tested before installation.

## Requirements

The installer must:

- build the official Lua 5.5.1 source release;
- verify the official SHA-256 digest before extracting or compiling it;
- require an absolute installation prefix rather than guessing a global path;
- install versioned executables as `PREFIX/bin/lua-5.5.1` and
  `PREFIX/bin/luac-5.5.1`;
- provide `PREFIX/bin/lua` and `PREFIX/bin/luac` symlinks when those names are
  free or already point at this exact Kitchen-managed version;
- refuse to replace an unrelated file or symlink at either unversioned name;
- avoid depending on the caller's current directory;
- verify the built interpreter by executing Lua code before and after install;
- leave no build tree behind after success or failure.

The current source provenance is recorded in `sources/lua.md`.

## Stable entry point

Choose the prefix from established machine state, then run:

```sh
sh /path/to/kitchen/tasks/lua-interpreter/install.sh /absolute/prefix
```

For the recorded MIRO A1 or SDF convention, `$HOME/opt` is the natural prefix
only after that target context has been confirmed, yielding `$HOME/opt/bin/lua`.
The installer itself deliberately does not assume that path.

For an already-downloaded archive, set `KITCHEN_LUA_ARCHIVE` to its absolute or
relative path. The same pinned digest check still applies:

```sh
KITCHEN_LUA_ARCHIVE=/path/to/lua-5.5.1.tar.gz \
  sh /path/to/kitchen/tasks/lua-interpreter/install.sh /absolute/prefix
```

Run `sh tests/lua-interpreter.sh` for the host smoke and refusal cases.
