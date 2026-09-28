#!/usr/bin/env bash
# AC-7: build-burndown with the skill, 3 of 3 runs, every grader.
[ -n "${CASE_RUN:-}" ] && [ -f "$CASE_RUN/aggregate-result.json" ] || { echo "CASE_RUN not set"; exit 1; }
python3 - "$CASE_RUN/aggregate-result.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); c = [c for c in d["cases"] if c["name"] == "build-burndown"]
if not c: print("no build-burndown case"); sys.exit(1)
runs = c[0]["arms"].get("with", []); bad = len(runs) < 3
for i, r in enumerate(runs):
    for g in r.get("graders", []):
        if not g["passed"]: print("run", i, g["name"], "failed"); bad = True
print(len(runs), "runs"); sys.exit(1 if bad else 0)
PY
