# 0003 — What counts as a finding

2026-09-19, extended 2026-09-20. Accepted.

**Context.** A dispatched reviewer saw that the repo's own data file failed a new validation and dropped it: "no in-repo callers, so nothing breaks today". On a green-field repo nothing has a caller, so reachability cannot be the test. Separately the owner's rule for failures: failing is acceptable, failing silently is not; what matters is what it costs later to recover, and how far the damage spreads.

**Decision.**
1. Behaviour is wrong when something already in the repo or the brief contradicts it: a criterion, a caller, a test, a data file. No path reaching it today is not a reason to drop it.
2. An input the reviewer has to construct is a finding when the code carries on without an error and leaves a wrong value or a lost record. One that ends in a raised error is not.
3. Severity grades are not a threshold. In the source project's review records 81 of 123 findings were graded high or critical; a grade costs nothing, so it inflates.
4. Logged, without a case, so not in the lens: for a constructed input, "leaves state outside the diff" and "has readers outside the diff" as further reasons to report.

**Overturned by.** A case where (2) makes a reviewer drop a raised-error defect that matters, or a reproduced red for one of the questions in (4).
