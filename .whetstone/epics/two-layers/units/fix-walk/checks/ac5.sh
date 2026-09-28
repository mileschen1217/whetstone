#!/usr/bin/env bash
# AC-5: build-reservations skill arm 2 trials; build-burndown 3/3 every grader.
[ -n "${BUILD_RUN:-}" ] && [ -n "${CASE_RUN:-}" ] || { echo "BUILD_RUN or CASE_RUN not set"; exit 1; }
for i in 1 2; do
  g="$BUILD_RUN/skill-t$i/grade.json"; [ -f "$g" ] || { echo "build trial $i missing"; exit 1; }
  python3 -c "import json,sys; d=json.load(open('$g')); sys.exit(0 if d['heldout_passed']>=12 and d['heldout_total']==13 and not d['false_green'] and not d['checks_edited'] else 1)" || { echo "build trial $i: grade failed"; exit 1; }
done
python3 - "$CASE_RUN/aggregate-result.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); c = [c for c in d["cases"] if c["name"] == "build-burndown"]
if not c: print("no build-burndown case"); sys.exit(1)
runs = c[0]["arms"].get("with", []); bad = len(runs) < 3
for i, r in enumerate(runs):
    for g in r.get("graders", []):
        if not g["passed"]: print("run", i, g["name"], "failed"); bad = True
print("build trials 2 of 2 graded; build-burndown", len(runs), "runs"); sys.exit(1 if bad else 0)
PY
