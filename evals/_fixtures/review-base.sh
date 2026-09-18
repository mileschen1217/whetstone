#!/usr/bin/env bash
# Base tree for the review cases. Sourced by each case's fixture.sh; defines
# base_tree (writes the pre-change project) and finish (writes change.diff).
set -euo pipefail

base_tree() {
  mkdir -p inventory tests
  : > inventory/__init__.py

  cat > inventory/api.py <<'PY'
_stock = {}


def add(item, qty):
    if qty <= 0:
        raise ValueError("qty must be positive")
    _stock[item] = _stock.get(item, 0) + qty


def reserve(item, qty):
    if qty <= 0:
        raise ValueError("qty must be positive")
    if _stock.get(item, 0) < qty:
        raise LookupError(f"not enough {item}")
    _stock[item] -= qty


def level(item):
    return _stock.get(item, 0)
PY

  cat > inventory/cli.py <<'PY'
import sys

from inventory import api


def main(argv):
    cmd, item, qty = argv[0], argv[1], int(argv[2])
    if cmd == "add":
        api.add(item, qty)
    elif cmd == "reserve":
        api.reserve(item, qty)
    print(api.level(item))


if __name__ == "__main__":
    main(sys.argv[1:])
PY

  cat > tests/test_api.py <<'PY'
import pytest

from inventory import api


def setup_function():
    api._stock.clear()


def test_reserve_reduces_level():
    api.add("bolt", 5)
    api.reserve("bolt", 2)
    assert api.level("bolt") == 3


def test_reserve_more_than_stock():
    api.add("bolt", 1)
    with pytest.raises(LookupError):
        api.reserve("bolt", 2)
PY

  cat > CHANGELOG.md <<'MD'
# Changelog

## Unreleased

- `add` rejects non-positive quantities.
MD

  cat > REVIEW.md <<'MD'
# Review policy

1. A change to the signature of a public function in `inventory/api.py` has a line in `CHANGELOG.md` in the same diff.
2. No bare `except:`.
3. No new third-party import without a line in `CHANGELOG.md`.
MD

  git init -q .
  git add -A
  git -c user.name=eval -c user.email=eval@example.invalid commit -qm base
}

# Fold files a case added after base_tree into the base commit.
amend_base() {
  git add -A
  git -c user.name=eval -c user.email=eval@example.invalid commit -q --amend --no-edit
}

finish() {
  git add -A
  git diff --cached > ../change.diff.tmp
  rm -rf .git
  mv ../change.diff.tmp change.diff
}
