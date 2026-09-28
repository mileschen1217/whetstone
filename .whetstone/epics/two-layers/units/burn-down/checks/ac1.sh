#!/usr/bin/env bash
# AC-1: six planted materials, each graded (finding closed, new defect present); the reader with the text correct in ≥ 5 of 6; the bare arm read and counted the same way.
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"; d="$m/burndown"
[ -n "$m" ] && [ -d "$d" ] || { echo "no burndown material"; exit 1; }
python3 - "$d" <<'PY'
import json, os, re, sys
d = sys.argv[1]; correct = {"": 0, "bare/": 0}; seen = {"": 0, "bare/": 0}
def judge(bd, plant):
    closed = re.search(r"^- finding 1 \(.*?\) — closed —", bd, re.M) is not None
    np, nl = plant["new"]["path"], int(plant["new"]["line"]); named = False
    for mm in re.finditer(r"^- new: (\S+?):(\d+)", bd, re.M):
        if mm.group(1).endswith(np) and abs(int(mm.group(2)) - nl) <= 5: named = True
    return closed, named
for i in range(1, 7):
    p = os.path.join(d, f"m{i}")
    try:
        plant = json.load(open(os.path.join(p, "plant.json"))); grade = json.load(open(os.path.join(p, "grade.json")))
    except Exception as e: print(f"m{i}: missing file: {e}"); sys.exit(1)
    if not (grade.get("finding_closed") is True and grade.get("new_present") is True): print(f"m{i}: grade does not confirm the plants"); sys.exit(1)
    for arm in ("", "bare/"):
        try:
            bd = open(os.path.join(p, arm, "burndown.md"), encoding="utf-8").read(); res = json.load(open(os.path.join(p, arm, "result.json")))
        except Exception as e: print(f"m{i}: missing file: {e}"); sys.exit(1)
        if res.get("total_cost_usd") is None: print(f"m{i}/{arm}: no cost"); sys.exit(1)
        seen[arm] += 1
        closed, named = judge(bd, plant); ok = closed and named; correct[arm] += ok
        print(f"m{i}/{arm or 'text'}: closed={closed} new-named={named} -> {'correct' if ok else 'wrong'}")
print(f"readers correct bare: {correct['bare/']} of {seen['bare/']}")
print(f"readers correct: {correct['']} of {seen['']}")
sys.exit(0 if seen[""] == 6 and seen["bare/"] == 6 and correct[""] >= 5 else 1)
PY
