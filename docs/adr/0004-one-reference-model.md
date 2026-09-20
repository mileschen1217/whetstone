# 0004 — One reference model decides; other models are observed

2026-09-19. Accepted.

**Context.** The same cases fail differently by model. Smaller models narrow a review to the policy file and return `clean` on a broken change; the reference model does neither. The vendor documents that instructions a weaker model needs become harmful on a stronger one. Every sentence also spends the 300-line budget.

**Decision.** `opus` is the reference: a rule enters on its Δ, a case retires when it is green bare there. `sonnet` is observed: its numbers are recorded and stated in the README, and nothing is added or reworded for it. A rule that helps only the observed model does not enter. Other vendors' models are checked for install and invocation only.

**Overturned by.** The owner starting to run the plugin on another model, or a new reference model: then every case, including retired ones, is re-run on both arms.
