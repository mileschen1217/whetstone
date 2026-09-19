import os
from inventory import api
def test_round_trip(tmp_path):
    api.reset(); api.add("nut", 7); api.reserve("nut", 3, "h-1", at=5)
    p = tmp_path / "state"; api.save(p); api.reset(); api.load(p)
    assert api.level("nut") == 4 and tuple(api.reserved("h-1")) == ("nut", 3)
def test_missing_file_changes_nothing(tmp_path):
    api.reset(); api.add("nut", 7); api.reserve("nut", 3, "h-1")
    try:
        api.load(tmp_path / "nope")
    except (FileNotFoundError, LookupError, ValueError):
        pass
    assert api.level("nut") == 4 and tuple(api.reserved("h-1")) == ("nut", 3)
    assert os.listdir(tmp_path) == []
def test_expiry_survives_round_trip(tmp_path):
    api.reset(); api.add("nut", 7); api.reserve("nut", 3, "h-1", at=0)
    p = tmp_path / "state"; api.save(p); api.reset(); api.load(p); api.expire(1000)
    assert api.level("nut") == 7
