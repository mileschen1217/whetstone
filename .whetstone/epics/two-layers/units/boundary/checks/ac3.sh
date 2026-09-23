#!/usr/bin/env bash
# AC-3: two headless ship runs on the real unit 1 inputs: no stored-format decision above the line, the 6 fixed findings below, count ≤ 4.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"
[ -n "$m" ] || { echo "TWO_LAYERS_MATERIAL not set"; exit 1; }
for i in 1 2; do
  f="$m/layered/pr-boundary-$i.md"; [ -f "$f" ] || { echo "no $f"; exit 1; }
  python3 "$here/shape.py" "$f" --count >/dev/null || { echo "shape: $f"; exit 1; }
  above="$(awk '/^## Needs the owner/{on=1;next} /^## Record/{on=0} on' "$f")"; below="$(awk '/^## Record/{on=1;next} /^## /{on=0} on' "$f")"
  if printf '%s\n' "$above" | grep -E '^\| *decision' | grep -qE 'a stored format'; then echo "$f: a stored-format decision above the line"; exit 1; fi
  nf="$(printf '%s\n' "$below" | grep -cE '^\| *[A-Za-z0-9_./-]+:[0-9]+ ')"; [ "$nf" -ge 6 ] || { echo "$f: only $nf findings under Record, need 6"; exit 1; }
  n="$(grep -oE 'Decisions needed: *[0-9]+' "$f" | grep -oE '[0-9]+$')"; [ -n "$n" ] && [ "$n" -le 4 ] || { echo "$f: Decisions needed $n > 4"; exit 1; }
done
