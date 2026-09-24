---
type: regex
target: { source: file, path: out/pr.md }
pattern: '^### [^\n]*AC-?5(?:[^\n]|\n(?=[ \t]*-|\n[ \t]*-))*?(?:UNVERIFIED|unverified|not (?:been )?(?:run|verified))'
flags: m
---
