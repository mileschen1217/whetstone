# Changelog

## 0.1.4

- The line's second test uses the system's boundary toward what is outside it, not the unit's diff. `line.md` reads the boundary from the system page when there is one, otherwise from the `Outside:` line that `intent` now writes at the end of Today and puts to the owner in round one (a person, another system, a user interface, a protocol, a file something outside the repo reads). Code in the repo, another unit and a later epic are inside; a format or a name only they read is not a row for the owner, and what must hold across units belongs in `REVIEW.md` or on a memory page. From the owner's reading of the first layered ship page: seven stored-format rows above the line that were internal.

## 0.1.3

- The three signed pages in two layers. `skills/line.md` is read by `intent`, `brief` and `ship`: an item is above the line when its follow-up tag is `required` (the three ship definitions, now in one place) and it fixes a cell of an exchange across the boundary (which end, what it carries, what is inside and outside, what happens when it is not there); everything else goes under `Record`. Each page carries `Decisions needed: <n>`; each `D-n` and `B-n` ends with its tag, and each `B-n` names the `AC-n` that go red when it is ignored, or `no check`. From the first real project: the owner could not tell which of twenty-three equal rows needed them.

## 0.1.2

- `intent`, round one: for each thing outside the repo that the new behaviour depends on, ask what the owner wants when it is not there. On the private scenario from a real interview record the owner's "fail loudly with its own exit code" rule reaches `epic.md` 6/6 (2/6 in 0.1.1); nothing else moved, and `intent-low-stock` is unchanged. Both intent cases have a `skill-epic` arm that stops at the epic.

## 0.1.1

- Two entry points. `build` goes on to `review` and `ship` and stops at the ship page; `intent`, once the owner has accepted the epic, goes on to the first unit's `brief` and stops at its signing. The three decisions that are a person's are not automated, and `intent` asks "Do you accept this epic?" rather than read acceptance into a reply. `epic.md`, `review.md` and `pr.md` have fixed places under `.whetstone/epics/`. Every skill can still be called alone; `build` stops at the verdict only when told in words not to review or not to ship.

- `review`: with five skills listed it was no longer invoked from a plain request (3/24). Its description now says to use it for every review request, also when the request names its own output, and to invoke it before reading the diff: 24/24, behaviour unchanged (15/15). The other four skills fire from a plain request 12/12 each; the ship cases now count it.

- `evals/RETRO.md` checked against forty recorded misses of the workflow this distils: the largest class was a page the owner signed and could not explain back, so the owner's question has a fifth item and the fourth promise covers every signed page, not only the ship page. New backlog entry: `independent: true` has nothing behind it but the reviewer's word.

- `intent` measured on a private scenario built from a real interview record: the owner's structural cut reaches `epic.md` 6/6 with the skill and 0/6 without; but the skill arm asks less about failure and lost a load-bearing "fail loudly" rule in 4/6 where bare kept it in 5/6. Recorded, not yet fixed.

## 0.1.0

