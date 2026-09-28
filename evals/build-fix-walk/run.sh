#!/usr/bin/env bash
# One trial: build the reviewed tree, run one arm's prompt headless (no plugin), grade the tree.
# Usage: run.sh <out-dir> <trial-id> <bare|walk>     Model: $EVAL_MODEL (default opus)
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$1/$3-t$2"; model="${EVAL_MODEL:-opus}"; tools="Read,Glob,Grep,Write,Edit,Bash"
rm -rf "$out"; mkdir -p "$out/work"
(cd "$out/work" && bash "$here/fixture.sh")
(cd "$out/work" && claude -p --model "$model" --output-format json --allowedTools "$tools" --safe-mode < "$here/arms/$3.md") > "$out/result.json" || true
python3 "$here/grade.py" "$out/work" "$here/heldout" > "$out/grade.json"
echo "$3-t$2 done: $(python3 -c 'import json,sys; g=json.load(open(sys.argv[1])); r=json.load(open(sys.argv[2])); print(g["cells"], "of 7", round(r.get("total_cost_usd",0),2), "USD")' "$out/grade.json" "$out/result.json")"
