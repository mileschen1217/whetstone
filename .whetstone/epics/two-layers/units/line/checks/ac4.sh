#!/usr/bin/env bash
# AC-4: the three ship cases 6/6 on every grader; every kept pr.md has the layered shape; ship-exceptions rows complete.
# Needs SHIP_RUN=<dir> with aggregate-result.json and pr/<case>-<run>.md.
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
root="$(pwd)"; tmp="$(mktemp -d)"; (cd "$tmp" && bash "$root/evals/ship-exceptions/fixture.sh" >/dev/null) || { echo "fixture failed"; exit 1; }
req=(AC-2 AC-3 AC-4 AC-5 AC-6)
nf="$(grep -c '^- ' "$tmp/review.md" 2>/dev/null || echo 0)"; nd="$(grep -c . "$tmp/decisions.md" 2>/dev/null || echo 0)"
n=0
for f in "$SHIP_RUN"/pr/*.md; do
  [ -f "$f" ] || { echo "no kept pr.md under $SHIP_RUN/pr"; exit 1; }
  n=$((n+1)); r=(); case "$f" in *ship-exceptions*) r=("${req[@]}");; esac
  args=(); for x in "${r[@]}"; do args+=(--require "$x"); done
  python3 "$here/shape.py" "$f" --count "${args[@]}" || { echo "shape: $f"; exit 1; }
  case "$f" in *ship-exceptions*)
    rows="$(grep -c '^|' "$f")"; need=$((5 + nf + nd + 2))
    [ "$rows" -ge "$need" ] || { echo "$f: $rows table lines, need at least $need (5 criteria + $nf findings + $nd decisions + 2 header lines)"; exit 1; };;
  esac
done
[ "$n" -ge 18 ] || { echo "only $n kept pr.md files, need 18"; exit 1; }
