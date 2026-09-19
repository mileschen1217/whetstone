#!/usr/bin/env bash
# Base tree only: export, importer, store, seed data. The builder session makes the change.
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
rm -rf .git
