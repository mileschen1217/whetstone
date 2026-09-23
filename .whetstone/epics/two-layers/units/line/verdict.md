---
brief: .whetstone/epics/two-layers/units/line/brief.md
base: 19d08d0
head: 82edddb
result: not pass
---
| AC | Verdict | Check | Output | Note |
|---|---|---|---|---|
| AC-1 | PASS | `bash .whetstone/epics/two-layers/units/line/checks/ac1.sh` | exit 0:  |  |
| AC-2 | PASS | `bash .whetstone/epics/two-layers/units/line/checks/ac2.sh` | exit 0:  |  |
| AC-3 | PASS | `bash .whetstone/epics/two-layers/units/line/checks/ac3.sh` | exit 0:  |  |
| AC-4 | PASS | `bash .whetstone/epics/two-layers/units/line/checks/ac4.sh` | exit 0: evidence/AC-4.log at 152c721 | from recorded evidence, not run here |
| AC-5 | PASS | `bash .whetstone/epics/two-layers/units/line/checks/ac5.sh` | exit 0: evidence/AC-5.log at 152c721 | from recorded evidence, not run here |
| AC-6 | DISPUTED (FAIL) | `bash .whetstone/epics/two-layers/units/line/checks/ac6.sh` | exit 1: evidence/AC-6.log at 152c721 | from recorded evidence, not run here;  the Interface puts two headings and a second table header on every ship page (6 to 8 lines more than one table), and the signed unit 1 pr.md has no line to spare, so the layered pr.md written by `ship` is 38 lines against 36 (with 6 fewer rows: the memory statements already existed in the copy it ran on); the page follows the Interface. The prose half of AC-6 holds (0 prose lines, as before). |
| AC-7 | PASS | `bash .whetstone/epics/two-layers/units/line/checks/ac7.sh` | exit 0: evidence/AC-7.log at 8aeff75 | from recorded evidence, not run here |
| AC-8 | PASS | `bash .whetstone/epics/two-layers/units/line/checks/ac8.sh` | exit 0:  |  |
| AC-9 | PASS | `bash .whetstone/epics/two-layers/units/line/checks/ac9.sh` | exit 0: evidence/AC-9.log at 152c721 | from recorded evidence, not run here |
