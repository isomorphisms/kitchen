#!/bin/sh
# Standalone POSIX diagnostic; the subshell also protects a pasted/sourced caller.
(
    stop() { printf 'BLOCKED stage=%s %s\n' "$1" "$2" >&2; exit 1; }
    [ "$#" -eq 1 ] || stop arguments 'usage: sh 1.sh /verified/IB/checkout'
    for dependency in git awk dirname mktemp mkdir rm sh cat grep cmp cp cut wc tr sync; do
        command -v "$dependency" >/dev/null 2>&1 ||
            stop dependency "missing command: $dependency; no installation attempted"
    done
    [ -d "$1" ] || stop checkout 'supplied directory is absent; source availability is unknown'
    checkout=$(CDPATH='' cd -- "$1" && pwd -P) || stop checkout 'cannot enter supplied directory'
    [ -e "$checkout/.git" ] || stop checkout 'supplied path is not a checkout root'
    unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_COMMON_DIR GIT_OBJECT_DIRECTORY GIT_ALTERNATE_OBJECT_DIRECTORIES GIT_SHALLOW_FILE
    GIT_NO_REPLACE_OBJECTS=1
    export GIT_NO_REPLACE_OBJECTS
    git_root=$(git -C "$checkout" rev-parse --show-toplevel 2>/dev/null) ||
        stop checkout 'Git cannot read the supplied checkout'
    [ "$git_root" = "$checkout" ] || stop checkout 'Git resolved a different checkout root'
    origin=$(git -C "$checkout" remote get-url origin 2>/dev/null) ||
        stop origin 'checkout has no readable origin'
    case "$origin" in
        https://github.com/isomorphisms/ib|https://github.com/isomorphisms/ib.git|https://github.com/isomorphisms/IB|https://github.com/isomorphisms/IB.git|git@github.com:isomorphisms/ib.git|git@github.com:isomorphisms/IB.git|ssh://git@github.com/isomorphisms/ib.git|ssh://git@github.com/isomorphisms/IB.git) ;;
        *) stop origin 'checkout origin is not the reviewed isomorphisms/ib repository' ;;
    esac
    task=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P) || stop lock 'cannot locate task'
    pins=$(awk -F '\t' '
        NF != 2 || length($2) != 40 || $2 !~ /^[0-9a-f]+$/ { bad=1 }
        $1 != "source" && $1 != "implementation" && $1 != "test" { bad=1 }
        seen[$1]++ { bad=1 }
        { value[$1]=$2 }
        END {
            if (bad || NR != 3 || !seen["source"] || !seen["implementation"] || !seen["test"]) exit 1
            print value["source"], value["implementation"], value["test"]
        }
    ' "$task/baseline.lock") || stop lock 'expected exactly three full source/blob pins'
    set -- $pins
    source=$1 implementation=$2 test_blob=$3
    git -C "$checkout" cat-file -e "$source^{commit}" 2>/dev/null ||
        stop source "exact commit $source is unavailable in this checkout; no fetch attempted"
    for path in lib/durable_object_store.grease tests/test_durable_object_store.grease; do
        case $path in lib/*) expected=$implementation ;; *) expected=$test_blob ;; esac
        observed=$(git -C "$checkout" rev-parse --verify "$source:$path" 2>/dev/null) ||
            stop file "required file is absent at the pinned source: $path"
        [ "$observed" = "$expected" ] || stop blob "unexpected pinned blob: $path"
        [ "$(git -C "$checkout" cat-file -t "$observed")" = blob ] || stop blob "not a file blob: $path"
    done
    work=$(mktemp -d) || stop temporary 'cannot create a private temporary directory'
    trap 'rm -rf "$work"' 0
    trap 'exit 130' INT
    trap 'exit 143' HUP TERM
    mkdir "$work/lib" "$work/tests" || stop temporary 'cannot prepare temporary fixture'
    for path in lib/durable_object_store.grease tests/test_durable_object_store.grease; do
        case $path in lib/*) expected=$implementation ;; *) expected=$test_blob ;; esac
        git -C "$checkout" cat-file blob "$expected" > "$work/$path" || stop materialization "$path"
        [ "$(git hash-object "$work/$path")" = "$expected" ] || stop materialization "byte verification failed: $path"
        sh -n "$work/$path" || stop syntax "$path"
    done
    printf 'scope=ordinary-file-baseline\nsource=%s\nimplementation=%s\ntest=%s\n' "$source" "$implementation" "$test_blob"
    if sh "$work/tests/test_durable_object_store.grease" > "$work/output" 2> "$work/error"; then
        status=0
    else
        status=$?
    fi
    cat "$work/output"
    cat "$work/error" >&2
    [ "$status" -eq 0 ] || stop execution "durable-store test failed: status=$status"
    grep -Fx 'durable ordinary-file store tests: ok' "$work/output" >/dev/null ||
        stop postcondition 'test returned zero without its baseline success line'
    printf 'baseline=PASS\ne2=NOT_RUN\n'
)
