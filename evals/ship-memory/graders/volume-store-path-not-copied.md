---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*memory(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?INVENTORY_STORE'
flags: mi
match: not_contains
---
