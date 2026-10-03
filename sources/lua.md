# Lua source provenance

Checked: 2026-10-02.

Official source: https://www.lua.org/download.html

Pinned Kitchen release:

- version: Lua 5.5.1;
- archive: `https://www.lua.org/ftp/lua-5.5.1.tar.gz`;
- published SHA-256:
  `1c4b4068d67061f2a2231ad2b5422e77acea1487ea9890f6320af614f4373dce`.

Lua.org identifies 5.5.1 as the current Lua 5.5 release. Kitchen pins the exact
release and digest so a future upstream release does not silently change the
interpreter used by a prepared command.
