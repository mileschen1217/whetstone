#!/usr/bin/env bash
# AC-4: the three ship cases 6 runs each, every grader, with the new grader present in ship-exceptions.
[ -f evals/ship-exceptions/graders/outcome-text-leads-with-decision.md ] || { echo "no outcome-text-leads-with-decision grader"; exit 1; }
grep -qE '^\| AC \|.*\| From \|' evals/ship-exceptions/fixture.sh || { echo "ship-exceptions brief has no From column"; exit 1; }
[ -n "${SHIP_RUN:-}" ] && [ -f "$SHIP_RUN/aggregate-result.json" ] || { echo "SHIP_RUN not set"; exit 1; }
python3 - "$SHIP_RUN/aggregate-result.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); bad = False; want = {"ship-exceptions": 6, "ship-all-green": 6, "ship-memory": 6}; seen = {}
for c in d["cases"]:
    if c["name"] not in want: continue
    runs = c["arms"].get("with", []); seen[c["name"]] = len(runs)
    names = set()
    for i, r in enumerate(runs):
        for g in r.get("graders", []):
            names.add(g["name"])
            if not g["passed"]: print(c["name"], "run", i, g["name"], "failed"); bad = True
    if c["name"] == "ship-exceptions" and "outcome-text-leads-with-decision" not in names: print("new grader not in the run"); bad = True
for k, v in want.items():
    if seen.get(k, 0) < v: print(k, "runs", seen.get(k, 0), "need", v); bad = True
sys.exit(1 if bad else 0)
PY
