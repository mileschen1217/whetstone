---
brief: .whetstone/epics/two-layers/units/written-back/brief.md
base: 0dbc71c
head: ea68231
result: not pass
---
| AC | Verdict | Check | Output | Note |
|---|---|---|---|---|
| AC-1 | PASS | `bash .whetstone/epics/two-layers/units/written-back/checks/ac1.sh` | exit 0:  | green before the change |
| AC-2 | PASS | `bash .whetstone/epics/two-layers/units/written-back/checks/ac2.sh` | exit 0: 4 verdict blocks checked | from evidence/AC-2.log at ae60d00, not run here |
| AC-3 | FAIL | `B-3, B-4` | exit 127: bash: B-3,: command not found |  |
| AC-4 | PASS | `bash .whetstone/epics/two-layers/units/written-back/checks/ac4.sh` | exit 0: 18 of 18 runs, every grader, outcome-text-leads-with-decision among them | from evidence/AC-4.log at ae60d00, not run here |
| AC-5 | PASS | `bash .whetstone/epics/two-layers/units/written-back/checks/ac5.sh` | exit 0:  | green before the change |
| AC-6 | PASS | `bash .whetstone/epics/two-layers/units/written-back/checks/ac6.sh` | exit 0:  | green before the change |
| AC-7 | PASS | `bash .whetstone/epics/two-layers/units/written-back/checks/ac7.sh` | exit 0: ok   VERIFY_LIVE=1 runs the live check here (and it fails: no target) | green before the change |
