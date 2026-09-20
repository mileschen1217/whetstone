# Backlog

Work that was looked at and put off on purpose. When this repo is pushed these become issues and this file goes.

Every entry has the same seven lines, so that someone who was not there can start it:

- **What**: the change or the question.
- **Why it waits**: the reason it was not done when it came up.
- **Known**: what has been observed, with the place the numbers are.
- **Needed to start**: the information or material that is missing.
- **First step**: the first thing to do then.
- **Starts when**: the evidence that starts it, by kind (below).
- **Seen**: one line per occurrence: date, unit, one sentence. Added at a retrospective (`evals/RETRO.md`).

An entry starts when its evidence is there and everything under "Needed to start" exists. Three kinds:

- **capability** (a script, a format, a template is missing): one real unit that was blocked or had to work around it. That unit is the material.
- **behaviour** (the change would be a sentence in a skill): two occurrences attributed to this entry; one is enough when its consequence could not be undone, went unnoticed while it did damage, or reached many modules. Starting means reproducing it as a case; the sentence enters only on a bare-red case with Δ.
- **question** (a measurement not yet taken): a date or a decision that needs the number, not an occurrence.

## intent

### A second intent scenario
- **What**: `intent-low-stock` is one scenario. A second with a different territory surprise and an owner for whom the smallest change is right, to see that the ladder does not push upwards.
- **Why it waits**: the end-to-end workflow came first.
- **Known**: `BASELINE.md`, intent: in the one trial where the owner named nothing coming, the larger rung was not offered.
- **Needed to start**: a real interview record to take the facts from.
- **First step**: the scenario file; bare and skill, 6 trials each.
- **Starts when**: question — before a release tag.
- **Seen**: nothing yet.

### An interview before the brief
- **What**: does asking the owner first beat writing the brief in one pass and listing decisions to confirm?
- **Why it waits**: needs the multi-turn driver that `intent` brings.
- **Known**: one-pass briefs list 6–13 decisions unasked, 6/6 (`BASELINE.md`, brief).
- **Needed to start**: the driver; a scenario where a wrong assumption is costly to find at signing.
- **First step**: the same request through both routes, scored on the owner's load-bearing facts.
- **Starts when**: question — when `intent` has its driver.
- **Seen**: nothing yet.

## brief

### Number of criteria and length
- **What**: a bare brief is 9–14 criteria and about 900 words where a hand-written one is 6 and 300.
- **Why it waits**: two texts aimed at it showed no Δ and nothing says yet that the length costs the signer anything.
- **Known**: `BASELINE.md`, brief: the `From` column, and "a decision gets a criterion only when…", 13.2 and 11.8 criteria against 11.3 bare.
- **Needed to start**: a real unit where the owner could not or did not read the brief before signing, and which part they skipped.
- **First step**: turn that brief into a private case and measure what the owner would have cut.
- **Starts when**: behaviour.
- **Seen**: nothing yet.

### A criterion with two readings
- **What**: where a criterion can be read two ways the builder picks one, and in 2–4 of 12 trials does not dispute it. Should `brief` catch it before signing, or should such a line in `decisions.md` block the merge?
- **Why it waits**: the builder's reading now reaches the ship page through `decisions.md`; no unit has been harmed by it yet.
- **Known**: `BASELINE.md`, build: 10/12 before `decisions.md`, 8/12 after, same cause.
- **Needed to start**: a bare-red case: a request whose natural brief contains a two-reading criterion, and a count of how often the brief author leaves it in.
- **First step**: add one such sentence to `evals/brief-reservations/` and run bare.
- **Starts when**: behaviour.
- **Seen**: 2026-09-20, eval only (`build-reservations`), not a real unit: the builder chose a reading of AC-3 against AC-5 without disputing it, 2–4 of 12.

### Design quality: general principles as a lens
- **What**: a check of the brief's interface and structure against general design principles (information hiding, cohesion, coupling, no speculative generality), by a reviewer who did not write it, one round, advisory.
- **Why it waits**: those principles are grade words ("minimise"), which the three sentence tests in `CLAUDE.md` reject as they stand, and nothing measured says the model needs to be told them. Teaching the reviewer how to review showed no Δ on diffs.
- **Known**: nothing for design. The brief case plants behaviour defects, not design flaws.
- **Needed to start**: a bare-red case: a request whose natural brief carries a design flaw with an executable consequence (a second unit that has to change three files because the first leaked its storage format), and the rate at which a bare brief author and a bare reviewer leave it in.
- **First step**: write that two-unit case; if bare is green, close this entry.
- **Starts when**: behaviour.
- **Seen**: nothing yet.

### `brief` walking the memory constraints in scope
- **What**: for each constraint on a memory page whose `scope` the unit touches: does the unit touch it; a yes needs a criterion or a decision line. This replaces the `ARCHITECTURE.md` that was planned: the pages' `Constraints` are that file, kept by `ship`.
- **Why it waits**: `intent` and `review` read the pages without being told (`BASELINE.md`); nothing says `brief` does not.
- **Known**: nothing measured for `brief`.
- **Needed to start**: a bare-red case: a unit whose natural brief breaks a constraint that is only on a page.
- **First step**: that case.
- **Starts when**: behaviour.
- **Seen**: nothing yet.

## build and verify.sh

### A unit spread over several repos
- **What**: the brief's frontmatter lists `repos:`; each must be free of uncommitted changes; the verdict records every repo's HEAD.
- **Why it waits**: a script no one has run in such a tree does not ship.
- **Known**: today the script checks out one repo; the others' state is not in the verdict.
- **Needed to start**: a real multi-repo unit: its layout, which repo holds the brief, how the checks reach the other repos.
- **First step**: a fixture in `evals/verify-fixtures/` copying that layout.
- **Starts when**: capability.
- **Seen**: nothing yet.

