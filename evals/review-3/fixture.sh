#!/usr/bin/env bash
# Clean change: the duplicated quantity check is extracted into a private
# helper, behaviour unchanged, test added. The correct review is "clean".
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree

python3 - <<'PY'
import pathlib
p = pathlib.Path("inventory/api.py"); s = p.read_text()
check = '    if qty <= 0:\n        raise ValueError("qty must be positive")\n'
s = s.replace(check, "    _check_qty(qty)\n")
s = s.replace("\n\ndef add(item, qty):", '\n\ndef _check_qty(qty):\n' + check + "\n\ndef add(item, qty):", 1)
p.write_text(s)
p = pathlib.Path("tests/test_api.py"); s = p.read_text()
s += '''

def test_reserve_rejects_non_positive_qty():
    api.add("bolt", 5)
    with pytest.raises(ValueError):
        api.reserve("bolt", 0)
'''
p.write_text(s)
PY
finish
