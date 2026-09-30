#!/bin/sh
# INTENTIONALLY BAD. Synthetic reproduction; do not use as setup instructions.

source_file="$HOME/downloads/helper"
destination="$HOME/bin/helper"

mkdir -p "$HOME/bin"
cp "$source_file" "$destination"
chmod 700 "$destination"
"$destination" --check
