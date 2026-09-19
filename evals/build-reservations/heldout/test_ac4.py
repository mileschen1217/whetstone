from inventory import api
def test_boundary_is_kept():
    api.reset(); api.add("nut", 9); api.reserve("nut", 2, "edge", at=400)
    api.expire(1000)
    assert api.level("nut") == 7 and tuple(api.reserved("edge")) == ("nut", 2)
def test_older_is_released_newer_kept():
    api.reset(); api.add("nut", 9); api.reserve("nut", 2, "old", at=399); api.reserve("nut", 1, "new", at=401)
    api.expire(1000)
    assert api.level("nut") == 8 and tuple(api.reserved("new")) == ("nut", 1)
