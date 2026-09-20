#!/usr/bin/env bash
# Workspace for the second-epic case: the inventory repo after a first epic (low-stock alerts to a
# webhook) has shipped, and the owner's first message for a second one (email alerts).
# Three things were settled with the owner in the first epic and cannot be read from the code (owner.md: P1-P3).
# RECORDS picks what earlier epics left behind:  none | epic | memory (epic plus a memory page)
#   epics2 | memory2: as epic | memory, plus an older epic whose mail decision (an SMTP relay) the later one overtook
#   memory3: as memory2, with the page as an integrating ship would have left it: the overtaken statement rewritten in place
#   memory4: as memory3 without the '(overtakes …)' marker   memory5: the page a run of the ship skill wrote (evals/ship-memory)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree
rm -rf REVIEW.md CHANGELOG.md tests
cat > inventory/api.py <<'PY'
import json, os, urllib.request

STORE = os.environ.get("INVENTORY_STORE", "inventory.json")
_state = {"stock": {}, "thresholds": {}, "outbox": []}


def _load():
    if os.path.exists(STORE):
        _state.update(json.load(open(STORE)))


def _save():
    with open(STORE, "w") as f:
        json.dump(_state, f)


def add(item, qty):
    if qty <= 0:
        raise ValueError("qty must be positive")
    _state["stock"][item] = _state["stock"].get(item, 0) + qty
    _save()


def level(item):
    return _state["stock"].get(item, 0)


def set_threshold(item, n):
    _state["thresholds"][item] = n
    _save()


def threshold(item):
    return _state["thresholds"].get(item, 5)


def reserve(item, qty):
    if qty <= 0:
        raise ValueError("qty must be positive")
    before = level(item)
    if before < qty:
        raise LookupError(f"not enough {item}")
    _state["stock"][item] = before - qty
    if before > threshold(item) >= level(item):
        _state["outbox"].append({"item": item, "level": level(item)})
    _save()
    flush()


def low_items():
    return sorted(i for i in _state["stock"] if level(i) <= threshold(i))


def flush():
    url = os.environ.get("PURCHASING_WEBHOOK")
    left = []
    for alert in _state["outbox"]:
        try:
            if not url:
                raise OSError("PURCHASING_WEBHOOK is not set")
            req = urllib.request.Request(url, json.dumps(alert).encode(), {"Content-Type": "application/json"})
            urllib.request.urlopen(req, timeout=5)
        except OSError:
            left.append(alert)
    _state["outbox"] = left
    _save()


_load()
PY
cat > inventory/cli.py <<'PY'
import sys

from inventory import api


def main(argv):
    api.flush()
    if argv[0] == "report":
        for item in api.low_items():
            print(item, api.level(item), api.threshold(item))
        return
    cmd, item, qty = argv[0], argv[1], int(argv[2])
    if cmd == "add":
        api.add(item, qty)
    elif cmd == "reserve":
        api.reserve(item, qty)
    elif cmd == "threshold":
        api.set_threshold(item, qty)
    print(api.level(item))


if __name__ == "__main__":
    main(sys.argv[1:])
PY
cat > request.md <<'MD'
The webhook to purchasing works well. Now the shift lead wants to know too: when an item goes low,
send them an email.
MD
if [ "${RECORDS:-none}" != none ]; then  # every setting but none has the low-stock epic
mkdir -p .whetstone/epics/2026-08-low-stock
cat > .whetstone/epics/2026-08-low-stock/epic.md <<'MD'
---
epic: low-stock
status: accepted
---
Intent: the warehouse runs out of things without anyone noticing; purchasing is told through their webhook when an item goes low, and clerks see the low items in a morning `report`.

## Today
- `inventory/api.py`: stock in a module-level dict, lost when the process ends.
- `inventory/cli.py`: `add` and `reserve` only. There is no `report` command (`inventory/cli.py:6`), though the request assumes one.

## Requirements
- REQ-1 Each item has a threshold; 5 when none is set.
- REQ-2 Purchasing is told once when an item goes from above its threshold to at or below it, and not again while it stays low.
- REQ-3 `reserve` succeeds when the webhook cannot be reached, and the alert is delivered later.
- REQ-4 `report` lists every item at or below its threshold.
- REQ-5 Stock, thresholds and undelivered alerts survive the process.

