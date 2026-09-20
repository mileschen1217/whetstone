#!/usr/bin/env bash
# One brief trial. Usage: run.sh <out-dir> <trial-id> <arm>   Model: $EVAL_MODEL (default opus).
# With PLUGIN_DIR set the session loads that plugin; otherwise it runs with no plugin.
# <out-dir> must not be under a directory a headless session is refused writes in (see RUNBOOK).
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$1/$3-t$2"; model="${EVAL_MODEL:-opus}"; tools="Read,Glob,Grep,Write,Edit,Bash,Skill,Agent"
rm -rf "$out"; mkdir -p "$out/work"
(cd "$out/work" && bash "$here/fixture.sh")
if [ -n "${PLUGIN_DIR:-}" ]; then flags=(--setting-sources project --plugin-dir "$PLUGIN_DIR"); else flags=(--safe-mode); fi
(cd "$out/work" && claude -p --model "$model" --output-format json --allowedTools "$tools" "${flags[@]}" < "$here/arms/$3.md") > "$out/result.json" || true
python3 "$here/grade.py" "$out" "$here/ref/api.py" > "$out/grade.json"
echo "$3-t$2 done"