- Repo skeleton: Claude Code and Codex plugin and marketplace manifests, guardrails in `CLAUDE.md`, `evals/`.
- `evals/METRICS.md` v1: three measures per stage (outcome, honesty, volume), arms, per-stage cases, interview scenarios.
- Review eval cases 1–6 with fixtures; bare baseline recorded in `evals/BASELINE.md`.
- `evals/COLLECTING.md`: real history stays private; defect classes are re-written as synthetic public cases.
- Eval budget and retirement rules; review cases cut from six to four, each tagged `rule` or `smoke`.
- Eval budget revised: cases tied to failure modes, two graders per case by default, non-discriminating graders deleted. Baseline recorded per model (opus, sonnet, haiku).
- `review` skill: one reviewer who did not write the change, one round, lens = generic + project `REVIEW.md`. Two lens sentences, each with its evidence in `evals/BASELINE.md`.
- Model tiers and run schedule in `evals/README.md`. The existing-data rule and its case were retired for lack of Δ on the reference model.
- `evals/review-self-vs-fresh/`: multi-turn driver comparing self-review, fresh review and the skill's dispatched review. Result recorded in `evals/BASELINE.md`: the dispatched review currently loses a defect that both others catch. Open.
- Eval cases write to `out/review.md` (a file named `review.md` collides with `REVIEW.md` on case-insensitive filesystems).
- `review` also takes a contract (spec or brief): `lens/contract.md`, a closed walk with five decidable questions. Evidence and two rejected variants in `evals/BASELINE.md`.
- `lens/contract.md` retired and `review` is back to diffs only: weak Δ (4 runs, recall unchanged) and an answer key labelled by an agent, not the owner. Restore from commit d90f028. Reasons in `evals/BASELINE.md`.
- `lens/generic.md`: wrong behaviour is defined by a counter-example already in the repo or the brief, not by a path that breaks today. The dispatched review went from 1/6 to 6/6 on the defect it used to drop.
- `evals/review-silent-failure`: a rule case for the finding definition. Bare reports raised-error inputs as findings (5/6), the skill does not (1/6); a silent state-corrupting input is reported by both (5/6). No sentence was added for it.
- `lens/generic.md` is now two closed walks (changed functions × two questions, `REVIEW.md` rules × one) that end when the lists end. It fixes a policy violation masking a behaviour defect in the same change (3/6 to 6/6; bare 1/6). New rule case `evals/review-policy-masks-defect`, sharing the `review-silent-failure` fixture.
- `evals/build-reservations/`: build case with a driver and a three-way grader (builder's verdict, visible checks on a clean copy, held-out tests). Bare baseline recorded for four prompt arms; nothing is red at this size, test-first and a refactoring pass cost 23–35% more for no change in outcome.
- `build` skill (26 lines) and `scripts/verify.sh` (46 lines): the verdict is written by the script from a clean checkout of the commit, with the check files as accepted; it flags checks that were green before the change and check files that changed. Fixture test in `evals/verify-fixtures/`.
- `evals/RUNBOOK.md` and `docs/adr/` (six decisions), pointed to from `CLAUDE.md`.
- `build` writes `decisions.md`: one closed walk over what the change fixes for others (stored formats, names callable from outside, messages and exit codes) where the brief left it open. Before it, the chosen file format was named in 0/6 bare and 0/4 skill replies; after, 6/6.
- `ship` skill: the pull request description as a goal line, a five-line list, one table row per thing that is not green (criterion copied whole, evidence, options with one marked, follow-up tag) and the ids of the plain passes; `FOLLOW-UP` lines in `log.md`. Cases `evals/ship-exceptions` and `evals/ship-all-green`. Bare is not red on outcome or honesty; the skill cuts the page from about 750 to about 570 words with exceptions and from about 450 to about 135 with none.
- `brief` skill and `evals/brief-reservations/` (driver, reference implementation with ten planted defects, grader). Bare is not red: checks for every criterion, red first, 59 of 60 planted defects caught, decisions listed unasked. The skill fixes the file `verify.sh` reads and leaves the status at `draft` until the owner accepts. Two texts aimed at the number of criteria showed no Δ and are not in it.
- `BACKLOG.md`: every entry in one form, with the evidence that starts it and a tally of occurrences. `evals/RETRO.md`: what counts as a failure of the workflow on a real project (four promises), which stage an event belongs to, and the walk that moves events into the backlog. `ship` writes three counts on its `log.md` line for that walk.
- `intent` skill and `evals/intent-low-stock/` (a two-agent driver: the agent under test and an agent playing the owner from a closed list of facts). The first stage that is red bare on outcome: no bare trial asked how far to restructure or learned what was coming next (0/6), and one ruled it out of scope. The skill adds that one question as a fixed three-rung ladder; the coming work reached `epic.md` in 5/6.
- `docs/adr/`: 0007 supersedes 0001 (every skill is a process shell); 0008 ship, 0009 builder decisions, 0010 the scale question in intent. Eight in force.
- Project memory: `ship` writes `.whetstone/memory/` (topic pages, what holds now, each statement with its source; an overtaken statement is rewritten where it stands). Cases `evals/intent-second-epic/` and `evals/ship-memory/`. What a second epic needs turned out to be a record with the disagreements already taken out, not a rule for reading records: a paragraph telling `intent` which record holds showed no Δ and is not in the skill.
- The seam from `epic.md` to `brief`: a brief lives in `.whetstone/epics/<epic>/units/<unit>/`, `checks:` is a path from the repo root, the base tag is `<unit>-accepted`, `From` names the epic's `REQ-n`, and a brief's decisions are `B-n`. The rung chosen in `intent` reaches the brief as a check that can be run. `ship`: the memory walk's second entry question names what code cannot say, and the candidates that did not enter are named on the page.
- One unit run end to end on the `.whetstone/` layout, each stage reading what the stage before wrote. `ship` appends to `.whetstone/log.md`.
- `evals/RETRO.md`: the walk is in two places (a `retro.md` written in the project from `.whetstone/` and the owner's answers to one fixed question; the backlog walk here), with a fixed three-part report. Run once by a fresh agent on the end-to-end tree.
- `templates/REVIEW.md`. The planned `ARCHITECTURE.md` is dropped: the `Constraints` of the memory pages are that file, kept by `ship`. `review` reads the memory pages without being told (6/6 on both arms), so nothing was wired.
- Codex smoke test: installs from the marketplace manifest, `review` runs headless through `codex exec` and writes the skill's format; fresh-agent dispatch is reported by the model, not confirmed from a trace.
