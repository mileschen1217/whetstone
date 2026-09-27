#!/usr/bin/env bash
# AC-5: ship 3 cases 6/6; review 5 cases 3/3 result graders; build-reservations skill arm 2 trials.
[ -n "${SHIP_RUN:-}" ] && [ -n "${REVIEW_RUN:-}" ] && [ -n "${BUILD_RUN:-}" ] || { echo "SHIP_RUN, REVIEW_RUN or BUILD_RUN not set"; exit 1; }
python3 - "$SHIP_RUN/aggregate-result.json" "$REVIEW_RUN/aggregate-result.json" <<'PY' || exit 1
import json, sys
want = {"ship-exceptions": 6, "ship-all-green": 6, "ship-memory": 6, "review-one-root-cause": 3, "review-smoke-clean": 3, "review-smoke-policy": 3, "review-silent-failure": 3, "review-policy-masks-defect": 3}
seen = {}; bad = False
for f in sys.argv[1:]:
    for c in json.load(open(f))["cases"]:
        if c["name"] not in want: continue
        runs = c["arms"].get("with", []); seen[c["name"]] = len(runs)
        for i, r in enumerate(runs):
            for g in r.get("graders", []):
                if g["name"].startswith("path-"): continue
                if not g["passed"]: print(c["name"], "run", i, g["name"], "failed"); bad = True
for k, v in want.items():
    if seen.get(k, 0) < v: print(k, "runs", seen.get(k, 0), "need", v); bad = True
sys.exit(1 if bad else 0)
PY
for i in 1 2; do
  g="$BUILD_RUN/skill-t$i/grade.json"; [ -f "$g" ] || { echo "build trial $i missing"; exit 1; }
  python3 -c "import json,sys; d=json.load(open('$g')); sys.exit(0 if d['heldout_passed']>=12 and d['heldout_total']==13 and not d['false_green'] and not d['checks_edited'] else 1)" || { echo "build trial $i: grade failed"; exit 1; }
done
