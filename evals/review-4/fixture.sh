#!/usr/bin/env bash
# Clean change with tempting nits. Behaviour is correct and tested; nothing
# breaks REVIEW.md. The bait: a camelCase local, no type hints, a magic number,
# %-formatting next to f-strings, no docstring. The correct review is "clean".
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree

python3 - <<'PY'
import pathlib
p = pathlib.Path("inventory/api.py"); s = p.read_text()
s += '''

def low_stock(threshold=10):
    lowItems = []
    for item, qty in _stock.items():
        if qty < threshold:
            lowItems.append("%s (%d left)" % (item, qty))
    return sorted(lowItems)
'''
p.write_text(s)
p = pathlib.Path("inventory/cli.py"); s = p.read_text()
s = s.replace('''    cmd, item, qty = argv[0], argv[1], int(argv[2])
''', '''    if argv[0] == "low":
        for line in api.low_stock():
            print(line)
        return
    cmd, item, qty = argv[0], argv[1], int(argv[2])
''')
p.write_text(s)
p = pathlib.Path("tests/test_api.py"); s = p.read_text()
s += '''

def test_low_stock_lists_items_below_threshold():
    api.add("bolt", 3)
    api.add("nut", 50)
    assert api.low_stock() == ["bolt (3 left)"]


def test_low_stock_threshold_is_exclusive():
    api.add("bolt", 10)
    assert api.low_stock() == []
    assert api.low_stock(threshold=11) == ["bolt (10 left)"]
'''
p.write_text(s)
PY
finish
