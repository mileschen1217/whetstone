#!/usr/bin/env bash
# AC-6: ADR 0012 exists with its three parts, is listed in the README, and the directory holds ≤ 10 pages.
f="$(ls docs/adr/0012-*.md 2>/dev/null | head -1)"; [ -n "$f" ] || { echo "no docs/adr/0012-*.md"; exit 1; }
for p in "**Context.**" "**Decision.**" "**Overturned by.**"; do grep -qF -- "$p" "$f" || { echo "$f lacks $p"; exit 1; }; done
grep -qi 'table' "$f" && grep -qiE 'three (real )?readings|three times' "$f" && grep -qiE 'first (block )?reading|read (it )?once|about half' "$f" || { echo "Context does not name the table, the three readings and the first block reading"; exit 1; }
grep -q '0012' docs/adr/README.md || { echo "README does not list 0012"; exit 1; }
n="$(ls docs/adr/[0-9]*.md | wc -l | tr -d ' ')"; [ "$n" -le 10 ] || { echo "$n ADR pages, limit 10"; exit 1; }
