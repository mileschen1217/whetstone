#!/usr/bin/env bash
# AC-9: intent-low-stock skill-epic arm, 2 trials: the epic.md has the count line, the two headings, every D-n tagged.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -n "${INTENT_RUN:-}" ] || { echo "INTENT_RUN not set"; exit 1; }
for i in 1 2; do
  e="$(ls "$INTENT_RUN"/skill-epic-t$i/work/.whetstone/epics/*/epic.md 2>/dev/null | head -1)"
  [ -n "$e" ] || { echo "trial $i: no epic.md"; exit 1; }
  python3 "$here/shape.py" "$e" >/dev/null || { echo "shape: $e"; exit 1; }
  grep -qE 'Decisions needed:\s*[0-9]+' "$e" || { echo "trial $i: no Decisions needed line"; exit 1; }
  dn="$(grep -cE '^- \**D-[0-9]+' "$e")"; ok="$(grep -E '^- \**D-[0-9]+' "$e" | grep -cE '\[(silent|state|reader|logged)\] *$')"
  [ "$dn" -ge 1 ] && [ "$ok" -eq "$dn" ] || { echo "trial $i: $ok of $dn D-n lines end with a tag"; exit 1; }
done
