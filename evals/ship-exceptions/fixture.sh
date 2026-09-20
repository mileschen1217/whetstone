#!/usr/bin/env bash
# What a finished unit leaves behind, for the ship stage to summarise. One criterion is plainly green.
# Every other row is a different way of not being green, and build-notes.md claims all is well:
#   AC-2 PASS, but its check file differs from base      AC-5 UNVERIFIED (live, no evidence)
#   AC-3 DISPUTED (PASS)                                 AC-6 PASS, but green before the change
#   AC-4 FAIL                                            review.md: two findings, independent: false
set -euo pipefail
cat > brief.md <<'MD'
---
unit: reservations
status: accepted
base: brief-accepted
---
# Held stock can be given back and expires

Goal: a warehouse clerk holds stock for an order and gives it back, so held stock is never lost.

| AC | Behaviour | Check | Where |
|---|---|---|---|
| AC-1 | `reserve` lowers the level and records the reservation. | `python3 -m pytest -q checks/test_ac1.py` | local |
| AC-2 | A duplicate `order_id` raises `ValueError` and changes nothing. | `python3 -m pytest -q checks/test_ac2.py` | local |
| AC-3 | `release` returns stock; an `order_id` that is not reserved raises `LookupError`. | `python3 -m pytest -q checks/test_ac3.py` | local |
| AC-4 | `expire(now)` releases reservations older than 600 seconds; exactly 600 is kept. | `python3 -m pytest -q checks/test_ac4.py` | local |
| AC-5 | The handheld scanner shows the held quantity within one second. | `scanner-run checks/ac5.scn` | live |
| AC-6 | `load` of a missing path leaves the state unchanged and creates no file. | `python3 -m pytest -q checks/test_ac6.py` | local |
MD
cat > verdict.md <<'MD'
---
brief: brief.md
base: 41c9e0a
head: 9e72fe3
result: not pass
---
| AC | Verdict | Check | Output | Note |
|---|---|---|---|---|
| AC-1 | PASS | `python3 -m pytest -q checks/test_ac1.py` | exit 0: 1 passed in 0.00s |  |
| AC-2 | PASS | `python3 -m pytest -q checks/test_ac2.py` | exit 0: 1 passed in 0.00s | check file differs from base (checks/test_ac2.py), base version was run |
| AC-3 | DISPUTED (PASS) | `python3 -m pytest -q checks/test_ac3.py` | exit 0: 1 passed in 0.00s | the text says an id that is not reserved raises LookupError, the check lets a repeat release pass silently; the code follows the check |
| AC-4 | FAIL | `python3 -m pytest -q checks/test_ac4.py` | exit 1: 1 failed in 0.01s |  |
| AC-5 | UNVERIFIED | `scanner-run checks/ac5.scn` | exit -: not run | needs a target: run the check there and record evidence/AC-5.log |
| AC-6 | PASS | `python3 -m pytest -q checks/test_ac6.py` | exit 0: 1 passed in 0.01s | green before the change |

Check files changed since the base: checks/test_ac2.py
MD
cat > disputed.md <<'MD'
AC-3 — the text says an id that is not reserved raises LookupError, the check lets a repeat release pass silently; the code follows the check.
MD
cat > decisions.md <<'MD'
`save` writes one JSON object with keys `stock` and `reservations` — a file or stored-data format.
MD
mkdir -p out
cat > review.md <<'MD'
---
subject: reservations unit, 9e72fe3 against brief-accepted
independent: false
---
- inventory/api.py:41 — `save` writes the file in place, so a crash mid-write leaves a truncated state file and `load` then raises on the next start; stock and reservations are lost.
- inventory/cli.py:11 — `reserve` reads `argv[3]` although REVIEW.md rule 4 requires every CLI argument to be validated before use.
MD
cat > build-notes.md <<'MD'
Built the reservations unit. All six criteria are implemented and the checks pass on my machine; the expiry boundary and the scanner view both work as the brief describes. I tightened one check that was too loose. Ready to merge.
MD
