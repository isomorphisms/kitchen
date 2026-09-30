#!/bin/sh
# INTENTIONALLY BAD. Synthetic reproduction.

# None of these prerequisites has been established.
pkg install privilege-helper

chmod 700 "$HOME/bin/helper"
chmod 400 "$HOME/bin/helper.dex"

sed -i 's/"PACKAGE"/"com.example.shell"/' "$HOME/bin/helper"

helper -c 'id'
