# Baseline — review cases, no skill

Model `opus`, 3 runs per case, bare arm only (no skill exists yet). 2026-09-18. Re-run before trusting these after a model change.

| Case | What it plants | Result | Reading |
|---|---|---|---|
| review-1 | 2 correctness defects, 17-line diff | 3/3 pass | no Δ available |
| review-2 | 1 policy violation | 3/3 pass | no Δ available |
| review-3 | nothing; clean refactor | 3/3 `clean` | no Δ available |
| review-4 | nothing; clean change with style bait | 3/3 `clean` | no Δ available |
| review-5 | 2 defects whose evidence is outside the diff | consumer not updated: 3/3 caught; existing data rejected by new rule: 1/3 caught | **red** — outcome |
| review-6 | 4 defects in a 375-line diff | 4/4 caught in 3/3; findings 9, 6, 6 against a cap of 6 | **red** — volume: one root cause reported as 2–3 findings in 3/3 runs |

Note on review-6: the first version of the fixture carried unplanned true defects; those were removed and the numbers above are from the cleaned fixture. The paging defect was reported separately as the bug, its blind test, and (once) its CLI caller. One unplanned defect (an order registered before its lines were validated) was caught 3/3 and has since been fixed in the fixture without a re-run.

What the baseline does not show: invented findings, findings without a file and line, or reluctance to answer `clean`.
