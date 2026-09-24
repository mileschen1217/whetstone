---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*memory(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?(?:long-running|background|next CLI run)'
flags: mi
---
