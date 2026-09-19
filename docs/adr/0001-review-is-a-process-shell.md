# 0001 — The review skill is a process shell, not review knowledge

2026-09-19. Accepted.

**Context.** On the reference model the bare arm already finds planted defects in synthetic diffs (24/24, 25/25, 29/30). Sentences that told the reviewer what to look for did not raise recall on the one real case either; they moved thresholds, and each had a side effect. What the bare model does not do by itself is structural: the author reviewing their own change missed a defect a fresh session found (5/7 against 7/7).

**Decision.** `review` holds only what the model will not supply: a reviewer who did not write the change, one round, `clean` as a legal result, the project's `REVIEW.md` handed to the reviewer, `independent: false` when no fresh reviewer can be dispatched. Whether the work is good is the project's `REVIEW.md` and the human who signs.

**Overturned by.** A real-history case where a knowledge sentence raises recall on the reference model without raising volume, reproduced at 6 runs or more.
