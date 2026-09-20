#!/usr/bin/env bash
# One build trial outside `claude plugin eval` (its kept workspaces are sealed, and the built
# tree has to be run against the held-out tests). Builds the workspace, runs one arm's prompt
# headless, then grades the tree with grade.py.
# Usage: run.sh <out-dir> <trial-id> <arm>      arms/<arm>.md is the prompt. Model: $EVAL_MODEL (default opus)
# With PLUGIN_DIR set the session loads that plugin; otherwise it runs with no plugin.
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$1/$3-t$2"; model="${EVAL_MODEL:-opus}"; tools="Read,Glob,Grep,Write,Edit,Bash,Skill,Agent"
rm -rf "$out"; mkdir -p "$out/base" "$out/work"
(cd "$out/base" && bash "$here/fixture.sh")
cp -R "$out/base/." "$out/work/"
if [ -n "${PLUGIN_DIR:-}" ]; then flags=(--setting-sources project --plugin-dir "$PLUGIN_DIR"); else flags=(--safe-mode); fi
(cd "$out/work" && claude -p --model "$model" --output-format json --allowedTools "$tools" "${flags[@]}" < "$here/arms/$3.md") > "$out/result.json" || true
python3 "$here/grade.py" "$out" "$here/heldout" > "$out/grade.json"
echo "$3-t$2 done"
