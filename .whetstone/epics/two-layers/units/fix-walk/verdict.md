---
brief: .whetstone/epics/two-layers/units/fix-walk/brief.md
base: 26ba5a8
head: c353a8b
result: not pass
---
| AC | Verdict | Check | Output | Note |
|---|---|---|---|---|
| AC-1 | DISPUTED (PASS) | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac1.sh` | exit 0: After review.md: 2 lines, walk sentence present |  the brief's B-2 and For the builder place the walk sentence after "commit the fixes", while a walk after the commit leaves its own edits uncommitted (review finding 1); the code puts the sentence before the commit, verbatim, which AC-1 admits either way. |
| AC-2 | PASS | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac2.sh` | exit 0:  |  |
| AC-3 | PASS | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac3.sh` | exit 0:  |  |
| AC-4 | PASS | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac4.sh` | exit 0: skill arm: 6 of 6 | from evidence/AC-4.log at fea7bca, not run here |
| AC-5 | PASS | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac5.sh` | exit 0: build trials 2 of 2 graded; build-burndown 3 runs | from evidence/AC-5.log at fea7bca, not run here |
| AC-6 | PASS | `bash .whetstone/epics/two-layers/units/fix-walk/checks/ac6.sh` | exit 0:  |  |
