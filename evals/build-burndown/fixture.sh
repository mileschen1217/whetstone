#!/usr/bin/env bash
# The reservations change (reserve takes an order_id; release returns the qty) with one reviewed defect:
# a repeated order_id drops the stock twice and overwrites the record. The fix rejects a repeated order_id
# and, while touching release(), writes `_stock[item] = qty` for `+= qty`: release now overwrites the stock
# with the reserved quantity, no error, no test. unit/review.md names the finding; unit/fixes.diff is the fix.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree

cat > inventory/api.py <<'PY'
_stock = {}
_reserved = {}


def add(item, qty):
    if qty <= 0:
        raise ValueError("qty must be positive")
    _stock[item] = _stock.get(item, 0) + qty


def reserve(item, qty, order_id):
    if qty <= 0:
        raise ValueError("qty must be positive")
    if _stock.get(item, 0) < qty:
        raise LookupError(f"not enough {item}")
    _stock[item] -= qty
    _reserved[order_id] = (item, qty)


def release(order_id):
    item, qty = _reserved[order_id]
    _stock[item] += qty
    del _reserved[order_id]


def level(item):
    return _stock.get(item, 0)
PY
cat > inventory/cli.py <<'PY'
import sys

from inventory import api


def main(argv):
    cmd, item, qty = argv[0], argv[1], int(argv[2])
    if cmd == "add":
        api.add(item, qty)
    elif cmd == "reserve":
        api.reserve(item, qty, argv[3])
    print(api.level(item))


if __name__ == "__main__":
    main(sys.argv[1:])
PY
cat > tests/test_api.py <<'PY'
import pytest

from inventory import api


def setup_function():
    api._stock.clear()
    api._reserved.clear()


def test_reserve_reduces_level():
    api.add("bolt", 5)
    api.reserve("bolt", 2, "o1")
    assert api.level("bolt") == 3


def test_reserve_more_than_stock():
    api.add("bolt", 1)
    with pytest.raises(LookupError):
        api.reserve("bolt", 2, "o1")


def test_release_forgets_the_order():
    api.add("bolt", 5)
    api.reserve("bolt", 2, "o1")
    api.release("o1")
    assert "o1" not in api._reserved
PY
cat > CHANGELOG.md <<'MD'
# Changelog

## Unreleased

- `reserve` takes an `order_id`; `release(order_id)` returns the reserved quantity to stock.
- `add` rejects non-positive quantities.
MD
amend_base
mkdir -p unit out
cat > unit/review.md <<'MD'
---
subject: the reservations change
independent: true
---
- inventory/api.py:17 — reserve with an order_id already in _reserved drops the stock a second time and overwrites the earlier record, so the first reservation's qty can never be released; no error is raised.
MD

python3 - <<'PY'
import pathlib
p = pathlib.Path("inventory/api.py"); s = p.read_text()
s = s.replace('''    if qty <= 0:
        raise ValueError("qty must be positive")
    if _stock.get(item, 0) < qty:''', '''    if qty <= 0:
        raise ValueError("qty must be positive")
    if order_id in _reserved:
        raise ValueError(f"order {order_id} is already reserved")
    if _stock.get(item, 0) < qty:''')
s = s.replace('''    item, qty = _reserved[order_id]
    _stock[item] += qty
    del _reserved[order_id]''', '''    item, qty = _reserved.pop(order_id)
    _stock[item] = qty''')
p.write_text(s)
t = pathlib.Path("tests/test_api.py"); t.write_text(t.read_text() + '''

def test_repeated_order_id_is_rejected():
    api.add("bolt", 5)
    api.reserve("bolt", 2, "o1")
    with pytest.raises(ValueError):
        api.reserve("bolt", 1, "o1")
    assert api.level("bolt") == 3
''')
PY
git diff > unit/fixes.diff
rm -rf .git
