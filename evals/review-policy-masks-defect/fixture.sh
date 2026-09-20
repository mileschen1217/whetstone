#!/usr/bin/env bash
# The review-silent-failure change with its changelog line left out: one broken REVIEW.md rule
# and one silent behaviour defect in the same diff. Bare, the broken rule ends the search.
set -euo pipefail
export NO_CHANGELOG=1
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../review-silent-failure/fixture.sh"
