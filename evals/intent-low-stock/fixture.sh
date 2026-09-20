#!/usr/bin/env bash
# Workspace for the intent case: the base inventory repo and the owner's first message.
# The message holds one false belief about the repo (there is no `report` command) and says nothing
# of the facts in owner.md. The agent under test never sees owner.md; the driver keeps it outside.
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../_fixtures/review-base.sh"
base_tree
rm -rf REVIEW.md CHANGELOG.md
cat > request.md <<'MD'
The warehouse keeps running out of things without anyone noticing. When stock of an item gets low I
want the purchasing system told about it; they have a webhook for that. Show the low items in the
CLI's `report` command too, since the clerks already use it every morning.
MD
git init -q . && git add -A && git -c user.email=e@x -c user.name=e commit -qm base
