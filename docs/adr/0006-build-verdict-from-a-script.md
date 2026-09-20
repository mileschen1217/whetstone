# 0006 — Build: the verdict comes from a script; test-first, refactoring and a third check author are not instructed

2026-09-20. Accepted for units of about six criteria.

**Context.** Four ways of asking for the same build (plain, with a verdict format, test-first, test-first plus a refactoring pass), 6 trials each: all green on held-out tests, no false pass, no edited check, both planted conflicts raised unasked. Test-first and refactoring cost 23% and 35% more with no change in outcome. Held-out tests disagreed with the visible checks in 4 of 24 runs, all on the one planted conflict, and the builder had said so in all four.

**Decision.**
- Coverage is structural: every criterion in a brief carries a runnable check, and `scripts/verify.sh` runs each one in a clean checkout of the commit, with the check files as they were when the brief was accepted. It also reports a check that was already green at the base, and a check file that changed.
- The check author is not the builder: checks are written with the brief and signed by a human before a fresh session builds. No third, hidden author is added.
- The builder is told where disputes go (`disputed.md`), not told to look for them, to work test-first, or to refactor. Those had no Δ.
- Seen with the skill, 4/4: when a check and its criterion's text disagree the builder follows the check and marks the criterion DISPUTED; without the script half of the bare runs followed the text. The human sees the dispute either way.

**Overturned by.** A larger unit. The failures this was checked against were observed in builds of 51 criteria; whether they return with unit size is not measured.
