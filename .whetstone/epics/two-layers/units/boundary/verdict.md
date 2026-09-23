---
brief: .whetstone/epics/two-layers/units/boundary/brief.md
base: ef1b66e
head: f0f7fe9
result: not pass
---
| AC | Verdict | Check | Output | Note |
|---|---|---|---|---|
| AC-1 | DISPUTED (PASS) | `bash .whetstone/epics/two-layers/units/boundary/checks/ac1.sh` | exit 0:  |  the Interface says test 2 is unchanged apart from the boundary sentence, but AC-3 could not go green on the real page without two more clauses in test 2 (a finding whose fix is already in the range is `logged`; a format, a reply or a protocol between programs fixes no cell by itself, and what a program does when its other end is absent or fails is the fourth cell); the code carries both clauses, the first of which decides on the builder's word that a fix is in the range until U3's reader replaces it. |
| AC-2 | PASS | `bash .whetstone/epics/two-layers/units/boundary/checks/ac2.sh` | exit 0:  |  |
| AC-3 | DISPUTED (FAIL) | `bash .whetstone/epics/two-layers/units/boundary/checks/ac3.sh` | exit 1: evidence/AC-3.log at 11aa573 | from recorded evidence, not run here;  the check reads the builder's label at the end of each decision line ("a stored format", from decisions.md), and two labelled rows above the line in both runs are behaviours when a thing is absent or already there (`score` prints null when the key has no incident for the snapshot; `run` removes an earlier run's files in `--out` before it starts), which `line.md` names as an owner's cell; the page follows line.md, the check follows the label. The count half of AC-3 (4 or fewer) is 5 in run 1 and 4 in run 2 and is not disputed. |
| AC-4 | PASS | `bash .whetstone/epics/two-layers/units/boundary/checks/ac4.sh` | exit 0: evidence/AC-4.log at 11aa573 | from recorded evidence, not run here |
| AC-5 | PASS | `bash .whetstone/epics/two-layers/units/boundary/checks/ac5.sh` | exit 0: evidence/AC-5.log at 11aa573 | from recorded evidence, not run here |
| AC-6 | PASS | `bash .whetstone/epics/two-layers/units/boundary/checks/ac6.sh` | exit 0: evidence/AC-6.log at 11aa573 | from recorded evidence, not run here |
| AC-7 | PASS | `bash .whetstone/epics/two-layers/units/boundary/checks/ac7.sh` | exit 0:  |  |
| AC-8 | PASS | `bash .whetstone/epics/two-layers/units/boundary/checks/ac8.sh` | exit 0:  |  |
