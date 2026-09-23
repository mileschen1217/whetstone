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

### A public second intent scenario
- **What**: the private scenario discriminates (structure 0/6 against 6/6). Rewritten without project nouns it would be the second public case for `intent`.
- **Why it waits**: `COLLECTING.md` steps 4 to 6 have not been done.
- **Known**: the defect class: asked to add a second kind of input to a pipeline built for one, the agent cuts by input kind and never asks. The scenario also carries the only evidence for round one's walk over outside dependencies (2/6 to 6/6, `BASELINE.md`); the public case needs an owner rule about a dependency that is absent, so that the clause has a case anyone can run.
- **Needed to start**: nothing.
- **First step**: the synthetic repo and owner facts, then confirm the same red bare.
- **Starts when**: question — before a release tag.
- **Seen**: nothing yet.

### `intent` explores by the list of decisions the epic will make
- **What**: explore is defined as obtaining the information each decision of the epic needs. List the decisions (the value of each `REQ`, each `D-n`, the rung, the unit split, and the `B-n` a unit will stop on); for each, name the information and its kind: look it up (a fact of the material or the environment); walk it by hand (do the design once on the real material without building, to see whether the shape holds); measure it (agent behaviour, a number, feasibility: with an instrument if one exists, else the smallest prototype that yields one number). What cannot be obtained before the product exists is a named stop: which unit, for what, asked of whom. At signing every decision is in one of two states, obtained or named stop. The question that finds the information a decision needs: what does this `REQ` presuppose, who would notice if the presupposition is wrong, and when. Information not attached to a decision is not gathered.
- **Why it waits**: found on the first real project, 2026-09-23; the skill's own eval (a two-agent driver) is the costliest to run.
- **Known**: in one real epic of two units, five times the builder found the material not as the epic assumed; three of those were facts obtainable at intent, one would have shown on a hand walk, one needed the product to exist. Record kept privately.
- **Needed to start**: the system-page entry below shipped: "who would notice, and when" is read off the page's dependency relations, and the look-up and the hand walk take their scope from its boundary; the page's on-demand part (elements, relations, behaviour for this epic's decisions) is this walk. Then a scenario for the intent driver whose owner facts include one that is in the material (not in the owner's head), one that only a hand walk shows, and one that needs the product.
- **First step**: that scenario; bare first. Right when: a unit's stops equal the epic's named stops. Wrong when: a unit still stops unannounced on information that was obtainable at intent.
- **Starts when**: behaviour — one real occurrence recorded; the owner ruled it in on 2026-09-23. After the system page.
- **Seen**: 2026-09-23, first real project, unit 1 and 2: five unforeseen stops, three obtainable at intent.

