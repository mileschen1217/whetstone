#!/usr/bin/env bash
# The ship stage's memory walk. A unit of the low-stock epic is built, verified green and reviewed clean.
# Its epic.md holds two decisions this unit makes true that the code does not show (D-2, D-3), and one the
# code does show (D-4). A memory page from an earlier epic still says mail and alerts may leave through an
# SMTP relay, which D-3 overtakes. decisions.md has one line that outlives the diff.
set -euo pipefail
mkdir -p inventory out .whetstone/memory .whetstone/epics/2026-03-restock-summary .whetstone/epics/2026-08-low-stock/units/u2-outbox
printf 'import json, os\nSTORE = os.environ.get("INVENTORY_STORE", "inventory.json")\n# outbox entries are retried by flush() at the start of each CLI run\n' > inventory/api.py
cat > .whetstone/memory/outbound.md <<'MD'
---
about: What the warehouse hosts can reach, and how anything leaves them.
scope: [inventory/]
---
## Constraints
- Mail and other notifications leave through the relay `smtp.corp.example:25`, which the warehouse hosts can reach. check: none · from: restock-summary D-1
MD
cat > .whetstone/epics/2026-03-restock-summary/epic.md <<'MD'
---
epic: restock-summary
status: accepted
---
## Decisions
- D-1 The email is sent with `smtplib` through the relay `smtp.corp.example:25`, which the warehouse hosts can reach.
MD
cd .whetstone/epics/2026-08-low-stock
cat > epic.md <<'MD'
---
epic: low-stock
status: accepted
---
Intent: purchasing is told through their webhook when an item goes low.

## Decisions
- D-2 Undelivered alerts are retried at the start of the next CLI run. Not taken: a background process. Operations do not allow long-running processes on the warehouse hosts.
- D-3 The webhook is called over HTTPS through the corporate proxy. Since 2026-06 the warehouse hosts can reach nothing else: every other outbound port is closed, the relay `smtp.corp.example:25` included.
- D-4 State is one JSON file, path from `INVENTORY_STORE`. Not taken: SQLite.

## Units
- U2 crossing and outbox (D-2, D-3, D-4)
MD
cd units/u2-outbox
cat > brief.md <<'MD'
---
unit: u2-outbox
status: accepted
base: brief-accepted
checks: checks/
---
Goal: purchasing is told once when an item goes low, and no alert is lost when the webhook is down.

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | A reserve that takes an item from above its threshold to at or below it queues one alert. | request | `python3 -m pytest -q checks/test_ac1.py` | local |
| AC-2 | With the webhook unreachable `reserve` succeeds and the alert is still queued after the run. | request | `python3 -m pytest -q checks/test_ac2.py` | local |
MD
cat > verdict.md <<'MD'
---
brief: brief.md
base: 41c9e0a
head: 7be21d0
result: pass
---
| AC | Verdict | Check | Output | Note |
|---|---|---|---|---|
| AC-1 | PASS | `python3 -m pytest -q checks/test_ac1.py` | exit 0: 1 passed in 0.01s |  |
| AC-2 | PASS | `python3 -m pytest -q checks/test_ac2.py` | exit 0: 2 passed in 0.01s |  |
MD
printf -- '---\nsubject: u2-outbox, 7be21d0 against brief-accepted\nindependent: true\n---\nclean\n' > review.md
cat > decisions.md <<'MD'
The outbox is a list under the key `outbox` in the JSON store, each entry `{"item", "level"}` — a stored-data format.
MD
