#!/usr/bin/env bash
# One planted policy violation (REVIEW.md rule 1): reserve() gains a parameter,
# callers and tests are updated correctly, CHANGELOG.md is not.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree

python3 - <<'PY'
import re, pathlib
p = pathlib.Path("inventory/api.py"); s = p.read_text()
s = s.replace("_stock = {}\n", "_stock = {}\n_reserved = {}\n")
s = s.replace('def reserve(item, qty):', 'def reserve(item, qty, order_id):')
s = s.replace("    _stock[item] -= qty\n", "    _stock[item] -= qty\n    _reserved[order_id] = (item, qty)\n")
p.write_text(s)
p = pathlib.Path("inventory/cli.py"); s = p.read_text()
s = s.replace("        api.reserve(item, qty)", "        api.reserve(item, qty, order_id=argv[3])")
p.write_text(s)
p = pathlib.Path("tests/test_api.py"); s = p.read_text()
s = s.replace("    api._stock.clear()\n", "    api._stock.clear()\n    api._reserved.clear()\n")
s = s.replace('api.reserve("bolt", 2)', 'api.reserve("bolt", 2, "o-1")')
s += '''

def test_reserve_records_order():
    api.add("bolt", 5)
    api.reserve("bolt", 2, "o-7")
    assert api._reserved["o-7"] == ("bolt", 2)
'''
p.write_text(s)
PY
finish
