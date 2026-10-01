#!/system/bin/sh
set -eu

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

[ "$#" -eq 4 ] ||
    fail 'usage: 1.sh SOURCE_OWNER REPOSITORY DESTINATION_OWNER EXPECTED_LOGIN'

source_owner=$1
repository=$2
destination_owner=$3
expected_login=$4
source=$source_owner/$repository
destination=$destination_owner/$repository

# For this human-facing transfer, use the interactive gh login rather than an
# ambient token that may silently select another account.
unset GH_TOKEN GITHUB_TOKEN

command -v gh >/dev/null 2>&1 || fail 'gh is not installed'
gh auth status --hostname github.com >/dev/null 2>&1 ||
    fail 'gh is not authenticated to github.com'

login=$(gh api user --jq '.login')
[ "$login" = "$expected_login" ] ||
    fail "refusing: gh is authenticated as $login, expected $expected_login"

source_canonical=$(gh api "repos/$source" --jq '.full_name')
[ "$source_canonical" = "$source" ] ||
    fail "refusing: $source resolves to $source_canonical instead of being the canonical source"

destination_canonical=$(
    gh api "repos/$destination" --jq '.full_name' 2>/dev/null || true
)

if [ "$destination_canonical" = "$destination" ]; then
    fail "refusing: destination already exists: $destination"
fi

if [ -n "$destination_canonical" ]; then
    printf 'note: %s currently redirects to %s; that is not a canonical destination collision\n' \
        "$destination" "$destination_canonical" >&2
fi

printf 'transferring %s -> %s\n' "$source" "$destination"
gh api --method POST "repos/$source/transfer" \
    -f "new_owner=$destination_owner" \
    --silent

attempt=0
while [ "$attempt" -lt 30 ]; do
    destination_canonical=$(
        gh api "repos/$destination" --jq '.full_name' 2>/dev/null || true
    )

    if [ "$destination_canonical" = "$destination" ]; then
        printf 'verified: %s\n' "$destination_canonical"
        exit 0
    fi

    attempt=$((attempt + 1))
    [ "$attempt" -lt 30 ] && sleep 2
done

fail "transfer was requested, but the canonical destination did not appear: $destination"
