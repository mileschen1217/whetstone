#!/usr/bin/env bash
# A rule case for the walk after each fix in build's After review.md. One trial: build the reviewed tree, run one arm's
# prompt headless, grade the tree. Arms: bare (fix the findings), walk (bare plus the sentence in the prompt), skill (the
# bare request with the plugin loaded from PLUGIN_DIR, so the sentence comes from skills/build/SKILL.md).
# Usage: [PLUGIN_DIR=<repo>] run.sh <out-dir> <trial-id> <bare|walk|skill>     Model: $EVAL_MODEL (default opus)
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$1/$3-t$2"; model="${EVAL_MODEL:-opus}"; tools="Read,Glob,Grep,Write,Edit,Bash,Skill,Agent"
if [ -n "${PLUGIN_DIR:-}" ]; then flags=(--setting-sources project --plugin-dir "$PLUGIN_DIR"); else flags=(--safe-mode); fi
rm -rf "$out"; mkdir -p "$out/work"
(cd "$out/work" && bash "$here/fixture.sh")
(cd "$out/work" && claude -p --model "$model" --output-format json --allowedTools "$tools" "${flags[@]}" < "$here/arms/$3.md") > "$out/result.json" || true
python3 "$here/grade.py" "$out/work" "$here/heldout" > "$out/grade.json"
echo "$3-t$2 done: $(python3 -c 'import json,sys; g=json.load(open(sys.argv[1])); r=json.load(open(sys.argv[2])); print(g["cells"], "of 7", round(r.get("total_cost_usd",0),2), "USD")' "$out/grade.json" "$out/result.json")"
