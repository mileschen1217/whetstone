---
type: regex
target: { source: file, path: out/brief-review.md }
pattern: '(?=[\s\S]*B-?5[^\n]*(no (red|check|criterion|AC)|nothing[^\n]*red|not (tested|checked|covered|exercised)|never|empty|reset|merg))(?=[\s\S]*AC-?7[^\n]*(scheduler|live|proxy|deploy|outside|itself|directly|calls? `?expire))'
flags: i
---
