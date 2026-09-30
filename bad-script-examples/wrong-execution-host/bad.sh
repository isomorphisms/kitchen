#!/bin/sh
# INTENTIONALLY BAD. Synthetic reproduction.

# This recipe assumes it is running on a workstation with GitHub CLI and SSH
# credentials, even though it may already be running on the destination host.

gh run download 123456 --dir ./artifact

scp ./artifact/tool example@example-host.invalid:~/opt/bin/tool

ssh example@example-host.invalid '~/opt/bin/tool --check'
