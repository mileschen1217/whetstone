from inventory import api


def setup_function():
    api._stock.clear(); api._holds.clear()


def _reserve(item, qty, order_id, now):
    try:
        return api.reserve(item, qty, order_id=order_id, now=now)
    except TypeError:
        return api.reserve(item, qty, now)


def test_hold_kept_at_899_released_after_900():
    api.add("bolt", 5)
    _reserve("bolt", 2, "o1", 0)
    api.expire(899)
    assert api.held("bolt") == 2
    api.expire(901)
    assert api.held("bolt") == 0
