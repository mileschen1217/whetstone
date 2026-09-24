#!/usr/bin/env bash
# AC-3: the owner's reading of pr-written-back-3.md's verdict rows: one yes|no line per row, understood: k of n with k = n.
[ -f evals-private/repos.env ] && . evals-private/repos.env; m="${TWO_LAYERS_MATERIAL:-}"; o="$m/owner-written-back.md"; p="$m/layered/pr-written-back-3.md"
[ -n "$m" ] && [ -f "$o" ] && [ -f "$p" ] || { echo "no owner-written-back.md or page"; exit 1; }
n="$(grep -cE '^### AC-[0-9]+ ' "$p")"; lines="$(grep -cE '^AC-[0-9]+: (yes|no) — .{3,}' "$o")"
grep -qE '^AC-[0-9]+: no — ' "$o" && { echo "a row answered no"; exit 1; }
for a in $(grep -oE '^### AC-[0-9]+ ' "$p" | awk '{print $2}'); do [ "$(grep -cE "^$a: yes — ..." "$o")" -eq 1 ] || { echo "$a: not exactly one yes line"; exit 1; }; done
[ "$lines" -eq "$n" ] || { echo "$lines answer lines for $n verdict rows"; exit 1; }
u="$(grep -oE '^understood: [0-9]+ of [0-9]+' "$o" | head -1)"; [ -n "$u" ] || { echo "no understood: k of n line"; exit 1; }
k="$(echo "$u" | awk '{print $2}')"; t="$(echo "$u" | awk '{print $4}')"
[ "$t" -eq "$n" ] && [ "$k" -eq "$n" ] || { echo "understood $k of $t, need $n of $n"; exit 1; }
