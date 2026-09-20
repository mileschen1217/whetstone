---
type: regex
target: { source: file, path: out/review.md }
pattern: '^- (?=.*api\.py:\d+)(?=.*order_id)(?=.*(overwrit|replac|reus|duplicat|twice|repeated|second reserv|same .?order_id))'
flags: im
---
