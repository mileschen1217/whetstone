# Backlog

Work that was looked at and put off on purpose. When this repo is pushed these become issues and this file goes.

Every entry has the same five lines, so that someone who was not there can start it:

- **What**: the change or the question.
- **Why it waits**: the reason it was not done when it came up.
- **Known**: what has been observed, with the place the numbers are.
- **Needed to start**: the information or material that is missing. When all of it exists, the entry can start.
- **First step**: the first thing to do then.

## intent

### The `intent` skill
- **What**: the one stage with a conversation: the owner's intent, the requirement list and the unit split, as `epic.md`.
- **Why it waits**: last in the order of work (downstream first, so each stage's input format is fixed by its reader).
- **Known**: the scoring row is in `evals/METRICS.md`; the scenario design (a closed list of owner facts, each marked load-bearing, an owner played by an agent that only answers what is asked) is in the same file. Headless multi-turn works with `--resume`.
- **Needed to start**: the owner's agreement on what `intent` is for, what it must avoid and what done looks like; one scenario file, its facts taken from a real interview record.
- **First step**: the multi-turn driver and the bare baseline.

### An interview before the brief
- **What**: does asking the owner first beat writing the brief in one pass and listing decisions to confirm?
- **Why it waits**: needs the multi-turn driver that `intent` brings.
- **Known**: one-pass briefs list 6–13 decisions unasked, 6/6 (`BASELINE.md`, brief).
- **Needed to start**: the driver; a scenario where a wrong assumption is costly to find at signing.
- **First step**: the same request through both routes, scored on the owner's load-bearing facts.

## brief

### Number of criteria and length
- **What**: a bare brief is 9–14 criteria and about 900 words where a hand-written one is 6 and 300.
- **Why it waits**: two texts aimed at it showed no Δ and nothing says yet that the length costs the signer anything.
- **Known**: `BASELINE.md`, brief: the `From` column, and "a decision gets a criterion only when…", 13.2 and 11.8 criteria against 11.3 bare.
- **Needed to start**: a real unit where the owner could not or did not read the brief before signing, and which part they skipped.
- **First step**: turn that brief into a private case and measure what the owner would have cut.

### A criterion with two readings
- **What**: where a criterion can be read two ways the builder picks one, and in 2–4 of 12 trials does not dispute it. Should `brief` catch it before signing, or should such a line in `decisions.md` block the merge?
- **Why it waits**: the builder's reading now reaches the ship page through `decisions.md`; no unit has been harmed by it yet.
- **Known**: `BASELINE.md`, build: 10/12 before `decisions.md`, 8/12 after, same cause.
- **Needed to start**: a bare-red case: a request whose natural brief contains a two-reading criterion, and a count of how often the brief author leaves it in.
- **First step**: add one such sentence to `evals/brief-reservations/` and run bare.

### Design quality: general principles as a lens
- **What**: a check of the brief's interface and structure against general design principles (information hiding, cohesion, coupling, no speculative generality), by a reviewer who did not write it, one round, advisory.
- **Why it waits**: those principles are grade words ("minimise"), which the three sentence tests in `CLAUDE.md` reject as they stand, and nothing measured says the model needs to be told them. Teaching the reviewer how to review showed no Δ on diffs.
- **Known**: nothing for design. The brief case plants behaviour defects, not design flaws.
- **Needed to start**: a bare-red case: a request whose natural brief carries a design flaw with an executable consequence (a second unit that has to change three files because the first leaked its storage format), and the rate at which a bare brief author and a bare reviewer leave it in.
- **First step**: write that two-unit case; if bare is green, close this entry.

### A walk over the project's `ARCHITECTURE.md`
- **What**: for each entry, does this unit touch it; a yes needs a criterion or a decision line. Project content, as `REVIEW.md` is for review.
- **Why it waits**: no template and no case.
- **Known**: nothing measured.
- **Needed to start**: the `ARCHITECTURE.md` template; the cross-unit case below.
- **First step**: the template, then the case.

## build and verify.sh

### A unit spread over several repos
- **What**: the brief's frontmatter lists `repos:`; each must be free of uncommitted changes; the verdict records every repo's HEAD.
- **Why it waits**: a script no one has run in such a tree does not ship.
- **Known**: today the script checks out one repo; the others' state is not in the verdict.
- **Needed to start**: a real multi-repo unit: its layout, which repo holds the brief, how the checks reach the other repos.
- **First step**: a fixture in `evals/verify-fixtures/` copying that layout.

### Trees too costly to check out and build afresh
- **What**: `verify: inplace` in the brief: no uncommitted changes, clean and rebuild the affected package in the existing build tree, run the checks there, and say in the verdict that the guarantee is weaker.
- **Why it waits**: as above.
- **Known**: nothing run.
- **Needed to start**: a real buildroot or cross-compiled unit: the rebuild command for one package, how long it takes, where the check runs (host, emulator, target).
- **First step**: run today's script there and record what breaks.

### How large a unit can be
- **What**: the largest unit for which a build stays in the zone where every arm is green. The number becomes the unit-split rule.
- **Why it waits**: 10 USD and more a trial.
- **Known**: green at 6 criteria; the failures the case copies were seen at 51 (`BASELINE.md`, build).
- **Needed to start**: a brief of 20–30 criteria with held-out tests, from a real project or grown from the inventory case.
- **First step**: bare, three trials, at 12, 24 and 48 criteria.

### The same structure across units
- **What**: onboard three feature plugins in a row against one `ARCHITECTURE.md` invariant whose check is a conformance suite; measure drift in the third.
- **Why it waits**: needs the template and `brief`.
- **Known**: nothing measured.
- **Needed to start**: the `ARCHITECTURE.md` template; a small host with a plugin interface as a fixture.
- **First step**: the fixture and the bare baseline.

## review

### Two further reasons to report a constructed-input defect
- **What**: it leaves state outside the diff; it has readers outside the diff.
- **Why it waits**: no case reproduces a miss; the silent-failure axis needed no sentence.
- **Known**: `BASELINE.md`, review.
- **Needed to start**: a real review that missed one of the two.
- **First step**: the record in `COLLECTING.md` form, then a private case.

### The skill is sometimes not picked up from a plain request
- **What**: 19/27 on `review-smoke-policy`, 77/77 elsewhere with the same prompt text.
- **Why it waits**: the product path invokes the skill by name; the reasoning is not in the trace.
- **Known**: `BASELINE.md`, review.
- **Needed to start**: an occurrence in real use, with the request text.
- **First step**: compare that request with the skill's description.

## Across stages

### The observed model on the newer cases
- **What**: sonnet on `review-silent-failure`, `review-policy-masks-defect`, `build-reservations`, `brief-reservations`, the ship cases.
- **Why it waits**: the observed model decides nothing.
- **Needed to start**: nothing.
- **First step**: before a release tag, per the schedule in `evals/README.md`.

### Templates
- **What**: `templates/REVIEW.md`, `templates/brief.md`, `templates/ARCHITECTURE.md`.
- **Why it waits**: each stage was written against a fixture first.
- **Known**: the brief's shape is in `skills/brief/SKILL.md`; a `REVIEW.md` exists in the review fixtures.
- **Needed to start**: nothing for the first two; for `ARCHITECTURE.md`, the six entry kinds agreed earlier, from the record.
- **First step**: lift the first two out of the fixtures.

### Codex smoke test
- **What**: install, one skill invoked headless with `codex exec`, fresh-agent dispatch confirmed or recorded absent.
- **Why it waits**: all five skills first.
- **Known**: the plugin installs on a throwaway `CODEX_HOME`.
- **Needed to start**: `intent`.
- **First step**: `review` on the clean fixture.
