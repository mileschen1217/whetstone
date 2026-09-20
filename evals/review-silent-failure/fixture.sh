#!/usr/bin/env bash
# No defect that anything in the repo contradicts. Three inputs a reviewer can only construct:
# a repeated order_id (stock drops again, the earlier reservation is overwritten, no error),
# an unknown order_id in release() (KeyError), and the CLI called without an id (IndexError).
# NO_CHANGELOG=1 leaves the changelog line out, so REVIEW.md rule 1 is broken as well.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree

python3 - <<'PY'
import os, pathlib
p = pathlib.Path("inventory/api.py"); s = p.read_text()
s = s.replace("_stock = {}\n", "_stock = {}\n_reserved = {}\n")
s = s.replace("def reserve(item, qty):", "def reserve(item, qty, order_id):")
s = s.replace("    _stock[item] -= qty\n", "    _stock[item] -= qty\n    _reserved[order_id] = (item, qty)\n")
s += '''

def release(order_id):
    item, qty = _reserved.pop(order_id)
    _stock[item] = _stock.get(item, 0) + qty
'''
p.write_text(s)
p = pathlib.Path("inventory/cli.py"); s = p.read_text()
s = s.replace("        api.reserve(item, qty)", "        api.reserve(item, qty, order_id=argv[3])")
p.write_text(s)
p = pathlib.Path("tests/test_api.py"); s = p.read_text()
s = s.replace("    api._stock.clear()\n", "    api._stock.clear()\n    api._reserved.clear()\n")
s = s.replace('api.reserve("bolt", 2)', 'api.reserve("bolt", 2, "o-1")')
s += '''

def test_release_returns_stock():
    api.add("bolt", 5)
    api.reserve("bolt", 2, "o-7")
    api.release("o-7")
    assert api.level("bolt") == 5
'''
p.write_text(s)
p = pathlib.Path("CHANGELOG.md")
if not os.environ.get("NO_CHANGELOG"):
    p.write_text(p.read_text() + "- `reserve` takes a required `order_id`; `release(order_id)` returns a reservation to stock.\n")
PY
finish
