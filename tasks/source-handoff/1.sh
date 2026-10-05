#!/bin/sh
# Pre-Grease, read-only source diagnostic boundary; not Grease execution.
(
    stop() { printf 'BLOCKED stage=%s %s\n' "$1" "$2" >&2; exit 1; }
    [ "$#" -ge 5 ] || stop arguments 'emit|run CONTRACT CONTRACT_BLOB CHECKOUT REQUESTED_SCOPE [ENGINE_BLOB]'
    mode=$1 contract=$2 contract_blob=$3 checkout=$4 requested_scope=$5
    tab=$(printf '\t')
    newline='
'
    for argument in "$@" "$0"; do
        case $argument in *"$tab"*|*"$newline"*) stop arguments 'tabs and newlines in arguments are unsupported' ;; esac
    done
    case "$mode:$#" in emit:5|run:6) ;; *) stop arguments 'invalid mode or argument count' ;; esac
    for dependency in env git awk dirname mktemp mkdir rm sh cat grep sed cmp cp cut wc tr sync mv uname id; do
        command -v "$dependency" >/dev/null 2>&1 || stop dependency "missing $dependency; no installation attempted"
    done
    clean_git() {
        env -i PATH="$PATH" HOME="$HOME" GIT_CONFIG_NOSYSTEM=1 \
            HTTPS_PROXY="${HTTPS_PROXY:-}" HTTP_PROXY="${HTTP_PROXY:-}" \
            ALL_PROXY="${ALL_PROXY:-}" NO_PROXY="${NO_PROXY:-}" \
            https_proxy="${https_proxy:-}" http_proxy="${http_proxy:-}" \
            all_proxy="${all_proxy:-}" no_proxy="${no_proxy:-}" \
            GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null \
            GIT_NO_REPLACE_OBJECTS=1 GIT_TERMINAL_PROMPT=0 git "$@"
    }
    normalize() {
        value=${1%.git}
        case $value in
            git@github.com:*) value=https://github.com/${value#git@github.com:} ;;
            ssh://git@github.com/*) value=https://github.com/${value#ssh://git@github.com/} ;;
        esac
        case $value in https://github.com/*) printf '%s\n' "$value" | tr '[:upper:]' '[:lower:]' ;; *) printf '%s\n' "$value" ;; esac
    }
    absolute_file() {
        directory=$(CDPATH='' cd -- "$(dirname -- "$1")" && pwd -P) || return 1
        printf '%s/%s\n' "$directory" "${1##*/}"
    }
    engine=$(absolute_file "$0") || stop engine 'runner path unavailable'
    engine_blob=$(clean_git hash-object --no-filters "$engine") || stop engine 'cannot identify runner bytes'
    if [ "$mode" = run ]; then
        [ "$engine_blob" = "$6" ] || stop engine 'runner changed since emission'
    fi
    [ -f "$contract" ] || stop contract 'contract file unavailable'
    contract=$(absolute_file "$contract") || stop contract 'cannot resolve contract'
    [ "$(clean_git hash-object --no-filters "$contract")" = "$contract_blob" ] || stop contract 'contract bytes differ from reviewed identity'
    # Never source or eval a contract. File paths are deliberately a narrow subset.
    awk -F '\t' '
        function sha(s) { return length(s)==40 && s ~ /^[0-9a-f]+$/ }
        $1=="file" {
            if (NF!=3 || !sha($3) || $2 !~ /^[A-Za-z0-9_][A-Za-z0-9_.\/-]*$/ || $2 ~ /(^|\/)\.\.?($|\/)/ || paths[$2]++) bad=1
            files++; next
        }
        NF!=2 || $2=="" || seen[$1]++ { bad=1 }
        $1!="schema" && $1!="repository" && $1!="source" && $1!="entry" && $1!="context" && $1!="mutation" && $1!="rerun" && $1!="scope" && $1!="excluded" && $1!="marker" { bad=1 }
        { value[$1]=$2; metadata++ }
        END {
            if (bad || files<1 || metadata!=10 || value["schema"]!="source-handoff-v1" || !sha(value["source"]) || !paths[value["entry"]] || value["context"]!="posix-sh-existing-checkout" || value["mutation"]!="temporary-only-reviewed-test" || value["rerun"]!="reuse-verified-checkout") exit 1
            if (value["repository"] !~ /^https:\/\/github.com\/[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+$/ && value["repository"] !~ /^\//) exit 1
        }
    ' "$contract" || stop contract 'invalid, incomplete, unsafe or unsupported contract'
    field() { awk -F '\t' -v key="$1" '$1==key { print $2 }' "$contract"; }
    repository=$(field repository) source=$(field source) entry=$(field entry)
    scope=$(field scope) marker=$(field marker)
    [ "$scope" = "$requested_scope" ] || stop scope 'selected contract does not establish the requested feature'
    [ -d "$checkout" ] || stop checkout-missing 'supplied path absent; other locations and source availability unknown'
    checkout=$(CDPATH='' cd -- "$checkout" && pwd -P) || stop checkout-invalid 'cannot enter supplied path'
    [ -e "$checkout/.git" ] || stop checkout-invalid 'directory is not a checkout root; contents preserved'
    observed_root=$(clean_git -C "$checkout" rev-parse --show-toplevel 2>/dev/null) || stop checkout-invalid 'Git cannot read supplied checkout'
    [ "$observed_root" = "$checkout" ] || stop checkout-invalid 'Git resolved a different root'
    origin=$(clean_git -C "$checkout" config --local --no-includes --get-all remote.origin.url 2>/dev/null) || stop origin 'no readable literal local origin'
    [ "$(normalize "$origin")" = "$(normalize "$repository")" ] || stop origin 'checkout belongs to another or ambiguous repository'
    work=$(mktemp -d) || stop temporary 'private scratch unavailable'
    trap 'rm -rf "$work"' 0
    trap 'exit 130' INT
    trap 'exit 143' HUP TERM
    if [ "$mode" = emit ]; then
        # Explicit producer refresh, isolated from all human checkout state.
        clean_git init --bare -q "$work/remote" || stop materialization 'cannot create isolated object store'
        clean_git -C "$work/remote" fetch --no-tags --depth=1 "$repository" "$source" > "$work/fetch.log" 2>&1 ||
            stop remote-source 'exact source unavailable through stated transport; global existence unknown; no command emitted'
        fetched=$(clean_git -C "$work/remote" rev-parse 'FETCH_HEAD^{commit}') || stop remote-source 'fetched object is not a commit'
        [ "$fetched" = "$source" ] || stop remote-source 'transport did not materialize exact source'
    fi
    clean_git -C "$checkout" cat-file -e "$source^{commit}" 2>/dev/null ||
        stop local-source 'exact source absent here; consumer checkout was not fetched or modified'
    mkdir "$work/payload" || stop temporary 'cannot prepare payload'
    awk -F '\t' '$1=="file" { print $2 "\t" $3 }' "$contract" > "$work/files"
    tab=$(printf '\t')
    while IFS="$tab" read -r path expected; do
        observed=$(clean_git -C "$checkout" rev-parse --verify "$source:$path" 2>/dev/null) || stop file 'required file absent at exact source'
        [ "$observed" = "$expected" ] || stop blob "wrong file identity: $path"
        file_mode=$(clean_git -C "$checkout" ls-tree "$source" -- "$path" | cut -d ' ' -f 1)
        case $file_mode in 100644|100755) ;; *) stop file 'required path is not a regular committed file' ;; esac
        if [ "$mode" = emit ]; then
            remote_blob=$(clean_git -C "$work/remote" rev-parse --verify "$source:$path" 2>/dev/null) || stop file 'required file absent in fetched source'
            [ "$remote_blob" = "$expected" ] || stop blob 'fetched source has different file identity'
        fi
        mkdir -p "$work/payload/$(dirname -- "$path")" || stop temporary 'cannot create payload directory'
        clean_git -C "$checkout" cat-file blob "$observed" > "$work/payload/$path" || stop materialization 'cannot extract blob'
        [ "$(clean_git hash-object --no-filters "$work/payload/$path")" = "$expected" ] || stop materialization 'extracted bytes differ'
        sh -n "$work/payload/$path" || stop syntax "syntax check failed: $path"
    done < "$work/files"
    receipt() {
        printf 'repository=%s\nsource=%s\ncontract_blob=%s\nengine_blob=%s\ncheckout=%s\n' "$repository" "$source" "$contract_blob" "$engine_blob" "$checkout"
        printf 'observed_host=%s\nobserved_uid=%s\n' "$(uname -srm)" "$(id -u)"
        printf 'context=posix-sh-existing-checkout\ncaller_checkout_required=no\nmutation=temporary-only-reviewed-test\nrerun=reuse-verified-checkout\n'
        printf 'scope=%s\nexcluded=%s\nsuccess_marker=%s\nsuccess_exit=0\n' "$scope" "$(field excluded)" "$marker"
        awk -F '\t' '{ printf "file=%s blob=%s\n", $1, $2 }' "$work/files"
    }
    if [ "$mode" = emit ]; then
        # Receipts are shell comments so the exact complete output is pasteable.
        receipt | sed 's/^/# /'
        printf '# materialization=fresh-exact-source-fetch\n# acceptance=NOT_RUN\n'
        quote() { printf "'"; printf '%s' "$1" | sed "s/'/'\\\\''/g"; printf "'"; }
        printf 'if sh '
        quote "$engine"; printf ' run '; quote "$contract"; printf ' '; quote "$contract_blob"; printf ' '; quote "$checkout"; printf ' '; quote "$scope"; printf ' '; quote "$engine_blob"
        printf "; then printf 'handoff-command=PASS\\n'; else printf 'handoff-command=FAIL\\n' >&2; fi\n"
    else
        receipt
        if (cd "$work/payload" && sh "$entry") > "$work/output" 2> "$work/error"; then status=0; else status=$?; fi
        # Untrusted test output cannot impersonate gate receipt fields.
        sed 's/^/test.stdout: /' "$work/output"
        sed 's/^/test.stderr: /' "$work/error" >&2
        [ "$status" -eq 0 ] || stop execution "selected test failed: exit=$status"
        grep -Fx -- "$marker" "$work/output" >/dev/null || stop postcondition 'zero exit without required success marker'
        printf 'acceptance=PASS\nacceptance_scope=%s\nexcluded_claims=NOT_RUN\n' "$scope"
    fi
)