## Decisions
- D-1 The smallest change was chosen: the alert is raised inside `reserve` and posted from `api.py`. Not taken: a notifier module with channels. The owner named email as possibly coming, with an SMS gateway after it, and chose to pay for the restructuring when the second channel arrives.
- D-2 Undelivered alerts are retried at the start of the next CLI run. Not taken: a background process that retries. Operations do not allow long-running processes on the warehouse hosts.
- D-3 The webhook is called over HTTPS through the corporate proxy. The warehouse hosts can reach nothing else: every outbound port except HTTPS to the proxy is closed.
- D-4 State is one JSON file, path from `INVENTORY_STORE`. Not taken: SQLite.

## Units
- U1 store and thresholds (REQ-1, REQ-5) · U2 crossing and outbox (REQ-2, REQ-3) · U3 report (REQ-4)

Out of scope: history, several warehouses, any channel other than the webhook.
MD
fi
case "${RECORDS:-none}" in epics2|memory2|memory3|memory4|memory5)
mkdir -p .whetstone/epics/2026-03-restock-summary
cat > .whetstone/epics/2026-03-restock-summary/epic.md <<'MD'
---
epic: restock-summary
status: accepted
---
Intent: purchasing gets a weekly email listing what was restocked, so they can reconcile invoices.

## Requirements
- REQ-1 `summary` emails the week's `add` totals per item to purchasing.

## Decisions
- D-1 The email is sent with `smtplib` through the relay `smtp.corp.example:25`, which the warehouse hosts can reach. Not taken: a mail provider's API, which needs an account nobody has.
- D-2 The recipient comes from `PURCHASING_EMAIL`.

## Units
- U1 the `summary` command (REQ-1)

Out of scope: attachments, HTML mail.

Retired 2026-07: purchasing reconciles from their own system now; the `summary` command was removed.
MD
;; esac
if [ "${RECORDS:-none}" = memory ] || [ "${RECORDS:-none}" = memory2 ] || [ "${RECORDS:-none}" = memory3 ] || [ "${RECORDS:-none}" = memory4 ] || [ "${RECORDS:-none}" = memory5 ]; then
mkdir -p .whetstone/memory
cat > .whetstone/memory/alerts.md <<'MD'
---
about: How low-stock alerts are raised and delivered, what is planned next, and what the warehouse hosts allow.
scope: [inventory/api.py, inventory/cli.py]
---
## Constraints
- No long-running process on the warehouse hosts: anything deferred happens at the start of the next CLI run. check: none · from: low-stock D-2
- The warehouse hosts reach the outside only over HTTPS through the corporate proxy; every other outbound port is closed. check: none · from: low-stock D-3

## Facts from the owner
- The alert code was kept inline in `reserve` on purpose; the owner chose to pay for a notifier with channels when the second channel arrives. from: low-stock D-1
- An SMS gateway is planned after email. from: low-stock D-1
MD
fi
if [ "${RECORDS:-none}" = memory4 ]; then
python3 - <<'PY'
p = ".whetstone/memory/alerts.md"; s = open(p).read()
s = s.replace("every other outbound port is closed. check: none · from: low-stock D-3", "every other outbound port is closed, the internal relay `smtp.corp.example:25` included: mail cannot leave over SMTP. check: none · from: low-stock D-3")
open(p, "w").write(s)
PY
fi
if [ "${RECORDS:-none}" = memory5 ]; then
rm .whetstone/memory/alerts.md
cat > .whetstone/memory/outbound.md <<'MD'
---
about: What the warehouse hosts can reach, and how anything leaves them.
scope: [inventory/]
---
## Constraints
- Anything that leaves a warehouse host goes over HTTPS through the corporate proxy; since 2026-06 every other outbound port is closed, the relay `smtp.corp.example:25` included. check: none · from: low-stock D-3
- Work that has to be reattempted rides on the next CLI run: operations do not allow long-running processes on the warehouse hosts. check: none · from: low-stock D-2
MD
fi
if [ "${RECORDS:-none}" = memory3 ]; then
python3 - <<'PY'
p = ".whetstone/memory/alerts.md"; s = open(p).read()
s = s.replace("every other outbound port is closed. check: none · from: low-stock D-3", "every other outbound port is closed, the internal relay `smtp.corp.example:25` included: mail cannot leave over SMTP. check: none · from: low-stock D-3 (overtakes restock-summary D-1)")
open(p, "w").write(s)
PY
fi
git init -q . && git add -A && git -c user.email=e@x -c user.name=e commit -qm "low-stock epic shipped"
