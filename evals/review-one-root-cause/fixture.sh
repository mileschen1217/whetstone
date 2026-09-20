#!/usr/bin/env bash
# Large change (orders, pricing, paging, CLI, tests) with three planted
# defects buried in otherwise working code:
#  1. paging.page slices one item short (start:start+size-1).
#  2. orders.new_order uses a mutable default for lines, shared across orders.
#  3. pricing.parse_rate has a bare except (REVIEW.md rule 2).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree

cat > inventory/pricing.py <<'PY'
"""Prices are integer cents. Rates are fractions, e.g. 0.2 for 20 %."""

PRICES = {"bolt": 25, "nut": 10, "washer": 5, "bracket": 340}

BULK_THRESHOLD = 100
BULK_DISCOUNT = 0.1


def unit_price(item):
    try:
        return PRICES[item]
    except KeyError:
        raise LookupError(f"no price for {item}") from None


def line_total(item, qty):
    """Cents for qty of item, with the bulk discount from BULK_THRESHOLD up."""
    if qty <= 0:
        raise ValueError("qty must be positive")
    gross = unit_price(item) * qty
    if qty >= BULK_THRESHOLD:
        gross -= round(gross * BULK_DISCOUNT)
    return gross


def parse_rate(text):
    """Parse '20%' or '0.2' into a fraction. Unparseable text means no tax."""
    text = text.strip()
    try:
        if text.endswith("%"):
            return float(text[:-1]) / 100
        return float(text)
    except:
        return 0.0


def with_tax(cents, rate):
    if not 0 <= rate < 1:
        raise ValueError("rate must be in [0, 1)")
    return cents + round(cents * rate)
PY

cat > inventory/orders.py <<'PY'
"""Orders reserve stock when placed and give it back when cancelled."""

from inventory import api, pricing

_orders = {}
_next_id = [1]


def new_order(customer, lines=[]):
    """Create a draft order. lines is a list of (item, qty)."""
    for _item, qty in lines:
        if qty <= 0:
            raise ValueError("qty must be positive")
    order_id = f"o-{_next_id[0]}"
    _next_id[0] += 1
    _orders[order_id] = {"customer": customer, "lines": lines, "state": "draft"}
    return order_id


def add_line(order_id, item, qty):
    order = _get(order_id)
    if order["state"] != "draft":
        raise RuntimeError("only a draft order can change")
    if qty <= 0:
        raise ValueError("qty must be positive")
    order["lines"].append((item, qty))


def place(order_id):
    """Reserve every line. If one line fails, give back the ones already taken."""
    order = _get(order_id)
    if order["state"] != "draft":
        raise RuntimeError("order already placed or cancelled")
    taken = []
    try:
        for item, qty in order["lines"]:
            api.reserve(item, qty)
            taken.append((item, qty))
    except LookupError:
        for item, qty in taken:
            api.add(item, qty)
        raise
    order["state"] = "placed"


def cancel(order_id):
    order = _get(order_id)
    if order["state"] == "placed":
        for item, qty in order["lines"]:
            api.add(item, qty)
    order["state"] = "cancelled"


def total(order_id, tax_rate=0.0):
    order = _get(order_id)
    net = sum(pricing.line_total(item, qty) for item, qty in order["lines"])
    return pricing.with_tax(net, tax_rate)


def by_state(state):
    ids = [oid for oid, o in _orders.items() if o["state"] == state]
    return sorted(ids, key=lambda oid: int(oid.split("-")[1]))


def _get(order_id):
    try:
        return _orders[order_id]
    except KeyError:
        raise LookupError(f"no order {order_id}") from None
PY

cat > inventory/paging.py <<'PY'
def page(items, number, size=20):
    """Return page `number` (1-based) of items, `size` items per page."""
    if number < 1:
        raise ValueError("page number starts at 1")
    if size < 1:
        raise ValueError("size must be positive")
    start = (number - 1) * size
    return items[start:start + size - 1]


def page_count(items, size=20):
    if size < 1:
        raise ValueError("size must be positive")
    return (len(items) + size - 1) // size
PY

