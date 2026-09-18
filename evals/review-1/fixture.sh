#!/usr/bin/env bash
# Two planted correctness defects: empty artifacts now read as ok; unverified()
# reads only the last round, so earlier survivors vanish (false clean).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree

cat > inventory/artifacts.py <<'PY'
from pathlib import Path


def status_of(path):
    """Return 'ok', 'empty' or 'missing' for an artifact path."""
    if Path(path).is_file():
        return "ok"
    return "missing"
PY

cat > inventory/report.py <<'PY'
def unverified(rounds):
    """Ids of findings still unverified.

    A finding's state is its latest state across all rounds, so a finding
    raised in round 1 and not mentioned again is still unverified.
    """
    if not rounds:
        return []
    return sorted(f["id"] for f in rounds[-1]["findings"] if f["state"] == "unverified")
PY
finish
