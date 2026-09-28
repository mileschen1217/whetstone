from inventory import api, report


def setup_function():
    api._stock.clear(); api._holds.clear()


def _reserve(item, qty, order_id, now):
    try:
        return api.reserve(item, qty, order_id, now)
    except TypeError:
        return api.reserve(item, qty, now)


def test_level_is_on_hand_minus_held():
    api.add("bolt", 5)
    _reserve("bolt", 4, "o1", 0)
    assert api.level("bolt") == 1


def test_low_stock_sees_held_stock():
    api.add("bolt", 5)
    api.add("nut", 5)
    _reserve("bolt", 4, "o1", 0)
    assert report.low_stock(3) == ["bolt"]
