# Results — review

`claude plugin eval`, 3 runs per arm unless noted. A cell is runs passed / runs. reference = `opus`, observed = `sonnet` (measured, not tuned for). 2026-09-19. Failing runs were read, not only scored.

## With and without the skill

| Case | Tag | opus with | opus without | sonnet with | sonnet without |
|---|---|---|---|---|---|
| review-one-root-cause | rule | 3/3 | 1/3 | 3/3 | 1/3 |
| review-smoke-clean | smoke | 3/3 | 3/3 | 3/3 | 3/3 |
| review-smoke-policy | smoke | 3/3 | 3/3 | 3/3 | 3/3 |

- `review-one-root-cause`, opus: bare reports the paging defect as two or more findings in 2/3; with the skill, once in 3/3, and findings drop from 4–5 to 3. sonnet: bare returns one policy finding and misses both correctness defects in 2/3; with the skill all three defects in 3/3.
- Cost of the skill arm on opus: about 5 more turns and 0.05–0.12 USD more per review.

## What each sentence in the lens rests on

| Sentence | Evidence |
|---|---|
| one root cause is one finding | `review-one-root-cause`, table above |
| a finding is wrong behaviour or a broken project rule; style is not; `clean` is correct | the skill itself caused the failure: with the skill but without this sentence, opus reported style findings on `review-smoke-clean` in 5/6 runs (bare: 0/3). With the sentence: 6/6 `clean` |

The second row is a rule that repairs a regression the skill introduces, so its case is green on the bare arm by construction.

## Retired

| Case | Retired on | Why | Restore from |
|---|---|---|---|
| review-existing-data, and its rule (check each new constraint against data already in the repo) | opus | bare red did not reproduce on the current fixture: 13/14 bare against 14/14 with the rule. The earlier 1/3 was on a fixture with two more modules in the base. On sonnet the rule moved the data finding from 0/3 to 2/3 and the consumer finding from 1/3 to 0/3; sonnet is observed only | commit 9caa9c8 |
| review-1 (two small correctness defects) | opus | green bare 3/3 | commit 7f41d9e |
| review-3 (clean refactor) | opus | green bare 3/3; covered by review-smoke-clean | commit 7f41d9e |

Retirement holds for the model named. None of these was retired on sonnet.

## Bare behaviour by model (no skill), for reference

sonnet and haiku narrow the review to the rules in `REVIEW.md`: they return `clean` on a broken change or one policy finding on a change with correctness defects, and they misapply a policy rule to produce a finding. opus does neither. haiku bare: `review-one-root-cause` 0/3.
