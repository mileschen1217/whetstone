#!/usr/bin/env bash
# AC-1: six materials, two grader-confirmed plants each; brief-review.md names both with kind in ≥ 4 of 6; false lines and cost recorded.
[ -n "${READ_RUN:-}" ] || { echo "READ_RUN not set"; exit 1; }
python3 - "$READ_RUN" <<'PY'
import json, re, sys
run = sys.argv[1]; found = 0; bad = []
for i in range(1, 7):
    m = f"{run}/m{i}"
    try:
        plant = json.load(open(f"{m}/plant.json"))["plants"]; grade = json.load(open(f"{m}/grade.json")); rev = open(f"{m}/brief-review.md").read()
    except Exception as e:
        bad.append(f"m{i}: missing file ({e})"); continue
    if len(plant) != 2 or {p["kind"] for p in plant} != {"under", "over"}: bad.append(f"m{i}: plants must be one under and one over"); continue
    for p in plant:
        if p["kind"] == "under" and p["mutant"] not in grade.get("survivors", []): bad.append(f"m{i}: under plant {p['ac']} not confirmed ({p['mutant']} not a survivor)")
        if p["kind"] == "over" and p["ac"] not in grade.get("fail_on_reference", []): bad.append(f"m{i}: over plant {p['ac']} not confirmed by fail_on_reference")
    if not re.search(r"(?m)^independent:\s*true\s*$", rev): bad.append(f"m{i}: brief-review.md not independent")
    lines = [l for l in rev.splitlines() if l.startswith("- ")]
    def hits(p): return [l for l in lines if re.search(rf"\b{re.escape(p['ac'])}\s+{p['kind']}\b", l)]
    hit = all(hits(p) for p in plant)
    false = sum(1 for l in lines if not any(l in hits(p) for p in plant))
    cost = None
    try: cost = json.load(open(f"{m}/result.json")).get("total_cost_usd")
    except Exception: bad.append(f"m{i}: no result.json with total_cost_usd")
    print(f"m{i}: both plants found={hit}, false lines={false}, cost={cost}")
    found += 1 if hit else 0
print("both plants found in", found, "of 6")
if bad: print("\n".join(bad))
sys.exit(0 if not bad and found >= 4 else 1)
PY
