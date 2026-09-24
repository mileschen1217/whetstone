#!/usr/bin/env bash
# Workspace for the brief-review case: the base inventory repo, the owner's request, and a hand-written draft brief with its checks.
# Two holes are planted, each a kind only the brief lens's walk names:
#   B-5 no red AC — the decision says `load` replaces what is in memory; every check loads into an empty process, so a merging `load` turns nothing red.
#   AC-7 under (proxy) — the Behaviour is about the deployed scheduler calling `expire` every minute; the check calls `expire` itself, a proxy for a thing outside the repo, and the row says `local`.
# The first version planted an under (a boundary value) and an over (a message text); a bare session found both, 3/3 on each arm. Everything else is covered as written. The reviewer reads the brief, its checks and the request; it does not build.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree
rm -rf REVIEW.md CHANGELOG.md tests inventory/cli.py
cat > request.md <<'MD'
Clerks need to hold stock for an order and give it back when the order falls through. A hold that
nobody picks up should expire after ten minutes, so stock does not stay locked. Holds have to
survive a restart of the service. The handheld scanners resend `release` when the network is
flaky, so a repeated release must not blow up.
Everything goes in `inventory/api.py`: `reserve(item, qty, order_id, at=None)`, `reserved(order_id)`,
`release(order_id)`, `expire(now)`, `save(path)`, `load(path)`, `reset()`. `at` and `now` are seconds.
An order holds one item: `reserved(order_id)` returns `(item, qty)`. The others return nothing.
`reserve` replaces the two-argument one that is there now; nothing else calls it.
MD
mkdir -p checks out
cat > brief.md <<'MD'
---
unit: reservations
status: draft
base: reservations-accepted
checks: checks/
---

## Goal

A clerk holds stock for an order and gives it back, and a hold nobody picks up expires after ten minutes, so stock is never lost or locked.

## Done looks like

- `reserve`, `reserved`, `release`, `expire`, `save`, `load` and `reset` exist in `inventory/api.py` and the seven checks below are green.
- You decide the four questions under Needs the owner; nothing else needs you.
- You no longer read the check files; they are the contract with the builder.
- Cost: one build, about 1 USD.

## Decisions

Decisions needed: 4

### Needs the owner

- **B-1 Is a hold of exactly 600 seconds expired or kept?** [silent] [AC-4]
  - taken: kept; `expire(now)` releases holds strictly older than 600 s.
  - not taken: expired at exactly 600 s.
- **B-2 What does a duplicate `order_id` do?** [silent] [AC-2]
  - taken: `reserve` raises `ValueError` and changes nothing; the message text is free.
  - not taken: replace the earlier hold; add to it.
- **B-3 What does `release` of an unknown `order_id` do?** [silent] [AC-3]
  - taken: raises `LookupError`; a repeated release of a hold already given back does nothing.
  - not taken: silent for both.
- **B-5 What does `load` do to holds and levels already in memory?** [silent] [AC-6]
  - taken: replaces them; after `load` only the file's holds and levels exist.
  - not taken: merge the file into memory.

### Record

- **B-4 Stored format** [logged] [AC-6]
  - taken: `save` writes one JSON object; its keys are free.
- A file or stored-data format: JSON, keys free (B-4); `load` replaces memory (B-5). A name or signature code outside the unit will call: the seven functions in the request. A message or exit code a user sees: exception types fixed by B-2 and B-3, message text free.

## Out of scope

The CLI, the scanner, and any change to `add` and `level`.

## For the builder

