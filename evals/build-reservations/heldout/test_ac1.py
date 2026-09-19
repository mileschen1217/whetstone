import subprocess, sys
from inventory import api
def test_reserve_and_lookup():
    api.reset(); api.add("nut", 7); api.reserve("nut", 3, "h-1", at=10)
    assert api.level("nut") == 4 and tuple(api.reserved("h-1")) == ("nut", 3)
def test_two_orders_same_item():
    api.reset(); api.add("nut", 7); api.reserve("nut", 3, "h-1"); api.reserve("nut", 2, "h-2")
    assert api.level("nut") == 2 and tuple(api.reserved("h-2")) == ("nut", 2)
def test_cli_form_runs():
    r = subprocess.run([sys.executable, "-m", "inventory.cli", "reserve", "nut", "1", "h-9"], capture_output=True, text=True)
    assert "Traceback" not in r.stderr or "not enough" in r.stderr  # a fresh process has no stock; it must get as far as the stock check
