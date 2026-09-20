# Backlog

Work that was looked at and put off on purpose. Each entry says what it is, why it waits, and what would start it. When this repo is pushed these become issues and this file goes.

## verify.sh

- **A unit spread over several repos.** Today the script checks out one repo; the other repos' state is not in the verdict and their uncommitted changes go unseen. Shape: the brief's frontmatter lists `repos:`; each must be free of uncommitted changes; the verdict records every repo's HEAD. Waits for: a real multi-repo unit to try it on. Nothing here has run in such a tree, and a script no one has run does not ship.
- **Trees too costly to check out and build afresh** (a buildroot workspace, a cross-compiled target). A fresh checkout means a full rebuild. Shape: `verify: inplace` in the brief: require no uncommitted changes, clean and rebuild the affected package in the existing build tree, run the checks there, and say in the verdict that it was in place and not a fresh checkout, because the guarantee is weaker. Waits for: the same real trial.

## Evals not yet run

- **How large a unit can be before a build leaves the saturated zone.** At six criteria every arm is green. The failures the build case copies were seen at 51 criteria. The number feeds the unit-split rule in `brief`. Starts: with `brief`, or a real project that supplies a large unit.
- **Architectural consistency across units**: onboard three feature plugins in a row against one `ARCHITECTURE.md` invariant whose check is a conformance suite, and measure drift in the third. Starts: after `brief` and the `ARCHITECTURE.md` template exist.
- **Two further reasons to report a constructed-input defect**: it leaves state outside the diff; it has readers outside the diff. No case reproduces a miss. Starts: a real review that misses one.
- **The observed model on the newer cases** (`review-silent-failure`, `review-policy-masks-defect`, `build-reservations`). Starts: before a release tag.
- **Why the skill is sometimes not picked up from a plain request.** 19/27 on `review-smoke-policy`, 77/77 elsewhere with the same prompt text; the reasoning is not in the trace. Starts: if it shows up in real use, where the skill is invoked by name.

## brief

- **Volume.** A bare brief is 9–14 criteria and about 900 words where a hand-written one is 6 and 300; two texts aimed at it showed no Δ (`BASELINE.md`). Waits for: a real unit where the owner finds the brief too long to sign, which says what to cut.
- **A walk over the project's `ARCHITECTURE.md`.** Each entry, one question: does this unit touch it; a yes needs a criterion or a decision line. The content is the project's, as `REVIEW.md` is for review; the plugin ships no design rubric. No case is red for it at this size. Starts: with the `ARCHITECTURE.md` template and the cross-unit consistency eval above.
- **An interview before the brief.** The case is one-shot. Whether asking first beats listing decisions to confirm is a question for `intent` and the multi-turn driver.

## Not built

- `templates/REVIEW.md`, `templates/brief.md`, the `ARCHITECTURE.md` template.
- `intent`.
- Codex smoke test: install, one skill invoked headless, fresh-agent dispatch confirmed or recorded absent.

## build

- **A reading of the brief is not a dispute.** Where a criterion has two readings, the builder picks one and does not write it to `disputed.md` in 2–4 of 12 trials, before and after `decisions.md` (`BASELINE.md`). After it the reading lands in `decisions.md` and reaches the ship page, as a row that does not block. Whether such a row should block waits for: the `brief` slice, which is where a two-reading criterion should be caught before it is signed.
