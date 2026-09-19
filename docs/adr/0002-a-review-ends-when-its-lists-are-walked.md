# 0002 — A review ends when its candidate lists are walked

2026-09-20. Accepted.

**Context.** Two failures looked opposite. Reviews of a contract raised 23–29 findings and never ran out. Reviews of a diff stopped at the first certain finding: with a broken project rule in the change, a silent behaviour defect in the same change was reported 1/6 bare against 5/6 without the broken rule. Both come from tying the stop to what has been found: "can I think of one more" is always yes, "do I have something to hand in" is yes after one.

**Decision.** Converging has two parts, each with its own mechanism. What is admitted as a finding is a closed set of questions; a yes is a finding, nothing else is. When to stop is the end of a candidate list: every changed function, then every rule in `REVIEW.md`. A yes on one item answers no other. The number of findings is a result, never a target or a reason to stop. There is no cap on findings.

**Overturned by.** A case where the walk raises volume on a clean or single-defect change, or a larger diff where walking every changed function costs more than it finds.
