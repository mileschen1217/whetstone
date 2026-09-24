#!/usr/bin/env bash
# AC-5: the two test-2 changes are in line.md; one real run of ship has ≤ 2 rows above the line, the model row among them.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
f=skills/line.md
grep -qF -- "not there or fails, across the boundary" "$f" || { echo "line.md lacks: across the boundary on the fourth cell"; exit 1; }
grep -qF -- "a message whose reader is an agent is not a message a person sees" "$f" || { echo "line.md lacks the agent-reader sentence"; exit 1; }
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"; p="$m/layered/pr-read-1.md"
[ -n "$m" ] && [ -f "$p" ] || { echo "no pr-read-1.md"; exit 1; }
python3 "$here/shape.py" "$p" --count >/dev/null || { echo "shape: $p"; exit 1; }
above="$(awk '/^## Needs the owner/{on=1;next} /^## Record/{on=0} on' "$p" | grep -E '^\| ' | grep -vE '^\| *(Item|---)')"
n="$(printf '%s\n' "$above" | grep -c '^| ')"; [ "$n" -le 2 ] || { echo "$n rows above the line, need 2 or fewer"; exit 1; }
printf '%s\n' "$above" | grep -q 'SIGHTRAIL_MODEL\|_MODEL' || { echo "the model row is not above the line"; exit 1; }
