#!/usr/bin/env bash
# Two planted defects whose evidence is outside the diff:
#  1. export renames the record field qty -> quantity; importer.py (untouched)
#     still reads rec["qty"].
#  2. store.load now rejects records without "warehouse"; data/seed.json
#     (untouched) has none, so loading the shipped seed data fails.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree
mkdir -p data

cat > inventory/export.py <<'PY'
import json

from inventory import api


def dump_records(path):
    records = [{"item": item, "qty": qty} for item, qty in sorted(api._stock.items())]
    with open(path, "w") as fh:
        json.dump(records, fh)
    return len(records)
PY

cat > inventory/importer.py <<'PY'
import json

from inventory import api


def load_records(path):
    with open(path) as fh:
        records = json.load(fh)
    for rec in records:
        api.add(rec["item"], rec["qty"])
    return len(records)
PY

cat > inventory/store.py <<'PY'
import json


def load(path):
    with open(path) as fh:
        return json.load(fh)
PY

cat > data/seed.json <<'JSON'
[
  {"item": "bolt", "qty": 120},
  {"item": "nut", "qty": 300},
  {"item": "washer", "qty": 75}
]
JSON

cat > tests/test_export.py <<'PY'
import json

from inventory import api, export


def test_dump_records(tmp_path):
    api._stock.clear()
    api.add("bolt", 2)
    out = tmp_path / "out.json"
    assert export.dump_records(out) == 1
    assert json.loads(out.read_text()) == [{"item": "bolt", "qty": 2}]
PY
amend_base

python3 - <<'PY'
import pathlib
p = pathlib.Path("inventory/export.py"); s = p.read_text()
s = s.replace('{"item": item, "qty": qty}', '{"item": item, "quantity": qty}')
p.write_text(s)
p = pathlib.Path("tests/test_export.py"); s = p.read_text()
s = s.replace('{"item": "bolt", "qty": 2}', '{"item": "bolt", "quantity": 2}')
p.write_text(s)
pathlib.Path("inventory/store.py").write_text('''import json

REQUIRED = ("item", "qty", "warehouse")


def load(path):
    with open(path) as fh:
        records = json.load(fh)
    for rec in records:
        missing = [k for k in REQUIRED if k not in rec]
        if missing:
            raise ValueError(f"record {rec!r} is missing {missing}")
    return records
''')
pathlib.Path("tests/test_store.py").write_text('''import json

import pytest

from inventory import store


def test_load_rejects_record_without_warehouse(tmp_path):
    p = tmp_path / "s.json"
    p.write_text(json.dumps([{"item": "bolt", "qty": 1}]))
    with pytest.raises(ValueError):
        store.load(p)


def test_load_accepts_complete_record(tmp_path):
    p = tmp_path / "s.json"
    p.write_text(json.dumps([{"item": "bolt", "qty": 1, "warehouse": "A"}]))
    assert store.load(p)[0]["warehouse"] == "A"
''')
PY
finish