```
inventory/api.py: reserve(item, qty, order_id, at=None) · reserved(order_id) -> (item, qty) | None · release(order_id) · expire(now) · save(path) · load(path) · reset()
```

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | `reserve` lowers `level(item)` by `qty` and `reserved(order_id)` returns `(item, qty)` | request | `python3 -m pytest -q checks/test_ac1.py` | local |
| AC-2 | A second `reserve` with an `order_id` that already holds raises `ValueError` and changes no level and no hold | B-2 | `python3 -m pytest -q checks/test_ac2.py` | local |
| AC-3 | `release` gives the quantity back to `level(item)`; an unknown `order_id` raises `LookupError`; a repeated release does nothing | B-3 | `python3 -m pytest -q checks/test_ac3.py` | local |
| AC-4 | `expire(now)` releases every hold older than 600 seconds and keeps a hold of exactly 600 seconds | B-1 | `python3 -m pytest -q checks/test_ac4.py` | local |
| AC-5 | `reserved` of an `order_id` that never held returns `None` | request | `python3 -m pytest -q checks/test_ac5.py` | local |
| AC-6 | `save(path)` writes one JSON object; after `reset()` and `load(path)`, every hold, its time and every level are what they were before `save` | request, B-4 | `python3 -m pytest -q checks/test_ac6.py` | local |
| AC-7 | Once the service is deployed, its scheduler calls `expire(now)` every 60 seconds, so no hold outlives 660 seconds | request | `python3 -m pytest -q checks/test_ac7.py` | local |
MD
cat > checks/test_ac1.py <<'PY'
from inventory import api
def test_reserve_lowers_level_and_records():
    api.reset(); api.add("bolt", 10); api.reserve("bolt", 3, "o1", at=0)
    assert api.level("bolt") == 7 and api.reserved("o1") == ("bolt", 3)
PY
cat > checks/test_ac2.py <<'PY'
import pytest
from inventory import api
def test_duplicate_order_raises_and_changes_nothing():
    api.reset(); api.add("bolt", 10); api.reserve("bolt", 3, "o1", at=0)
    with pytest.raises(ValueError): api.reserve("bolt", 2, "o1", at=0)
    assert api.level("bolt") == 7 and api.reserved("o1") == ("bolt", 3)
PY
cat > checks/test_ac3.py <<'PY'
import pytest
from inventory import api
def test_release_gives_back_unknown_raises_repeat_is_quiet():
    api.reset(); api.add("bolt", 10); api.reserve("bolt", 3, "o1", at=0)
    api.release("o1"); assert api.level("bolt") == 10 and api.reserved("o1") is None
    api.release("o1"); assert api.level("bolt") == 10
    with pytest.raises(LookupError): api.release("never")
PY
cat > checks/test_ac4.py <<'PY'
from inventory import api
def test_expire_releases_old_holds():
    api.reset(); api.add("bolt", 10); api.reserve("bolt", 3, "o1", at=0); api.reserve("bolt", 2, "o2", at=100)
    api.expire(600); assert api.reserved("o1") == ("bolt", 3) and api.level("bolt") == 5
    api.expire(601); assert api.reserved("o1") is None and api.reserved("o2") == ("bolt", 2) and api.level("bolt") == 8
PY
cat > checks/test_ac5.py <<'PY'
from inventory import api
def test_reserved_unknown_is_none():
    api.reset(); assert api.reserved("nobody") is None
PY
cat > checks/test_ac6.py <<'PY'
import json
from inventory import api
def test_save_load_round_trip(tmp_path):
    api.reset(); api.add("bolt", 10); api.reserve("bolt", 3, "o1", at=5); p = tmp_path / "s.json"
    api.save(str(p)); assert isinstance(json.load(open(p)), dict)
    api.reset(); assert api.reserved("o1") is None; api.load(str(p))
    assert api.level("bolt") == 7 and api.reserved("o1") == ("bolt", 3)
    api.expire(605); assert api.reserved("o1") == ("bolt", 3)
    api.expire(606); assert api.reserved("o1") is None and api.level("bolt") == 10
PY
cat > checks/test_ac7.py <<'PY'
from inventory import api
def test_hold_gone_within_660s():
    api.reset(); api.add("bolt", 10); api.reserve("bolt", 3, "o1", at=0)
    api.expire(660); assert api.reserved("o1") is None and api.level("bolt") == 10
PY
git init -q . && git add -A && git -c user.email=e@x -c user.name=e commit -qm base
