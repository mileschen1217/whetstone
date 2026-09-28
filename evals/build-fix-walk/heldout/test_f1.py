import inspect

from inventory import api


def setup_function():
    api._stock.clear(); api._holds.clear()


def _reserve(item, qty, order_id, now):
    """SPEC.md fixes the name order_id and the positions of item and qty; the time parameter keeps whatever name the tree gives it."""
    params = [p for p in inspect.signature(api.reserve).parameters if p not in ("item", "qty")]
    return api.reserve(item, qty, **{p: (order_id if p == "order_id" else now) for p in params})


def test_hold_kept_at_899_released_after_900():
    api.add("bolt", 5)
    _reserve("bolt", 2, "o1", 0)
    api.expire(899)
    assert api.held("bolt") == 2
    api.expire(901)
    assert api.held("bolt") == 0
