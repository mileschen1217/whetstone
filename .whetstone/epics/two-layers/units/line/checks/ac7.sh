#!/usr/bin/env bash
# AC-7: owner.md beside the layered pages: per page a decision and a reason in the owner's words, read above the line only.
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"
f="$m/owner.md"; [ -n "$m" ] && [ -f "$f" ] || { echo "no owner.md"; exit 1; }
python3 - "$f" <<'PY'
import re, sys
t = open(sys.argv[1]).read(); bad = []
pages = re.split(r"(?m)^page:\s*", t)[1:]
names = [p.split("\n", 1)[0].strip() for p in pages]
if sorted(names) != ["brief", "pr"]: bad.append("pages are %s, need brief and pr" % names)
for name, p in zip(names, pages):
    d = re.search(r"(?m)^decision:\s*(accept|reject|merge|do not merge)\s*$", p)
    r = re.search(r"(?m)^reason:\s*(.+)$", p)
    a = re.search(r"(?m)^read-above-only:\s*yes\s*$", p)
    if not d: bad.append(f"{name}: no decision")
    if not r or len(r.group(1).strip()) < 10: bad.append(f"{name}: no reason of 10+ characters")
    if not a: bad.append(f"{name}: no read-above-only: yes")
if not re.search(r"(?m)^brief-foresaw-live:\s*(yes|no)\s*$", t): bad.append("no brief-foresaw-live line")
print("\n".join(bad)); sys.exit(1 if bad else 0)
PY
