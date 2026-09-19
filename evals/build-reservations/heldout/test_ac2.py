import pytest
from inventory import api
def test_duplicate_changes_nothing():
    api.reset(); api.add("nut", 7); api.reserve("nut", 3, "h-1")
    with pytest.raises(ValueError):
        api.reserve("nut", 2, "h-1")
    assert api.level("nut") == 4 and tuple(api.reserved("h-1")) == ("nut", 3)
def test_duplicate_other_item_changes_nothing():
    api.reset(); api.add("nut", 7); api.add("bolt", 5); api.reserve("nut", 3, "h-1")
    with pytest.raises(ValueError):
        api.reserve("bolt", 1, "h-1")
    assert api.level("bolt") == 5 and tuple(api.reserved("h-1")) == ("nut", 3)
