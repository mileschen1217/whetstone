---
brief: .whetstone/epics/two-layers/units/burn-down/brief.md
base: 45e687d
head: 63781cf
result: not pass
---
| AC | Verdict | Check | Output | Note |
|---|---|---|---|---|
| AC-1 | PASS | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac1.sh` | exit 0: readers correct: 6 of 6 | from evidence/AC-1.log at 1d7799a, not run here |
| AC-2 | DISPUTED (PASS) | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac2.sh` | exit 0:  |  `reader text Δ` as the check counts it is +6 (the bare arm never writes the `- finding 1 (…) — closed —` and `- new: path:line` lines), while every bare output read by hand judges the finding closed and names the planted line, so the Δ measures the output form and not the candidate list or the two questions that B-5 keeps on Δ > 0; the code follows the brief and enters the whole text. |
| AC-3 | PASS | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac3.sh` | exit 0:  |  |
| AC-4 | PASS | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac4.sh` | exit 0:  |  |
| AC-5 | PASS | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac5.sh` | exit 0: ship 18 of 18 runs every grader; review 15 of 15; build trials on the final text held-out 13/13 and 13/13, no false green, no edited check | from evidence/AC-5.log at 1d7799a, not run here |
| AC-6 | PASS | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac6.sh` | exit 0:  |  |
| AC-7 | PASS | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac7.sh` | exit 0: 3 runs | from evidence/AC-7.log at 1d7799a, not run here |
| AC-8 | PASS | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac8.sh` | exit 0:  |  |
