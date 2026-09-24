---
brief: .whetstone/epics/two-layers/units/read-before-signing/brief.md
base: 8796fc8
head: 815adcc
result: not pass
---
| AC | Verdict | Check | Output | Note |
|---|---|---|---|---|
| AC-1 | PASS | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac1.sh` | exit 0: evidence/AC-1.log at 7df5735 | from recorded evidence, not run here |
| AC-2 | PASS | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac2.sh` | exit 0:  |  |
| AC-3 | PASS | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac3.sh` | exit 0:  |  |
| AC-4 | PASS | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac4.sh` | exit 0:  |  |
| AC-5 | PASS | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac5.sh` | exit 0:  |  |
| AC-6 | PASS | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac6.sh` | exit 0: evidence/AC-6.log at 7df5735 | from recorded evidence, not run here |
| AC-7 | DISPUTED (PASS) | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac7.sh` | exit 0: evidence/AC-7.log at 7df5735 | from recorded evidence, not run here;  the brief fixes `tags: [brief, rule]` and `checks/ac7.sh` greps for `rule` and for both graders, while `evals/README.md` (the `rule` tag line and the grader line under it) says a `rule` case enters only when it is red on the bare arm, that a case with no Δ leaves and takes its rule with it, and that a grader passing on every run of every arm is deleted; the case, replanted with the two kinds of hole only the brief lens names, ran both arms after the review: with 11/12, without 10/12 (Δ 0.08, twelve runs each), which triggers the first two against what the unit keeps: the tag and the rule the case serves, which AC-2 entered as `reader entered: yes` on the six private reads (epic D-8: REQ-8 enters on measurement, not on a harness Δ); the code keeps the tag as the brief fixes it and records both arms in `evals/BASELINE.md`; the step's own Δ is measurable only at the brief level and is not yet run. |
| AC-8 | PASS | `bash .whetstone/epics/two-layers/units/read-before-signing/checks/ac8.sh` | exit 0:  |  |
