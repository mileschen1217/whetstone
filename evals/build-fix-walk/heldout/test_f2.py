import inspect

from inventory import api, report


def setup_function():
    api._stock.clear(); api._holds.clear()


def _reserve(item, qty, order_id, now):
    """SPEC.md fixes the name order_id and the positions of item and qty; the time parameter keeps whatever name the tree gives it."""
    params = [p for p in inspect.signature(api.reserve).parameters if p not in ("item", "qty")]
    return api.reserve(item, qty, **{p: (order_id if p == "order_id" else now) for p in params})


def test_level_is_on_hand_minus_held():
    api.add("bolt", 5)
    _reserve("bolt", 4, "o1", 0)
    assert api.level("bolt") == 1


def test_low_stock_sees_held_stock():
    api.add("bolt", 5)
    api.add("nut", 5)
    _reserve("bolt", 4, "o1", 0)
    assert report.low_stock(3) == ["bolt"]