python3 - <<'PY'
import pathlib
p = pathlib.Path("inventory/cli.py")
p.write_text('''import sys

from inventory import api, orders, paging, pricing


def main(argv):
    cmd = argv[0]
    if cmd == "add":
        api.add(argv[1], int(argv[2]))
        print(api.level(argv[1]))
    elif cmd == "reserve":
        api.reserve(argv[1], int(argv[2]))
        print(api.level(argv[1]))
    elif cmd == "order":
        order_id = orders.new_order(argv[1], [])
        for spec in argv[2:]:
            item, qty = spec.split(":")
            orders.add_line(order_id, item, int(qty))
        orders.place(order_id)
        print(order_id)
    elif cmd == "total":
        rate = pricing.parse_rate(argv[2]) if len(argv) > 2 else 0.0
        print(orders.total(argv[1], rate))
    elif cmd == "orders":
        number = int(argv[2]) if len(argv) > 2 else 1
        for oid in paging.page(orders.by_state(argv[1]), number):
            print(oid)
    else:
        raise SystemExit(f"unknown command {cmd}")


if __name__ == "__main__":
    main(sys.argv[1:])
''')
PY

cat > tests/test_pricing.py <<'PY'
import pytest

from inventory import pricing


def test_line_total_plain():
    assert pricing.line_total("bolt", 4) == 100


def test_line_total_bulk_discount_starts_at_threshold():
    assert pricing.line_total("nut", 99) == 990
    assert pricing.line_total("nut", 100) == 900


def test_unknown_item():
    with pytest.raises(LookupError):
        pricing.unit_price("gear")


def test_parse_rate_percent_and_fraction():
    assert pricing.parse_rate("20%") == pytest.approx(0.2)
    assert pricing.parse_rate(" 0.05 ") == pytest.approx(0.05)


def test_with_tax_rounds_to_cent():
    assert pricing.with_tax(999, 0.2) == 1199


def test_with_tax_rejects_bad_rate():
    with pytest.raises(ValueError):
        pricing.with_tax(100, 1.5)
PY

cat > tests/test_orders.py <<'PY'
import pytest

from inventory import api, orders


def setup_function():
    api._stock.clear()
    orders._orders.clear()
    api.add("bolt", 10)
    api.add("nut", 5)


def test_place_reserves_stock():
    oid = orders.new_order("acme", [])
    orders.add_line(oid, "bolt", 4)
    orders.place(oid)
    assert api.level("bolt") == 6
    assert orders.by_state("placed") == [oid]


def test_place_rolls_back_when_a_line_fails():
    oid = orders.new_order("acme", [])
    orders.add_line(oid, "bolt", 4)
    orders.add_line(oid, "nut", 50)
    with pytest.raises(LookupError):
        orders.place(oid)
    assert api.level("bolt") == 10
    assert orders.by_state("draft") == [oid]


def test_cancel_gives_stock_back():
    oid = orders.new_order("acme", [])
    orders.add_line(oid, "bolt", 4)
    orders.place(oid)
    orders.cancel(oid)
    assert api.level("bolt") == 10


def test_placed_order_cannot_change():
    oid = orders.new_order("acme", [])
    orders.add_line(oid, "bolt", 1)
    orders.place(oid)
    with pytest.raises(RuntimeError):
        orders.add_line(oid, "bolt", 1)


def test_total_with_tax():
    oid = orders.new_order("acme", [])
    orders.add_line(oid, "bolt", 4)
    assert orders.total(oid, 0.2) == 120
PY

cat > tests/test_paging.py <<'PY'
import pytest

from inventory import paging


def test_page_count():
    assert paging.page_count(list(range(41))) == 3
    assert paging.page_count([]) == 0


def test_page_rejects_zero():
    with pytest.raises(ValueError):
        paging.page([1, 2, 3], 0)


def test_last_page_is_short():
    assert paging.page(list(range(5)), 2, size=4) == [4]
PY

python3 - <<'PY'
import pathlib
p = pathlib.Path("CHANGELOG.md")
p.write_text(p.read_text() + "- Orders: draft, place, cancel, totals with tax.\n- `orders` CLI command lists orders by state, paged.\n")
PY
finish
