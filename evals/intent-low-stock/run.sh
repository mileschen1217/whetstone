#!/usr/bin/env bash
# One intent trial: the agent under test and an agent playing the owner (owner.md) take turns.
# Usage: run.sh <out-dir> <trial-id> <arm>   Models: $EVAL_MODEL (default opus), $OWNER_MODEL (default sonnet).
# With PLUGIN_DIR set the agent under test loads that plugin. At most $MAX_ROUNDS owner replies (default 6).
# <out-dir> must not be under a directory a headless session is refused writes in (see RUNBOOK).
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
out="$1/$3-t$2"; model="${EVAL_MODEL:-opus}"; owner="${OWNER_MODEL:-sonnet}"; rounds="${MAX_ROUNDS:-6}"
rm -rf "$out"; mkdir -p "$out/work" "$out/owner"
(cd "$out/work" && bash "$here/fixture.sh")
if [ -n "${PLUGIN_DIR:-}" ]; then flags=(--setting-sources project --plugin-dir "$PLUGIN_DIR"); else flags=(--safe-mode); fi
ask() { (cd "$out/work" && claude -p --model "$model" --output-format json --allowedTools "Read,Glob,Grep,Write,Edit,Bash,Skill,Agent" "${flags[@]}" "$@"); }
field() { python3 -c "import json,sys; print(json.load(open(sys.argv[1])).get(sys.argv[2]) or '')" "$1" "$2"; }
ask < "$here/arms/$3.md" > "$out/turn0.json" || true
sid="$(field "$out/turn0.json" session_id)"; : > "$out/transcript.md"; n=0
while :; do
  msg="$(field "$out/turn$n.json" result)"
  printf '## developer %s\n\n%s\n\n' "$n" "$msg" >> "$out/transcript.md"
  if printf '%s' "$msg" | grep -qE '(^|[^A-Za-z])DONE([^A-Za-z]|$)' || [ "$n" -ge "$rounds" ]; then break; fi
  reply="$(cd "$out/owner" && { cat "$here/owner.md"; printf '\n\nThe conversation so far:\n\n'; cat "$out/transcript.md"; printf '\nWrite your next reply to the developer, and nothing else.\n'; } | claude -p --model "$owner" --safe-mode --allowedTools "" 2>/dev/null)" || reply="Not decided. Use your judgement and tell me what you chose."
  printf '## owner %s\n\n%s\n\n' "$n" "$reply" >> "$out/transcript.md"
  n=$((n+1))
  printf '%s' "$reply" | ask --resume "$sid" > "$out/turn$n.json" || true
done
python3 "$here/grade.py" "$out" > "$out/grade.json"
echo "$3-t$2 done ($n owner replies)"
