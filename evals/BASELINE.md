# Baseline — review cases, no skill

Bare arm only (no skill exists yet), 3 runs per case. A cell is runs passed / runs. Every failing run's `review.md` was read; the failures below are behaviour, not grader artefacts.

| Case | Tag | opus | sonnet | haiku |
|---|---|---|---|---|
| review-existing-data | rule | 1/3 | 1/3 | 0/3 |
| review-one-root-cause | rule | 1/3 | 1/3 | 0/3 |
| review-smoke-policy | smoke | 3/3 | 3/3 | 3/3 |
| review-smoke-clean | smoke | 3/3 | 1/3 | 0/3 |

opus: 2026-09-18, before the fixtures were trimmed to budget. sonnet, haiku: 2026-09-19, current fixtures, except that `review-smoke-clean` has since gained a CHANGELOG line (see below) and was not re-run.

## What fails, by model

opus
- `review-existing-data`: the consumer that was not updated is caught 3/3; existing data rejected by the new required field is caught 1/3.
- `review-one-root-cause`: every planted defect caught 3/3; the paging defect is reported as 2–3 findings in 3/3 (the bug, its blind test, its CLI caller).

sonnet, haiku — a different failure, not seen on opus
- Review scope collapses to the policy file. With three rules in `REVIEW.md`, the reviewer reports policy violations and nothing else: `review-one-root-cause` returns one finding (the bare `except`) and misses the paging and mutable-default defects in sonnet 2/3, haiku 3/3; `review-existing-data` returns `clean` on a broken change in sonnet 2/3.
- Policy rules are misapplied to make a finding: a new function is reported under the rule about changed signatures (`review-smoke-clean`: sonnet 2/3, haiku 3/3); an existing `pytest` import is reported as a new third-party import (haiku).

`review-smoke-clean` was ambiguous on that last point: the change added a public function with no CHANGELOG line, and rule 1 speaks only of changed signatures. The fixture now adds the CHANGELOG line, so a changelog finding on it is unambiguous noise.

## Retired

| Case | Retired on | Why | Restore from |
|---|---|---|---|
| review-1 (two small correctness defects) | opus, 2026-09-18 | green bare 3/3 | commit 7f41d9e |
| review-3 (clean refactor) | opus, 2026-09-18 | green bare 3/3; covered by review-smoke-clean | commit 7f41d9e |

Both were retired on opus alone. They were not run on sonnet or haiku.
