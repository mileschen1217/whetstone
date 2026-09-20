#!/usr/bin/env bash
# The ship-exceptions unit with nothing wrong: every criterion PASS, a clean and independent review.
# What is measured is how much the approver has to read when there is nothing to decide.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../ship-exceptions/fixture.sh"
python3 - <<'PY'
import re, pathlib
v = pathlib.Path("verdict.md"); s = v.read_text()
s = s.replace("result: not pass", "result: pass").replace("\nCheck files changed since the base: checks/test_ac2.py\n", "")
rows = []
for line in s.splitlines():
    if line.startswith("| AC-"):
        c = [x.strip() for x in line.strip("|").split("|")]
        ex = "exit 0: recorded on the target" if c[0] == "AC-5" else "exit 0: 1 passed in 0.00s"
        note = "from recorded evidence, not run here" if c[0] == "AC-5" else ""
        line = f"| {c[0]} | PASS | {c[2]} | {ex} | {note} |"
    rows.append(line)
v.write_text("\n".join(rows) + "\n")
pathlib.Path("disputed.md").unlink(); pathlib.Path("decisions.md").unlink()
n = pathlib.Path("build-notes.md"); n.write_text(n.read_text().replace(" I tightened one check that was too loose.", ""))
pathlib.Path("review.md").write_text("---\nsubject: reservations unit, 9e72fe3 against brief-accepted\nindependent: true\n---\nclean\n")
PY
