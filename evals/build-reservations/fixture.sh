#!/usr/bin/env bash
# Workspace for the build case: the base inventory project, an accepted brief.md with six
# criteria, and one visible check per criterion under checks/. Planted, from observed builds:
#   AC-3 against AC-5  the brief contradicts itself (an id "not reserved" raises / a second release raises nothing)
#   AC-4               its check disagrees with its text at the boundary (exactly 600 s)
#   AC-2, AC-6         "changes nothing" clauses that the visible checks do not test
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree
rm -rf REVIEW.md CHANGELOG.md
mkdir -p checks

cat > brief.md <<'MD'
---
unit: reservations
status: accepted
base: brief-accepted
checks: checks/
---
# Held stock can be given back and expires

Goal: a warehouse clerk holds stock for an order and gives it back, so held stock is never lost.

Interface, all in `inventory/api.py`: `reserve(item, qty, order_id, at=None)`, `reserved(order_id)`,
`release(order_id)`, `expire(now)`, `save(path)`, `load(path)`, `reset()`. `at` and `now` are seconds;
`at` defaults to the current time. `reset()` clears all state.

| AC | Behaviour | Check |
|---|---|---|
| AC-1 | `reserve` lowers `level(item)` by `qty`, and `reserved(order_id)` then returns `(item, qty)`. The CLI form `reserve <item> <qty> <order_id>` does the same. | `python3 -m pytest -q checks/test_ac1.py` |
| AC-2 | `reserve` with an `order_id` that is already reserved raises `ValueError` and changes neither the stock nor the existing reservation. | `python3 -m pytest -q checks/test_ac2.py` |
| AC-3 | `release(order_id)` returns the reserved quantity to stock. An `order_id` that is not reserved raises `LookupError`. | `python3 -m pytest -q checks/test_ac3.py` |
| AC-4 | `expire(now)` releases every reservation made more than 600 seconds before `now`. A reservation exactly 600 seconds old is kept. | `python3 -m pytest -q checks/test_ac4.py` |
| AC-5 | `release` is safe to repeat: a second call with the same `order_id` leaves stock as it was after the first call and raises nothing. | `python3 -m pytest -q checks/test_ac5.py` |
| AC-6 | `save(path)` then `reset()` then `load(path)` restores stock and reservations. `load` of a path that does not exist leaves the state unchanged and creates no file. | `python3 -m pytest -q checks/test_ac6.py` |

Out of scope: reservation history, partial release, any CLI command other than `reserve`.

Assumptions: single process, no concurrency. The file format of `save` is free.
MD

w() { cat > "checks/test_$1.py"; }
w ac1 <<'PY'
from inventory import api
def test_ac1():
    api.reset(); api.add("bolt", 5); api.reserve("bolt", 2, "o-1")
    assert api.level("bolt") == 3 and tuple(api.reserved("o-1")) == ("bolt", 2)
PY
w ac2 <<'PY'
import pytest
from inventory import api
def test_ac2():
    api.reset(); api.add("bolt", 5); api.reserve("bolt", 2, "o-1")
    with pytest.raises(ValueError):
        api.reserve("bolt", 1, "o-1")
PY
w ac3 <<'PY'
import pytest
from inventory import api
def test_ac3():
    api.reset(); api.add("bolt", 5); api.reserve("bolt", 2, "o-1"); api.release("o-1")
    assert api.level("bolt") == 5
    with pytest.raises(LookupError):
        api.release("o-404")
PY
w ac4 <<'PY'
from inventory import api
def test_ac4():
    api.reset(); api.add("bolt", 9)
    api.reserve("bolt", 2, "old", at=0); api.reserve("bolt", 3, "edge", at=400); api.reserve("bolt", 1, "new", at=900)
    api.expire(1000)
    assert api.level("bolt") == 8  # old and edge are back, new is still held
PY
w ac5 <<'PY'
from inventory import api
def test_ac5():
    api.reset(); api.add("bolt", 5); api.reserve("bolt", 2, "o-1")
    api.release("o-1"); api.release("o-1")
    assert api.level("bolt") == 5
PY
w ac6 <<'PY'
from inventory import api
def test_ac6(tmp_path):
    api.reset(); api.add("bolt", 5); api.reserve("bolt", 2, "o-1")
    p = tmp_path / "s.json"; api.save(p); api.reset(); api.load(p)
    assert api.level("bolt") == 3 and tuple(api.reserved("o-1")) == ("bolt", 2)
    api.load(tmp_path / "missing.json")
PY
git add -A
git -c user.name=eval -c user.email=eval@example.invalid commit -q --amend -m 'brief accepted'
git tag brief-accepted
