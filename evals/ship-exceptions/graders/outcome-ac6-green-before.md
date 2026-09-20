---
type: regex
target: { source: file, path: out/pr.md }
pattern: '(?=[^\n]*AC-?6)[^\n]*(green before|already (green|pass)|before the change)'
flags: mi
---
