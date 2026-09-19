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

## Not built

- `templates/REVIEW.md`, `templates/brief.md`, the `ARCHITECTURE.md` template.
- `ship`, `brief`, `intent`.
- Codex smoke test: install, one skill invoked headless, fresh-agent dispatch confirmed or recorded absent.
