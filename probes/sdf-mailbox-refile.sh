#!/bin/sh
set -eu

printf '%s\n' '== system =='
uname -a
id

printf '%s\n' '== paths =='
printf 'HOME=%s\n' "$HOME"
ls -ldn /var/mail
ls -ln /var/mail/isomorphisms
ls -ldn "$HOME" "$HOME/Mail" "$HOME/opt" "$HOME/opt/bin" 2>&1 || :

printf '%s\n' '== space =='
df -k /var/mail "$HOME/Mail" 2>&1 || df -k /var/mail "$HOME" 2>&1 || :

printf '%s\n' '== locking and filesystem tools =='
for command in lockf flock mail.local dotlock stat mv cp sync; do
    if command -v "$command" >/dev/null 2>&1; then
        printf '%s\t%s\n' "$command" "$(command -v "$command")"
    else
        printf '%s\t%s\n' "$command" MISSING
    fi
done

printf '%s\n' '== local delivery locking policy if Postfix exposes it =='
if command -v postconf >/dev/null 2>&1; then
    postconf -h mailbox_delivery_lock 2>&1 || :
else
    printf '%s\n' 'postconf MISSING'
fi

printf '%s\n' '== permissions inferred without mutation =='
if [ -r /var/mail/isomorphisms ]; then
    printf '%s\n' 'source-readable=yes'
else
    printf '%s\n' 'source-readable=no'
fi

if [ -w /var/mail/isomorphisms ]; then
    printf '%s\n' 'source-writable=yes'
else
    printf '%s\n' 'source-writable=no'
fi

if [ -w /var/mail ]; then
    printf '%s\n' 'mail-directory-writable=yes'
else
    printf '%s\n' 'mail-directory-writable=no'
fi
