#!/usr/bin/env bash
# Self-review vs fresh review of the same change, outside `claude plugin eval`
# (which cannot continue a session). One trial = one builder session, then
# three reviews of what it built:
#   self   the builder session continues and reviews its own change
#   fresh  a new session reviews it
#   skill  the builder session continues with the plugin loaded
# Usage: run.sh <out-dir> <trial-id>     Model: $EVAL_MODEL (default opus)
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; plugin="$(cd "$here/../.." && pwd)"
out="$1/t$2"; model="${EVAL_MODEL:-opus}"; tools="Read,Glob,Grep,Write,Edit,Agent,Skill"
rm -rf "$out"; mkdir -p "$out/base" "$out/self"
(cd "$out/base" && bash "$here/fixture.sh")
cp -R "$out/base/." "$out/self/"
ask() { # dir, prompt-file, extra flags...
  local dir="$1" prompt="$2"; shift 2
  (cd "$dir" && claude -p --model "$model" --output-format json --allowedTools "$tools" "$@" < "$prompt")
}
ask "$out/self" "$here/builder.md" --safe-mode > "$out/builder.json"
sid="$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["session_id"])' "$out/builder.json")"
(cd "$out" && diff -ruN -x __pycache__ -x .pytest_cache base self | sed 's#^--- base/#--- a/#; s#^+++ self/#+++ b/#' > change.diff) || true
cp "$out/change.diff" "$out/self/change.diff"
find "$out/self" \( -name __pycache__ -o -name .pytest_cache \) -prune -exec rm -rf {} +
cp -R "$out/self" "$out/fresh"
ask "$out/fresh" "$here/review.md" --safe-mode > "$out/fresh.json"
ask "$out/self" "$here/review.md" --safe-mode --resume "$sid" --fork-session > "$out/self.json"
mv "$out/self/out" "$out/self/out.self"
ask "$out/self" "$here/review.md" --setting-sources project --plugin-dir "$plugin" --resume "$sid" --fork-session > "$out/skill.json"
mv "$out/self/out" "$out/self/out.skill"
