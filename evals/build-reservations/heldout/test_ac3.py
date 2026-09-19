import pytest
from inventory import api
def test_release_returns_stock():
    api.reset(); api.add("nut", 7); api.reserve("nut", 3, "h-1"); api.release("h-1")
    assert api.level("nut") == 7
def test_never_reserved_raises():
    api.reset()
    with pytest.raises(LookupError):
        api.release("h-404")
