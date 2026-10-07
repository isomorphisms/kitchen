#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

fail() {
    printf 'chatgpt-web-probe collect-baseline: %s\n' "$*" >&2
    exit 1
}

bundle=${1:-.}
[[ -d "$bundle" ]] || fail "bundle directory is missing: $bundle"
bundle=$(CDPATH= cd -- "$bundle" && pwd -P)

connect="$bundle/connect.sh"
capture="$bundle/capture.py"
[[ -f "$connect" ]] || fail "bundle is missing connect.sh"
[[ -f "$capture" ]] || fail "bundle is missing capture.py"

for command in adb python3 curl date mkdir sed awk; do
    command -v "$command" >/dev/null 2>&1 || fail "missing command: $command"
done

root=${2:-"$HOME/chatgpt-web-probe-captures"}
run="$root/$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$run"
index="$run/baseline-index.tsv"
printf 'label\tmethod\tpath\tstatus\tbody_sha256\tfolder\n' > "$index"

bash "$connect" 9222 > "$run/devtools.txt"

capture_one() {
    local label=$1 method=$2 path=$3 body=${4-}
    local output folder metadata status digest
    if [[ $# -eq 4 ]]; then
        output=$(python3 "$capture" --port 9222 --out "$run" "$method" "$path" "$body")
    else
        output=$(python3 "$capture" --port 9222 --out "$run" "$method" "$path")
    fi
    folder=$(printf '%s\n' "$output" | sed -n '1p')
    [[ -d "$folder" ]] || fail "$label capture did not return a fixture folder"
    metadata="$folder/metadata.json"
    [[ -f "$metadata" ]] || fail "$label fixture has no metadata.json"
    read -r status digest < <(
        python3 - "$metadata" <<'PY'
import json, sys
record=json.load(open(sys.argv[1]))
print(record.get("status", ""), record.get("bodySha256", ""))
PY
    )
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$label" "$method" "$path" "$status" "$digest" "$folder" >> "$index"
    printf '%s\n' "$folder"
}

session_folder=$(capture_one session GET '/api/auth/session')
accounts_folder=$(capture_one accounts GET '/backend-api/accounts/check/v4-2023-04-27')
active_folder=$(capture_one active GET '/backend-api/conversations?offset=0&limit=100&order=updated&is_archived=false&hide_snorlax=false')
capture_one archived GET '/backend-api/conversations?offset=0&limit=100&order=updated&is_archived=true&hide_snorlax=false' >/dev/null
capture_one projects GET '/backend-api/gizmos/snorlax/sidebar?conversations_per_gizmo=0&limit=20&owned_only=false' >/dev/null
capture_one shared GET '/backend-api/shared_conversations?offset=0&limit=100&order=updated' >/dev/null
capture_one memories GET '/backend-api/memories?include_memory_entries=true' >/dev/null
capture_one custom_instructions GET '/backend-api/user_system_messages' >/dev/null
capture_one settings GET '/backend-api/settings' >/dev/null
capture_one beta_features GET '/backend-api/settings/beta_features' >/dev/null

conversation_id=$(
    python3 - "$active_folder/body.txt" <<'PY'
import json, sys
try:
    value=json.load(open(sys.argv[1]))
except Exception:
    raise SystemExit(0)
items=value.get("items", []) if isinstance(value, dict) else value if isinstance(value, list) else []
for item in items:
    if not isinstance(item, dict):
        continue
    for key in ("id", "conversation_id"):
        candidate=item.get(key)
        if isinstance(candidate, str) and candidate:
            print(candidate)
            raise SystemExit(0)
PY
)

if [[ -n "$conversation_id" ]]; then
    capture_one sample_singular GET "/backend-api/conversation/$conversation_id" >/dev/null
    plural_folder=$(capture_one sample_plural GET "/backend-api/conversations/$conversation_id?include_has_versions=true&num_turns=10")
    batch_body=$(python3 - "$conversation_id" <<'PY'
import json, sys
print(json.dumps({"conversation_ids":[sys.argv[1]]}, separators=(",", ":")))
PY
)
    capture_one sample_batch POST '/backend-api/conversations/batch' "$batch_body" >/dev/null

    cursor=$(
        python3 - "$plural_folder/body.txt" <<'PY'
import json, sys
try:
    value=json.load(open(sys.argv[1]))
except Exception:
    raise SystemExit(0)
page=value.get("page_info") if isinstance(value, dict) else None
if isinstance(page, dict) and page.get("has_previous_page") is True:
    cursor=page.get("start_cursor")
    if isinstance(cursor, str) and cursor:
        print(cursor)
PY
    )
    if [[ -n "$cursor" ]]; then
        encoded=$(
            python3 - "$cursor" <<'PY'
import sys, urllib.parse
print(urllib.parse.quote(sys.argv[1], safe=""))
PY
        )
        capture_one sample_plural_previous GET             "/backend-api/conversations/$conversation_id/messages?before=$encoded&include_has_versions=true&num_turns=10"             >/dev/null
    fi
fi

python3 - "$index" "$run/summary.json" "$conversation_id" <<'PY'
import csv, json, sys
index, output, conversation_id=sys.argv[1:]
with open(index, newline="") as f:
    rows=list(csv.DictReader(f, delimiter="\t"))
summary={
    "schemaVersion": 1,
    "sampleConversationId": conversation_id or None,
    "captures": rows,
}
with open(output, "w") as f:
    json.dump(summary, f, indent=2, sort_keys=True)
    f.write("\n")
PY

printf '%s\n' 'CHATGPT_WEB_PROBE_BASELINE PASS'
printf 'capture_dir=%s\n' "$run"
printf 'index=%s\n' "$index"
