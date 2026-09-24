#!/usr/bin/env bash
# AC-7: the public case brief-read is retired: absent from the tree, listed in BASELINE's Retired table with model and restore commit.
[ ! -e evals/brief-read ] || { echo "evals/brief-read still exists"; exit 1; }
row="$(awk '/^## Retired/{on=1;next} /^## /{on=0} on' evals/BASELINE.md | grep -E '^\| *`?brief-read')"; [ -n "$row" ] || { echo "BASELINE Retired table has no brief-read row"; exit 1; }
printf '%s' "$row" | grep -qE 'opus|sonnet' || { echo "brief-read row names no model"; exit 1; }
printf '%s' "$row" | grep -qE 'commit [0-9a-f]{7}' || { echo "brief-read row names no restore commit"; exit 1; }
