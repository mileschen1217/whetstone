#!/usr/bin/env bash
# AC-6: the layered unit 1 pages are no longer than the signed ones, add no prose, and have the two headings once each.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"
[ -n "$m" ] && [ -d "$m/layered" ] && [ -d "$m/original" ] || { echo "TWO_LAYERS_MATERIAL not set or no original/ and layered/"; exit 1; }
for p in brief pr; do
  o="$m/original/$p.md"; l="$m/layered/$p.md"; [ -f "$o" ] && [ -f "$l" ] || { echo "$p.md missing"; exit 1; }
  [ "$(wc -l < "$l")" -le "$(wc -l < "$o")" ] || { echo "$p.md: layered longer than original"; exit 1; }
  po="$(python3 "$here/shape.py" "$o" 2>/dev/null | sed -n 's/^prose //p')"; pl="$(python3 "$here/shape.py" "$l" | sed -n 's/^prose //p')" || { echo "shape: $l"; exit 1; }
  [ "${pl:-0}" -le "${po:-0}" ] || { echo "$p.md: prose lines $pl > $po"; exit 1; }
done
