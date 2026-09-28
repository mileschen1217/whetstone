import pytest

from inventory import api, cli


def setup_function():
    api._stock.clear(); api._holds.clear()


def test_release_by_order_id_after_an_expire():
    api.add("bolt", 5)
    api.reserve("bolt", 1, "o1", 0)
    api.reserve("bolt", 1, "o2", 500)
    api.expire(1000)
    api.release("o2")
    assert api.held("bolt") == 0


def test_cli_reserve_takes_an_order_id(capsys):
    api.add("bolt", 5)
    cli.main(["reserve", "bolt", "2", "o9"])
    assert api.held("bolt") == 2
    api.release("o9")
    assert api.held("bolt") == 0