### `intent` writes the system page: purpose, boundary, exchanges
- **What**: on first contact with a system, `intent` writes one page to `.whetstone/memory/`: a purpose sentence whose subject is the person who would first decide wrongly without the system; what is inside, outside and on the boundary; a table of exchanges across the boundary (both ends, direction, content, trigger, what happens when it fails). Budget one page; more than twelve exchanges means the boundary is drawn wrong or the page should recurse: cut, do not add. Elements, relations (data, control, dependency) and behaviour are added on demand for the decisions of the epic at hand, on the same page. The owner does not write it; they read the lines they appear in and say which sentence is not this system; no objection at all is a warning. The page names the system version it describes.
- **Why it waits**: needs an epic of its own; depends on nothing in the skill today.
- **Known**: applied once, by hand, to this plugin: listing the exchanges alone surfaced two that no page had named (the owner's merge decision does not flow back; how a page reaches the owner) and one dependency outside the incident key (who writes `status: accepted`); all eight recorded incidents of this plugin sit on dependency relations, none on a data or control relation. The owner ruled on 2026-09-23 that this counts as shown, and that it is the first of two epics (the second is the entry below).
- **Needed to start**: nothing.
- **First step**: the page format as the skill would write it, then a second epic on the same synthetic repo to see whether its explore starts from the page and adds fewer rows than a rewrite. Right when: later epics start from the page and the closure check (emergent behaviour equals the purpose) catches a change of system. Wrong when: the page is written and not read, or every epic rewrites it.
- **Starts when**: question — the owner's decision, 2026-09-23.
- **Seen**: 2026-09-23, first real project: the two unnamed exchanges above.

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
- **Needed to start**: a real unit where the owner could not or did not read the brief before signing, and which part they skipped. Met 2026-09-23.
- **First step**: turn that brief into a private case and measure what the owner would have cut.
- **Starts when**: behaviour — met.
- **Seen**: 2026-09-23, first real project, units 1 and 2: a page to sign that does not separate what only the owner can judge from what a check will catch.

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

### `independent: true` is the reviewer's own word
- **What**: `review.md` says `independent: true` when the session dispatched a fresh reviewer. Nothing outside the model backs the line. Shape: the dispatching session records what it can show (the reviewer's prompt, written beside `review.md`), and `ship` says `not independent` when that file is missing.
- **Why it waits**: in every transcript read so far the dispatch was real (8/8 on Claude Code); on Codex it is the model's account only.
- **Known**: `BASELINE.md` (the chained runs, the Codex smoke test). In the workflow this distils, the one high-severity miss in forty recorded events was a reviewer reported as external that had not been run.
- **Needed to start**: nothing.
- **First step**: a case where no agent can be dispatched, to see what `review.md` says.
- **Starts when**: behaviour.
- **Seen**: 2026-09-18, in the earlier workflow, not in whetstone: a review reported as run by the external arm was answered natively.

## Project memory

### Project memory: the parts not yet wired
- **What**: `ship` writes `.whetstone/memory/` and `intent` reads it unprompted. Not wired or not measured: `brief` and `review` reading the pages in scope; deleting a statement (scope paths gone, a failing check); how many rows a green unit puts on the ship page when it writes many constraints at once (twelve in the one end-to-end pass); the number of pages.
- **Why it waits**: each is wired when a case is red without it; none has been run.
- **Known**: `BASELINE.md`, project memory. Runs open new pages by topic where a page with the same scope exists.
- **Needed to start**: for reading, a case where a constraint on a page decides a brief or a review; for deleting, a fixture with a stale page; for the page count, a real project's `.whetstone/memory/` after several epics.
- **First step**: the review case: a diff that breaks a constraint stated only on a memory page.
- **Starts when**: question — before the first real project's second epic.
- **Seen**: 2026-09-23, first real project, units 1 and 2: the merge decision was not made from the ship page. The fourth promise, at `ship`, twice.

### Retrieval beyond frontmatter and scope
- **What**: a directory level of `about:` lines, then a search index generated from the pages. The pages stay the authority; an index is a cache that can be rebuilt.
- **Why it waits**: no project has enough pages to need it.
- **Known**: nothing measured.
- **Needed to start**: a real epic where `intent` missed a page that existed (the owner was asked twice, or learned of a decision after the merge), or a frontmatter scan that no longer fits the per-invocation budget and cannot be split.
- **First step**: count the pages and the scan's lines in that project.
- **Starts when**: capability.
- **Seen**: nothing yet.

## Across stages

### The three signed pages in two layers: what needs the owner, and the record
- **What**: on `epic.md`, `brief.md` and the ship page, an item is above the line when both hold: if it is wrong it goes on without an error and leaves state outside the diff, a reader outside the diff, or a wrong value that no check, reviewer or script would turn red (the three follow-up tags `ship` already writes, which are the owner's cost-to-undo and radius); and it fixes a value or a boundary, not a shape (new; from the first real project). Everything else is below a line marked record. Nothing is dropped. Three companions with their own evidence: each decision in a brief names the `AC-n` that goes red if it is ignored, or says "no check"; before a brief is signed, a reader who did not write it walks two bounded lists (each criterion's check for under- and over-testing; each decision and requirement for a criterion that goes red) and reports gaps only; after review findings are fixed, a reader who did not write the fix marks each finding closed or open and reads only the functions the fix touched. Every signed page carries one worked example and what success looks like.
- **Why it waits**: the line is a sentence; it enters only with a case that is red without it and Δ; the two readers are dispatches whose cost is not yet known.
- **Known**: on the first real project the owner could not start reading a brief whose criteria and decisions had equal standing, and decided both merges from the conversation rather than the ship page. A reader who had not written the brief found owner decisions with no criterion to go red and checks with holes, none visible from all-red checks; a reader of the fixes closed every finding and found what the fixes had brought in, twice. The owner read the brief only after a worked example was added. Record kept privately.
- **Needed to start**: nothing; unit 1's brief and ship page are the material.
- **First step**: a private case from that brief and ship page, the owner as the reader: can they decide from the layered page alone and say why in their own words. Right when: yes. Wrong when: a decision below the line later fails; then the line is drawn wrong, not the layering.
- **Starts when**: behaviour — met, two occurrences at `ship`.
- **Seen**: 2026-09-23, first real project, units 1 and 2: a signed page with no line between what needs the owner and the record.

### Signing per epic, not per unit
- **What**: the owner signs the epic and approves the epic branch at its end; a unit's pages are records. A unit runs on without a signature when: the brief's needs-the-owner section is empty (every `B-n` traces to a `REQ` or `D-n`, no new value or boundary); the ship page has no row that blocks. It must stop on: a brief with an owner decision; a dispute; a live check that cannot be verified; a `required: state` row; a review finding still open after its fix was read; a named stop in `epic.md`. The trust is not that the epic settled everything (it cannot) but that any deviation from what the owner signed goes loud instead of being absorbed.
- **Why it waits**: it is the extension of the system page and of the line in the entry above: if the line is drawn wrong, this is automation crossing it. Second of the two epics the owner asked for on 2026-09-23.
- **Known**: on the first real project each unit stopped three times and the owner asked for a long run without a human decision while a unit's scope is bounded; the merge approvals were formal when no row blocked. One instance of a marked recommendation becoming the decision of an owner with no position is what this would amplify.
- **Needed to start**: the system-page entry shipped; the line of the entry above measured right at least once.
- **First step**: an epic on the synthetic repo run end to end with the stop conditions, then the owner's retro question: any decision learned of afterwards that was not a named stop. Right when: none. Wrong when: one.
- **Starts when**: question — after the two entries it depends on.
- **Seen**: 2026-09-23, first real project: the owner's request for a long run.

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
