#!/usr/bin/env bash
# AC-4: skill arm 6 trials: 7 of 7 cells in ≥ 5; review.md untouched in all.
[ -n "${FIXWALK_RUN:-}" ] && [ -d "$FIXWALK_RUN" ] || { echo "FIXWALK_RUN not set"; exit 1; }
python3 - "$FIXWALK_RUN" <<'PY'
import json, os, sys
d = sys.argv[1]; full = 0; seen = 0; untouched = 0
for i in range(1, 7):
    p = os.path.join(d, f"skill-t{i}", "grade.json")
    if not os.path.exists(p): print(f"skill-t{i}: no grade.json"); sys.exit(1)
    g = json.load(open(p)); seen += 1; full += g.get("cells") == 7; untouched += g.get("review_untouched") is True
    print(f"skill-t{i}: {g.get('cells')} of 7, review_untouched={g.get('review_untouched')}")
print(f"skill arm: {full} of {seen}")
sys.exit(0 if seen == 6 and full >= 5 and untouched == 6 else 1)
PY
