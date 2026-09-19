from inventory import api
def test_second_release_does_not_return_stock_twice():
    api.reset(); api.add("nut", 7); api.reserve("nut", 3, "h-1"); api.release("h-1")
    try:
        api.release("h-1")
    except LookupError:
        pass  # the brief is contradictory here; either reading is accepted, double crediting is not
    assert api.level("nut") == 7
