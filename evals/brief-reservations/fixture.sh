#!/usr/bin/env bash
# Workspace for the brief case: the base inventory repo and the owner's request, nothing else.
# The request fixes the interface and states four facts. It fixes the data model so that checks can be run against ref/api.py. It leaves six things open on purpose
# (grade.py lists them): a brief that settles one of them without saying so has decided for the owner.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree
rm -rf REVIEW.md CHANGELOG.md tests inventory/cli.py   # the checks are graded against ref/api.py alone
cat > request.md <<'MD'
Clerks need to hold stock for an order and give it back when the order falls through. A hold that
nobody picks up should expire after ten minutes, so stock does not stay locked. Holds have to
survive a restart of the service. The handheld scanners resend `release` when the network is
flaky, so a repeated release must not blow up.

Everything goes in `inventory/api.py`: `reserve(item, qty, order_id, at=None)`, `reserved(order_id)`,
`release(order_id)`, `expire(now)`, `save(path)`, `load(path)`, `reset()`. `at` and `now` are seconds.
An order holds one item: `reserved(order_id)` returns `(item, qty)`. The others return nothing.
`reserve` replaces the two-argument one that is there now; nothing else calls it.
MD
git init -q . && git add -A && git -c user.email=e@x -c user.name=e commit -qm base
