import inspect

import pytest

from inventory import api, cli


def setup_function():
    api._stock.clear(); api._holds.clear()


def _reserve(item, qty, order_id, now):
    """SPEC.md fixes the name order_id and the positions of item and qty; the time parameter keeps whatever name the tree gives it."""
    params = [p for p in inspect.signature(api.reserve).parameters if p not in ("item", "qty")]
    return api.reserve(item, qty, **{p: (order_id if p == "order_id" else now) for p in params})


def test_release_by_order_id_after_an_expire():
    api.add("bolt", 5)
    _reserve("bolt", 1, "o1", 0)
    _reserve("bolt", 1, "o2", 500)
    api.expire(1000)
    api.release("o2")
    assert api.held("bolt") == 0


def test_cli_reserve_takes_an_order_id(capsys):
    api.add("bolt", 5)
    cli.main(["reserve", "bolt", "2", "o9"])
    assert api.held("bolt") == 2
    api.release("o9")
    assert api.held("bolt") == 0
