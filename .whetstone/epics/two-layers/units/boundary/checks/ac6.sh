#!/usr/bin/env bash
# AC-6: owner-boundary.md: decision, a reason in the owner's words, and whether every row above the line needed them.
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"
f="$m/owner-boundary.md"; [ -n "$m" ] && [ -f "$f" ] || { echo "no owner-boundary.md"; exit 1; }
python3 - "$f" <<'PY'
import re, sys
t = open(sys.argv[1]).read(); bad = []
if not re.search(r"(?m)^page:\s*pr\s*$", t): bad.append("no page: pr")
if not re.search(r"(?m)^decision:\s*(merge|do not merge)\s*$", t): bad.append("no decision")
r = re.search(r"(?m)^reason:\s*(.+)$", t)
if not r or len(r.group(1).strip()) < 10: bad.append("no reason of 10+ characters")
if not re.search(r"(?m)^every-row-needs-me:\s*(yes|no)\s*$", t): bad.append("no every-row-needs-me line")
print("\n".join(bad)); sys.exit(1 if bad else 0)
PY
