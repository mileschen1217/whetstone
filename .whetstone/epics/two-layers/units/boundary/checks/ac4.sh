#!/usr/bin/env bash
# AC-4: ship cases 6/6 on every grader; kept pages keep the shape; the JSON decision is under Record in 6/6 of ship-exceptions.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -n "${SHIP_RUN:-}" ] && [ -f "$SHIP_RUN/aggregate-result.json" ] || { echo "SHIP_RUN not set or no aggregate-result.json"; exit 1; }
python3 - "$SHIP_RUN/aggregate-result.json" <<'PY' || exit 1
import json, sys
d = json.load(open(sys.argv[1])); seen = set(); bad = False
for c in d["cases"]:
    if c["name"] not in ("ship-exceptions", "ship-all-green", "ship-memory"): continue
    seen.add(c["name"]); runs = c["arms"].get("with", [])
    if len(runs) != 6: print(c["name"], "runs", len(runs)); bad = True
    for i, r in enumerate(runs):
        for g in r.get("graders", []):
            if not g["passed"]: print(c["name"], "run", i, "grader", g["name"], "failed"); bad = True
missing = {"ship-exceptions", "ship-all-green", "ship-memory"} - seen
if missing: print("cases missing:", sorted(missing)); bad = True
sys.exit(1 if bad else 0)
PY
n=0; j=0
for f in "$SHIP_RUN"/pr/*.md; do
  [ -f "$f" ] || { echo "no kept pr.md under $SHIP_RUN/pr"; exit 1; }
  n=$((n+1)); python3 "$here/shape.py" "$f" --count >/dev/null || { echo "shape: $f"; exit 1; }
  case "$f" in *ship-exceptions*)
    below="$(awk '/^## Record/{on=1;next} /^## /{on=0} on' "$f")"
    printf '%s\n' "$below" | grep -E '^\| *decision' | grep -qi 'JSON' && j=$((j+1));;
  esac
done
[ "$n" -ge 18 ] || { echo "only $n kept pages, need 18"; exit 1; }
[ "$j" -eq 6 ] || { echo "JSON decision under Record in $j of 6 ship-exceptions pages"; exit 1; }
