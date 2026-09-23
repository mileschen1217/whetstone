#!/usr/bin/env bash
# AC-2: line.md sends cross-unit constraints to REVIEW.md or a memory page, walked by the reviewer, not to the owner.
f=skills/line.md
grep -qF -- "what must hold across units inside the boundary is a rule in the project's REVIEW.md or a constraint on a memory page, walked by the reviewer; it is not a row for the owner" "$f" \
  || { echo "line.md lacks the REVIEW.md sentence"; exit 1; }