### Trees too costly to check out and build afresh
- **What**: `verify: inplace` in the brief: no uncommitted changes, clean and rebuild the affected package in the existing build tree, run the checks there, and say in the verdict that the guarantee is weaker.
- **Why it waits**: as above.
- **Known**: nothing run.
- **Needed to start**: a real buildroot or cross-compiled unit: the rebuild command for one package, how long it takes, where the check runs (host, emulator, target).
- **First step**: run today's script there and record what breaks.
- **Starts when**: capability.
- **Seen**: nothing yet.

### How large a unit can be
- **What**: the largest unit for which a build stays in the zone where every arm is green. The number becomes the unit-split rule.
- **Why it waits**: 10 USD and more a trial.
- **Known**: green at 6 criteria; the failures the case copies were seen at 51 (`BASELINE.md`, build).
- **Needed to start**: a brief of 20–30 criteria with held-out tests, from a real project or grown from the inventory case.
- **First step**: bare, three trials, at 12, 24 and 48 criteria.
- **Starts when**: question — when the unit-split rule is written, or a real unit of 20 or more criteria turns up.
- **Seen**: nothing yet.

### The same structure across units
- **What**: onboard three feature plugins in a row against one memory-page constraint whose check is a conformance suite; measure drift in the third.
- **Why it waits**: needs the template and `brief`.
- **Known**: nothing measured.
- **Needed to start**: a small host with a plugin interface as a fixture.
- **First step**: the fixture and the bare baseline.
- **Starts when**: question — before a release tag.
- **Seen**: nothing yet.

## review

### Two further reasons to report a constructed-input defect
- **What**: it leaves state outside the diff; it has readers outside the diff.
- **Why it waits**: no case reproduces a miss; the silent-failure axis needed no sentence.
- **Known**: `BASELINE.md`, review.
- **Needed to start**: a real review that missed one of the two.
- **First step**: the record in `COLLECTING.md` form, then a private case.
- **Starts when**: behaviour.
- **Seen**: nothing yet.

### The skill is sometimes not picked up from a plain request
- **What**: 19/27 on `review-smoke-policy`, 77/77 elsewhere with the same prompt text.
- **Why it waits**: the product path invokes the skill by name; the reasoning is not in the trace.
- **Known**: `BASELINE.md`, review.
- **Needed to start**: an occurrence in real use, with the request text.
- **First step**: compare that request with the skill's description.
- **Starts when**: behaviour.
- **Seen**: nothing yet.

## Project memory

### Project memory: the parts not yet wired
- **What**: `ship` writes `.whetstone/memory/` and `intent` reads it unprompted. Not wired or not measured: `brief` and `review` reading the pages in scope; deleting a statement (scope paths gone, a failing check); how many rows a green unit puts on the ship page when it writes many constraints at once (twelve in the one end-to-end pass); the number of pages.
- **Why it waits**: each is wired when a case is red without it; none has been run.
- **Known**: `BASELINE.md`, project memory. Runs open new pages by topic where a page with the same scope exists.
- **Needed to start**: for reading, a case where a constraint on a page decides a brief or a review; for deleting, a fixture with a stale page; for the page count, a real project's `.whetstone/memory/` after several epics.
- **First step**: the review case: a diff that breaks a constraint stated only on a memory page.
- **Starts when**: question — before the first real project's second epic.
- **Seen**: nothing yet.

### Retrieval beyond frontmatter and scope
- **What**: a directory level of `about:` lines, then a search index generated from the pages. The pages stay the authority; an index is a cache that can be rebuilt.
- **Why it waits**: no project has enough pages to need it.
- **Known**: nothing measured.
- **Needed to start**: a real epic where `intent` missed a page that existed (the owner was asked twice, or learned of a decision after the merge), or a frontmatter scan that no longer fits the per-invocation budget and cannot be split.
- **First step**: count the pages and the scan's lines in that project.
- **Starts when**: capability.
- **Seen**: nothing yet.

## Across stages

### The observed model on the newer cases
- **What**: sonnet on `review-silent-failure`, `review-policy-masks-defect`, `build-reservations`, `brief-reservations`, the ship cases.
- **Why it waits**: the observed model decides nothing.
- **Needed to start**: nothing.
- **First step**: before a release tag, per the schedule in `evals/README.md`.
- **Starts when**: question — before a release tag.
- **Seen**: nothing yet.

### Templates
- **What**: `templates/REVIEW.md` exists. No template for `brief.md`, `epic.md` or a memory page: their shape is stated in the skill that writes them, and a template would be a second authority for the same format.
- **Why it waits**: nothing left to do unless a real project shows a starter file is missed.
- **Known**: —
- **Needed to start**: a first real project that asks for one.
- **First step**: —
- **Starts when**: capability.
- **Seen**: nothing yet.

### Fresh-agent dispatch on Codex, from a trace
- **What**: the smoke test passed (`BASELINE.md`), but that Codex dispatched a fresh reviewer is the model's own account.
- **Why it waits**: needs the event stream of `codex exec` read for the dispatch itself.
- **Known**: install, a headless skill call and the output format are confirmed.
- **Needed to start**: nothing.
- **First step**: the same run with `--json`, looking for the sub-agent event.
- **Starts when**: question — before the README claims dispatch on Codex.
- **Seen**: nothing yet.
