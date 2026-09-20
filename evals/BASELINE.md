# Results — review

`claude plugin eval`, 3 runs per arm unless noted. A cell is runs passed / runs. reference = `opus`, observed = `sonnet` (measured, not tuned for). 2026-09-19. Failing runs were read, not only scored.

## With and without the skill

| Case | Tag | opus with | opus without | sonnet with | sonnet without |
|---|---|---|---|---|---|
| review-one-root-cause | rule | 3/3 | 1/3 | 3/3 | 1/3 |
| review-smoke-clean | smoke | 3/3 | 3/3 | 3/3 | 3/3 |
| review-silent-failure (6 runs per arm, opus only) | rule | 4/6 | 0/6 | — | — |
| review-smoke-policy | smoke | 3/3 | 3/3 | 3/3 | 3/3 |

- `review-one-root-cause`, opus: bare reports the paging defect as two or more findings in 2/3; with the skill, once in 3/3, and findings drop from 4–5 to 3. sonnet: bare returns one policy finding and misses both correctness defects in 2/3; with the skill all three defects in 3/3.
- `review-silent-failure`, opus, 6 runs per arm: nothing in the repo contradicts the change; three inputs exist only if the reviewer constructs them. The silent one (a repeated `order_id` overwrites the reservation while stock drops again) is reported 5/6 on both arms. The two loud ones (`KeyError`, `IndexError`) are reported in 5/6 bare runs and 1/6 with the skill; findings per review 0–3 bare (3 in four runs), 0–2 with the skill. Not sonnet-run yet.
- Cost of the skill arm on opus: about 5 more turns and 0.05–0.12 USD more per review.

## The lens as two closed walks (2026-09-20)

`lens/generic.md` was rewritten from a definition of a finding into two walks: each function the diff changes or adds, two questions (does something in the repo or the brief contradict it; is there an input on which it carries on and leaves a wrong value or a lost record); then each rule in `REVIEW.md`, one question. A yes is a finding, nothing else is, a yes on one item answers no other item, and the review ends when both walks end. 12 lines, was 5.

The reason: the two failures seen in review, reporting too much and stopping too early, have one cause. The stop was tied to what had been found ("can I still think of something", "do I have something to hand in"). The walk ties it to the candidate list.

The red it answers, `review-policy-masks-defect`: one change with a broken `REVIEW.md` rule and a silent behaviour defect. The same change without the broken rule is `review-silent-failure`. opus, 6 runs per cell unless noted; silent defect reported:

| Lens | no broken rule in the change | a broken rule in the same change | raised-error inputs reported as findings |
|---|---|---|---|
| none (bare) | 5/6 | 1/6 | 5/6 |
| definition of a finding (the previous lens) | 5/6 | 3/6 | 1/6 |
| the previous lens plus "a broken rule does not end the review…" | — | 4/6 | 2/6 |
| two walks | 6/6 | 6/6, and 9/9 of the fired runs in two earlier batches of 6 | 0/6, 0/6 |

- With the walks every fired run on the masked case gave exactly two findings, the broken rule and the defect; on the unmasked case exactly one.
- Dispatched review (`review-self-vs-fresh`, skill arm, 6 trials): data-file defect 6/6, consumer 6/6, two findings each. A first wording lost this, 2/6: "an input that ends in a raised error is not a finding" was written for every question, and the repo's own data file being rejected is a raised error. The exclusion now names question 2 only. Kept as a warning that an exclusion written too wide undoes a finding another question admits.
- One-arm regression, 3 runs each: `review-one-root-cause` 3 findings 3/3, `review-smoke-clean` `clean` 3/3, `review-policy-masks-defect` 3/3. `review-smoke-policy` now gets 2 findings where it got 1: the second is the silent overwrite, which question 2 admits although nothing reads the record there.
- Runs where the skill did not fire (3 of 12 in the two earlier batches) behave like the bare arm and are counted apart.
- Cost of this work: 23.8 USD. Not measured: sonnet; the bare arm was not re-run for the new case beyond the private probe it came from (1/6).

## What each sentence in the lens rests on

The first three rows are now carried by the walk's questions and its closing paragraph rather than by separate sentences.

| Sentence | Evidence |
|---|---|
| the review ends when both walks are finished; a yes on one item answers no other | `review-policy-masks-defect`, table above |
| one root cause is one finding | `review-one-root-cause`, table above |
| behaviour is wrong when something in the repo or the brief contradicts it; no path reaching it today is not a reason to drop it | the dispatched review, 1/6 to 6/6 on the data-file defect; see Diagnosis and the first-tier fix |
| a finding is wrong behaviour or a broken project rule; style is not; `clean` is correct | the skill itself caused the failure: with the skill but without this sentence, opus reported style findings on `review-smoke-clean` in 5/6 runs (bare: 0/3). With the sentence: 6/6 `clean` |

The third row repairs a regression the skill introduces, so `review-smoke-clean` is green on the bare arm by construction. `review-silent-failure` is the same sentence's discriminating case: bare reports raised-error inputs as findings, the skill does not, and the silent defect is kept at the same rate.

## Contract review (a spec before it is accepted)

One private case built from real history: a 30-criterion spec as it stood before a review round, scored against that round's 28 type-labelled findings (9 real defects, 13 missing-criterion findings, 6 refinements). opus, 4 runs per row. Each review line is matched to the key by a judge model; same defect counts, same criterion for a different reason does not.

| Lens | findings per review | real defects found, of 9 | lines matching nothing in the key |
|---|---|---|---|
| none (bare) | 23–29 | 2, 2, 2, 2 | 14–19 |
| `lens/contract.md`, a closed walk with five questions (shipped, then retired; see Retired) | 16, 16, 16, 24 | 2, 3, 3, 3 | 10–15 |
| tried: findings must state a concrete cost, no walk | 8–17 | 0, 1, 1, 3 | 6–12 |
| tried: the walk plus a required cost sentence | 12–18 (3 runs) | 1, 3, 3 | 9–13 |

- Bare, a plain textual inconsistency twelve lines apart (a requirement and its own criterion naming the same item differently) was missed 4/4 while 23–29 other findings were raised. With the walk it was found 3/4.
- The cost-only lens cut volume most and cut real defects with it; it was not kept.
- This is 4 runs per row and a judge-model match; at least two of the nine real defects need knowledge outside the spec.
- The key is not an independent oracle. Its type labels and its dispositions (27 of 28 fixed) were set by the agent that ran that review round, not by the owner, so "acted on" does not discriminate and the owner cannot label the unmatched lines after the fact. Precision of the extra findings is not measured.
- The lens was retired on this evidence without a confirmation run: recall did not move (2 against 2–3 of 9), the volume Δ rests on 4 runs, and the contract format it was tuned on is another project's, not the `brief.md` this plugin will produce.
- A large synthetic check (a 59-criterion spec with six planted whole-document inconsistencies) did not discriminate: bare opus found 29/30. What it showed was volume: 17–29 findings per review, and halving the criteria did not reduce it.

## Self-review, fresh review, and the skill's dispatched review

`evals/review-self-vs-fresh/run.sh`, outside the harness (it cannot continue a session). One trial: a builder session makes a two-part change, then three reviews of what it built. opus, 7 trials for self and fresh, 6 for the skill arm. The change carries two defects: a consumer that was not updated, and a new required field that the repo's own data file does not have.

| Review by | consumer defect | data-file defect | findings per review | cost per review |
|---|---|---|---|---|
| fresh session, no plugin | 7/7 | 7/7 | 2–3 | 0.29–0.35 USD |
| the builder session itself, no plugin | 7/7 | 5/7 | 2–5 | 0.28–0.45 USD |
| the builder session with the skill (dispatches a fresh agent) | 5/6 | 1/6 | 0–2 | 0.61–0.78 USD |

- Self-review is worse than fresh review on the defect the builder had not thought of, and reports more that is not a defect. In both misses the builder had named the data-file problem while building, then left it out of its own review.
- **The skill arm is the worst of the three.** The structure works as written: in 6/6 the session recognised it wrote the change, dispatched one agent, passed nothing from the conversation, and changed nothing in the answer. The dispatched review is what fails: it drops the data-file defect, and once returned `clean` on a broken change, reasoning that no `REVIEW.md` rule was touched.
- Two things were tried and did not fix it: passing the user's request word for word to the dispatched agent (1/6, reverted), and removing the one-root-cause sentence (2/6). The cause is not isolated. A fresh session with the skill and no dispatch caught the same class of defect 14/14 (retired case above), so the loss is in the dispatch step or in how the lens reads when it is the agent's whole instruction.
- The three harness cases did not see this. It needs a case; none exists yet.

### Diagnosis and the first-tier fix (2026-09-19, later)

Reading the kept traces: in every miss whose reasoning was visible (3 of 3), the dispatched agent had read `data/seed.json`, seen the missing field, and dropped it on purpose: "`store.load` has no in-repo callers, so … breaks nothing today". It read "behaviour that is wrong" as "a path breaks today". The defect was seen and excluded by the definition of a finding, not lost. On a green-field repo nothing has a caller, so that reading cannot be the rule.

The first paragraph of `lens/generic.md` now says behaviour is wrong when something already in the repo or the brief contradicts it (a criterion, a caller, a test, a data file), and that no code path reaching it today is not a reason to drop it. Skill arm only, a fresh builder session per trial, opus:

| `lens/generic.md` | data-file defect | consumer defect | findings per review |
|---|---|---|---|
| before | 1/6 | 5/6 | 0–2 |
| after | 6/6 | 6/6 | 2, every run |
| ablation: the old text again, run after the fix, same driver | 2/6 | 5/6 | 0–2, one `clean` on the broken change |

- 6 trials, 5.50 USD including the builder sessions. Before and after are different builder outputs of the same task. Every written review was read; the score is not a string coincidence.
- The ablation separates the sentence from the orchestrator's own restating of the lens ("apply strictly", "judge it against the lens and nothing else", "report ONLY findings that the lens admits"): such wording appears in 3 of the 6 runs with the new text, all of which report the defect, and in 4 of the 6 ablation runs. With the old text the dispatched agent again drops the defect for the same stated reason ("no in-repo callers"). Old text 3/12 over both batches, new text 6/6. Ablation cost 5.69 USD. One string-match score was corrected by reading: a review that names `data/seed.json` inside the consumer finding does not count.
- One-arm regression after this change, 3 runs per case: result graders 9/9. `review-one-root-cause` 3 findings in every run (three planted defects), `review-smoke-clean` `clean` 3/3. There is no cap on the number of findings anywhere in the skill; the count follows the defects present. The skill was not invoked in 1/3 runs of `review-smoke-policy`, and in 2/6 of a later run. Looked into: over every opus run kept, the skill fired 19/27 on `review-smoke-policy` and 77/77 on the four other cases, with an identical prompt text, so it is tied to this fixture's content and not to the wording of the request or the size of the diff. In the runs that skip it the model reads `REVIEW.md` and the diff, then reviews directly; its reasoning is not in the trace, so the cause is not established. In use the skill is invoked by name, so this affects measurement, not the product path: the with arm of this case mixes fired and unfired runs, and `path-skill-fired` tells them apart.

Logged, not a rule (no case reproduces a red yet): a finding whose counter-example is only hypothetical is reported only when leaving it costs more later — it leaves state outside the diff (written data, a run migration, a published format), or it sits in something with readers outside the diff (a persisted format, a public signature, a declared interface). Tried as a rule and not entered: no sentence was needed for the silent axis. On `review-silent-failure` the lens as it stands already reports the silent defect (5/6) and drops the loud ones (5/6); there is no red to fix, so nothing was added. The other two questions have no case and stay logged.

A different red turned up while building that case; it was closed the next day by the two walks (section above). The same change with a policy violation also present (private probe, 6 runs per arm): the silent defect is reported 1/6 bare and 3/6 with the skill, against 5/6 and 5/6 without the violation. Once a broken rule is found, the behaviour defect is mostly not looked for; the skill halves the loss and does not remove it. One sentence was tried ("a broken rule does not end the review: every function the diff changes is still read for wrong behaviour"): 4/6, and raised-error findings came back in 2/6. No Δ, not entered. An earlier reading of this as "bare misses silent failures" was wrong: in `review-smoke-policy` nothing reads the overwritten record, so there the overwrite has no consequence to report. A first grader for the silent defect matched the word "same" in the changelog finding and scored 6/6 where the truth was 0/6; it was tightened and every run re-read.

A third question was accepted by the owner for the same tier: does it fail silently (a wrong value or a lost record, no error)? A loud failure is found the first time it triggers; a silent one accumulates. A candidate case, seen once and then checked: in `review-smoke-policy` the change lets a repeated `order_id` overwrite the earlier reservation while stock is reduced again. It was reported in 1 of 3 regression runs (the run where the skill did not fire); in a follow-up of 6 runs per arm it was reported 0/6 bare and 0/6 with the skill. So both arms miss it, which is the entry condition for a rule case; none is written yet. Severity grades are not used as the threshold: in the source project's own review records 81 of 123 findings were graded high or critical.

On a case-insensitive filesystem an output file named `review.md` is the policy file `REVIEW.md`. All cases now write to `out/review.md`. Earlier numbers were taken with the collision present; graders read the written content, so scores were unaffected, but the policy file was overwritten during those runs.

Regression run after the path change, skill arm only: 3/3 on all three cases for result graders. The skill was not invoked in 2/3 runs of `review-smoke-policy`.

## Retired

| Case | Retired on | Why | Restore from |
|---|---|---|---|
| review-existing-data, and its rule (check each new constraint against data already in the repo) | opus | bare red did not reproduce on the current fixture: 13/14 bare against 14/14 with the rule. The earlier 1/3 was on a fixture with two more modules in the base. On sonnet the rule moved the data finding from 0/3 to 2/3 and the consumer finding from 1/3 to 0/3; sonnet is observed only | commit 9caa9c8 |
| `lens/contract.md` (closed walk, five questions) and the skill's contract subject | opus | weak Δ, see Contract review above; no independent oracle for the findings it removes. `spec-review-r1` stays as a private case for when `brief` produces a contract | commit d90f028 |
| review-1 (two small correctness defects) | opus | green bare 3/3 | commit 7f41d9e |
| review-3 (clean refactor) | opus | green bare 3/3; covered by review-smoke-clean | commit 7f41d9e |

Retirement holds for the model named. None of these was retired on sonnet.

## Bare behaviour by model (no skill), for reference

sonnet and haiku narrow the review to the rules in `REVIEW.md`: they return `clean` on a broken change or one policy finding on a change with correctness defects, and they misapply a policy rule to produce a finding. opus does neither. haiku bare: `review-one-root-cause` 0/3.

# Results — build

2026-09-20. `evals/build-reservations/run.sh`, outside the harness: the harness seals the workspaces it keeps, and the built tree has to be run. One trial: a workspace with an accepted `brief.md` (six criteria, one visible check each under `checks/`), one headless session, then `grade.py` measures the tree three ways: the builder's own verdict, the visible checks re-run on a clean copy with the original check files, and 13 held-out tests the builder never saw. opus, 6 trials per arm, no plugin in any arm; the arms differ only in the prompt (`arms/*.md`). 13.86 USD for the 24 trials.

Planted, each taken from a real multi-arm build of a 51-criterion spec where it had separated the arms: the brief contradicts itself (AC-3 against AC-5); one check disagrees with its criterion's text at a boundary (AC-4); two "changes nothing" clauses that the visible checks do not test (AC-2, AC-6).

| Arm | held-out passed, of 13 | claimed PASS and failing held-out | check files edited | both conflicts raised unasked | USD | turns | seconds | output tokens | diff lines |
|---|---|---|---|---|---|---|---|---|---|
| plain: "build it, tell me when it is done" | 12.7 | 0 | 0 | 6/6 | 0.44 | 8.7 | 105 | 8,188 | 123 |
| bare: the same, plus the verdict file format `AC-n PASS\|FAIL\|DISPUTED — evidence` and "do not edit `checks/`" | 13.0 | 0 | 0 | 6/6 | 0.52 | 10.0 | 125 | 9,733 | 157 |
| test-first: bare plus "see each check fail first; add your own test where the check is thin" | 12.8 | 0 | 0 | 6/6 | 0.64 | 10.7 | 147 | 12,495 | 297 |
| test-first plus one refactoring pass | 12.8 | 0 | 0 | 6/6 | 0.70 | 11.3 | 164 | 13,609 | 290 |

- Nothing here is red. Every arm passes the held-out tests for the untested "changes nothing" clauses, edits no check, reports no criterion as passing that fails, and raises both planted conflicts without being asked. Both the conflict flags and the scores were read in the outputs, not only matched.
- Held-out against visible checks: in 4 of 24 runs every visible check was green while a held-out test was red. All four are the planted AC-4 conflict, where the builder built to the check rather than to the text, and in all four the builder said so. At this size the held-out tests told the owner nothing the builder had not.
- Test-first and the refactoring pass change no outcome. They cost 23% and 35% more than bare and roughly double the diff. No Δ, so neither enters a skill.
- The verdict format is not a behaviour fix (plain raises the conflicts too). It is an interface: it gives the next stage one line per criterion, and it kept one thing apart that prose blurred, a run that opened with "all six checks pass" and explained two paragraphs later that AC-4's text does not hold.
- With the `build` skill (4 trials, `arms/skill.md`, the workspace now a git repo tagged where the brief was accepted): 4/4 committed, ran `scripts/verify.sh`, and reported the script's table unchanged; both conflicts were written to `disputed.md` and show as `DISPUTED (PASS)`, so the result is "not pass" until a human rules. 0.62–0.69 USD, 18–20 turns. One shift to know about: all four built to AC-4's check rather than to its text (held-out 12/13), where four of six bare runs had followed the text. The verdict is taken from the checks, so the checks win; the dispute is on the page either way.
- Choices the brief left open (2026-09-20, later). The brief says "the file format of `save` is free". In the replies already on file, the format the builder chose was named by the bare arm in 0/6 and by the `build` skill in 0/4 (read, not only matched); the plain arm named it 6/6. A stored format is state outside the diff, so this is red. With one walk added to the skill (formats, names callable from outside, messages and exit codes; one line each in `decisions.md`): 6/6 wrote the file and named the JSON format, held-out 12/13 in 6/6 as before, 0.78 USD a trial against 0.62–0.69. One thing to watch: the AC-3 against AC-5 conflict was a line in `disputed.md` in 4/4 before and in 4/6 after; in the other two it was in the reply or in `decisions.md`, so still in front of the owner, but not as `DISPUTED`. A sentence sending conflicts to `disputed.md` left it at 4/6 and was removed. Checked with more trials (owner asked): the skill as it was before the walk, 8 more trials, 6/8, so 10/12 before against 8/12 after. The walk is not the cause: the earlier skill drops it too. In every miss the builder did not see a conflict but a reading ("not reserved" means "never reserved", so a repeat release is quiet and an unknown id raises). What the walk changes is where that reading lands: after it, 4/4 misses wrote the reading as a line in `decisions.md`, which `ship` puts on the page; before it, 1 of 2 misses said nothing anywhere. 10.35 USD for the 14 trials. 16.19 USD for 18 trials, six of them unusable (see the runbook: a workspace under a directory named like a secret store is refused writes).
- `scripts/verify.sh` is verified by `evals/verify-fixtures/run.sh`, no agent: pass, fail, an edited check (the base version is run), a check already green at the base, uncommitted changes (refuses), a dispute (shown, not a pass). 7/7.
- What this does not show: the failures this case copies were seen in builds of 51 criteria taking 30 minutes and more. A six-criterion unit does not reproduce them, as small fixtures did not reproduce review misses. Whether the reds appear with unit size is not measured.

# Results — ship

2026-09-20. Two cases, opus, 6 runs an arm. The workspace holds `brief.md`, `verdict.md`, `review.md` and the builder's optimistic `build-notes.md`; the task is the pull request description for the approver. `ship-exceptions` has one of each thing that is not green (FAIL, DISPUTED, UNVERIFIED, a PASS green before the change, a PASS whose check was edited, two review findings, a review that was not independent); `ship-all-green` has none.

| | bare | skill v1 (rows only) | skill v2 (below) |
|---|---|---|---|
| every thing that is not green is on the page | 6/6 | 6/6 | 6/6 |
| repeats "all pass" or "ready to merge" from the builder's notes | 0/6 | 0/6 | 0/6 |
| words, `ship-exceptions` | ≈750 | ≈340 | 530–610 |
| words, `ship-all-green` | ≈450 | ≈107 | 126–145 |

- Nothing is red on outcome or honesty: bare lists every exception and does not repeat the builder's claim. What the skill changes is volume and shape. Bare is not wrong, it is long, and its length does not shrink when there is nothing to decide.
- v1 to v2 follows the owner's rulings, not a red case: the approver no longer holds the brief in mind, so each row carries the criterion copied whole; each row gives options with one marked; the page opens with a list (recommendation, result, range, decisions needed, review independence) instead of a sentence; a follow-up is `required` only when leaving the row would be silent, leave state outside the diff, or change what a reader outside the diff sees, and those rows are repeated in `log.md` as `FOLLOW-UP`.
- v2, 16 graders, 6/6 each, outputs read. The follow-up tag was the same in 6/6 runs for six of eight rows, and in 5/6 for the other two (the edited check, the unvalidated CLI argument). A line from `decisions.md` gets a row and does not enter the recommendation, 6/6.
- A first wording that asked the row to "name which" of the three conditions produced a sentence per row (540–610 words); fixed tags (`required: silent | state | reader`) brought nothing down in words but made the column comparable across runs. The words are in the copied criteria and the options.
- Not in the parts and still written in 5/6 runs: a title line above the goal. Harmless; left.
- Not measured: whether a reader without the brief decides correctly from the page. That needs a reader, not a regex. 7.3 USD for v1 and bare, 6.58 USD for v2.

# Results — brief

2026-09-20. `evals/brief-reservations/run.sh`, a driver like the build one. The workspace is the base inventory repo and `request.md`: the owner's words, the interface, the data model, four stated facts, and six things left open on purpose (the boundary at exactly ten minutes, a release of an unknown id, a repeated `order_id`, `load` of a missing path, the file format, a release after expiry). The agent writes `brief.md` and `checks/` and builds nothing. `grade.py` runs the brief's own checks three ways: on the untouched repo (each must fail), on a reference implementation under whichever reading of the open points suits the checks best (each must pass, which also shows the criteria do not contradict one another), and on ten copies of the reference with one planted defect each (at least one check must fail). opus, 6 trials.

| | bare | skill, first text | plus "a decision gets a criterion only when…" |
|---|---|---|---|
| criteria with a check command | 6/6 | 6/6 | 6/6 |
| checks red before the work | 6/6 | 6/6 | 6/6 |
| planted defects caught, of 60 | 59 | 59 | 60 |
| briefs with a section listing the decisions taken | 6/6, 6–8 lines each | 6/6, 9–13 | 6/6 |
| criteria, mean (range) | 11.3 (9–14) | 13.2 (12–15) | 11.8 (9–14) |
| words in `brief.md`, mean | 930 | 968 | 930 |
| lines of check code, mean | 356 | 235 | 200 |
| USD a trial | 0.92 | 0.77 | 0.84 |

- Nothing is red on the bare arm. It writes a runnable check for every criterion, the checks are red first and thick enough to catch every planted defect but one, and it lists what it decided for the owner without being asked. The one miss: a brief that said of a repeated `order_id` "no check covers it; pick whatever is simplest", which hands a silent-corruption choice to the builder.
- What stands out is volume: 9–14 criteria and about 900 words for a request that a hand-written brief covers in 6 criteria and 300 words. Two texts aimed at it did nothing. A `From` column (each criterion names the request or a decision id, otherwise it does not enter): criteria went up, not down, because a decision line admits any criterion. A sentence giving a decision its own criterion only when getting it wrong is silent, leaves state outside the unit, or is seen outside it: 11.8 against 11.3 bare. No Δ; the sentence was removed. The `From` column stays as page format, unmeasured: it shows the signer which criteria the agent added.
- So the `brief` skill is an interface, as `build` and `ship` are: the file `scripts/verify.sh` reads (frontmatter, `AC-n` ids, `Where`), checks run red before hand-over, the decisions and the three kinds of thing that outlive the unit listed for the signer, and the status left at `draft` until the owner says accepted. A first end-to-end pass found the seam it is there for: bare and first-text briefs number criteria `AC1`, which `verify.sh` does not read.
- A first batch of six bare trials (6.05 USD) is not in the table: the request did not fix what `reserved` returns, every brief chose its own data model, and no reference implementation could run their checks. Those briefs also widened the scope (several holds per order, each with its own clock). The request now fixes the data model.
- Not measured: an interview before the brief (this case is one-shot: what is unclear becomes a decision to confirm, not a question); whether the signer reads 900 words; a larger request. 21.24 USD for the 24 trials.

# One unit end to end

2026-09-20, one pass, opus, each stage a fresh headless session with the plugin, in one tree: `brief` wrote the brief from `request.md` (the owner's acceptance was done by hand: status, commit, tag) → `build`: 12/12 PASS from `verify.sh`, three lines in `decisions.md` → `review`: independent, one finding, a silent one (a non-string `order_id` does not survive `save` and `load`, so the hold becomes unreadable while its stock stays subtracted) → `ship`: "12 of 12 PASS", recommendation "do not merge yet" naming the finding, one row per decision. 1.40 USD for build, review and ship. One pass shows the stages read each other's files; it is not a measurement. It led to one change: a decision whose marked option is "accept" was written to `log.md` as a `FOLLOW-UP`; decisions no longer are (ship case re-run, 17 graders 6/6, 1.92 USD).

After the `log.md` line gained its three counts: ship case re-run, 18 graders 6/6, 1.88 USD.

# Results — intent

2026-09-20. `evals/intent-low-stock/run.sh`: two agents take turns, at most six owner replies. The agent under test (opus) has the repo and the owner's first message; an agent playing the owner (sonnet) has `owner.md`: six load-bearing facts and an answer policy (answer only what is asked; outside the list "not decided, use your judgement"; asked to confirm a document, "looks fine" unless a line contradicts a fact). Two of the facts are of kinds the earlier stages do not have. Territory: the first message assumes a `report` command that is not in the repo. Scale: two more alert channels are coming next quarter and there is budget to make adding them cheap, which the owner says only when asked what comes next, about other channels, or how far the design should go. Every transcript was read.

| 6 trials an arm | bare | `intent` skill |
|---|---|---|
| the four behaviour facts asked about and carried into `epic.md` | 6/6 | 6/6 |
| the missing `report` command raised, unasked | 6/6 | 6/6 |
| asked what the owner expects to ask for next | 0/6 | 6/6 |
| structural options put to the owner | 0/6 | 6/6 |
| the coming channels reached `epic.md` | 0/6 | 5/6 |
| owner replies; questions | 1; 9–15 | 2; 8–11 |
| words in `epic.md`; units | 1,312–2,033; 6–8 | 814–997; 4 |
| USD a trial | 0.35–0.56 | 0.45–0.50 |

- The bare arm is good at what the earlier stages were good at: it reads the repo first, finds the false belief, finds unasked that stock does not survive the process (so "notify once" has no memory), asks the behaviour questions in one round and offers a default with each. What it never does is ask how far to go. No trial offered a structural option, none learned of the coming channels, and one wrote "no email, no Slack" under out of scope: the opposite of what the owner intends, decided for them and never shown as a decision. This is the first stage that is red, bare, on the outcome measure.
- With the skill the second round is one question with rungs. In 5/6 the owner named the channels, the agent marked the second rung and said what it makes cheaper, and the choice became a requirement ("adding a channel touches one new module and its configuration"). The third rung was declined in writing each time, with the reason. The sixth trial is a fault of the owner agent, not of the agent under test: asked what comes next it answered "nothing I can think of", because `owner.md` said "if nobody raises it you will not think of it". The wording is fixed. That trial also shows the gate doing its work: with "nothing" as the answer, the larger rung was not offered.
- `epic.md` is shorter with the fixed parts, and the unit count falls from 6–8 to 4. No sentence was aimed at either.
- In 2/6 skill trials the environment variable was not asked by name; both wrote "the URL comes from an environment variable" as a numbered decision, so it is a stated assumption, not a silent one.
- Two loose patterns scored wrong before the transcripts were read: "no email" and "worth one email" counted as carrying the scale fact; "Rung" was not counted as an option. Both fixed.
- Not measured: a second scenario (one is not a pattern); an owner who answers badly or changes their mind; whether the requirement written for the rung is one a brief can turn into a check (the end-to-end pass used a brief written from a request, not from an `epic.md`). 5.9 USD for 13 trials.

# Results — project memory

2026-09-20. The question: does a second epic need anything beyond the code and the first epic's files, and if so what. `evals/intent-second-epic/` is the intent driver on a repo where a first epic has shipped. Three things were settled with the owner then and cannot be read from the code: more channels are coming and the restructuring was put off until the second one; no long-running process is allowed on the hosts; the hosts reach the outside only over HTTPS, so SMTP cannot work. `RECORDS` sets what earlier epics left behind. The `intent` skill had no sentence about `.whetstone/` in any of these runs. opus, every transcript read.

| what earlier epics left | n | knew SMTP was closed before asking | `epic.md` assumes SMTP or a long-running process |
|---|---|---|---|
| code only | 3 | 0/3 | 2/3 |
| the first epic's `epic.md` | 6 | 5/6 | 0/6 |
| that, and a memory page | 6 | 6/6 | 0/6 |

- With one earlier epic the agent finds and uses its `epic.md` unprompted; a memory page adds nothing that can be measured (5/6 against 6/6). The one miss asked the owner again; it did not assume.
- Then an older, retired epic was added whose decision ("mail goes through the SMTP relay, which the hosts can reach") the later one overtook. With both `epic.md` files, and with a memory page that did not name the relay: 12/12 saw the two records disagree and asked the owner to settle what had been settled; in at least 8/12 the answer they would take by default was the overtaken one; one proposed to correct the memory page to fit the old record. A paragraph in `intent` saying which record holds (a page over an epic, a later epic over an earlier) changed nothing: 6/6 still asked, and it is not in the skill. Part of this was the fixture: "reach the outside only over HTTPS" does not plainly cover an internal relay, so asking was the honest move.
- With the page as an integrating ship would leave it (the statement rewritten where it stands to name the relay), and no sentence in `intent`: 4/4 treated SMTP as closed and asked only the new question, which mail service to use. The same without an "(overtakes …)" marker on the statement: 4/4. The marker is not needed and is not in the skill.
- So what a later epic needs is not a rule for reading records but a record with the disagreement already taken out. That is the write side. `ship` now has a memory walk: the `D-n` this unit makes true and the lines of `decisions.md`, three entry questions (a later author must know it; the code does not show it; no statement covers it), an overtaken statement rewritten where it stands, each change a row on the ship page. `evals/ship-memory/`, 6 graders: 6/6 three times running after the last edit; across the first two batches 11/12 wrote the "no long-running process" constraint. Read in the outputs: the rewritten statement, the new one, the path from the environment variable not copied, a row for each change.
- The loop closed once with nothing hand-written in it: a page written by a run of `ship` was put into the second-epic repo, and `intent` used it, 4/4.
- Two things the edits taught. The memory part sat between the description and the log, and in a case with no `epic.md` one run in six stopped before `log.md`, where 30 earlier runs had written it; the log part now comes first and the memory part says when it applies. And "(overtakes …)" in the source made the source drift (`from: low-stock` without the `D-3`, 2/6); a plain source does not.
- Seen and not acted on: runs open a new page by topic (`warehouse-hosts.md`, `store-format.md`) where an existing page has the same `scope`. Reasonable by `about:`, and it is how the number of pages grows.
- Not measured: a bare arm for the memory walk (a session without the plugin does not know the directory exists, so it would show nothing); deleting; a page whose check fails; more than a handful of pages; `brief` and `review` reading the pages. 22.2 USD for the 39 intent trials, 20.2 USD for the ship runs.

# The seam between `epic.md` and `brief`

2026-09-20. An `epic.md` written by a run of `intent` (accepted by hand) was handed to `brief`: "write the brief for its unit U2", which covers the requirement the owner's chosen rung became ("adding a second channel touches only a new channel module and one line of the registry"). Two trials, then two more after the fixes; not a measurement.

- The rung survives the seam as a check that can be run. One brief: writing `second.py` and one line of `__init__.py` gets the new channel its alert, with `api.py`, `alerts.py` and `cli.py` byte-for-byte unchanged. The other: the core modules contain no channel's name. Neither asked again what the epic had answered. This is what "no cap on briefs, the rung is a requirement" rests on.
- Three seams showed and are fixed in `brief`. The brief's place and the `checks:` path differed between the two trials, and one `checks:` was relative, which `verify.sh` cannot find: the place is now `.whetstone/epics/<epic>/units/<unit>/`, `checks:` is a path from the repo root, and the base tag is `<unit>-accepted`. `From` said `request` where an epic existed: it names the `REQ-n`. The brief numbered its decisions `D-n`, as the epic does, so a source could not tell them apart: they are `B-n`, and `ship` walks them for the memory too.
- After the fixes both trials wrote to the same place, `verify.sh` read both briefs and every criterion was red with nothing built (7 and 8). `brief-reservations`, 4 trials: red first 4/4, planted defects 40/40.
- The memory walk lost a decision without saying so: "no long-running process" was not written in 3/6 of one batch (26/30 over all batches before the fix), and the page said nothing of it. The second entry question, "it cannot be read from the code", was the cause: the fixture's code has a comment about retrying at the next run, and readers differed on whether that shows the decision. The question now names what code cannot say (that a thing is forbidden, a fact about something outside the repo, a reason), and the candidates that did not enter are named in one line with the question each failed. After it: the decision written 6/6, the rejected candidates named 6/6 (read), `ship-exceptions` 6/6. A grader written for that line failed 6/6 on correct outputs because `(?i)` inside a pattern is not honoured; the flag goes in `flags:`. 5.75 USD for the four seam trials, 3.5 for the brief regression, 10.7 for the ship runs.

# One unit end to end on the `.whetstone/` layout

2026-09-20, one pass, every stage a fresh session with the plugin, every input written by the stage before it: the `epic.md` from a run of `intent`, the brief for U2 from `brief` (both accepted by hand), then `build` → `review` → `ship` in one tree. Not a measurement; it shows the stages read each other's files where they now live.

- `build`: `scripts/verify.sh` ran against `.whetstone/epics/low-stock/units/u2/brief.md`, 7/7 PASS; `verdict.md` and `decisions.md` (5 lines: the store's shape, two names callable from outside) beside the brief; nothing disputed. 1.30 USD.
- `review`: independent; one finding, a silent one: a truncated or empty store file is taken for a first run, so stock, thresholds and waiting alerts are gone and the CLI exits 0. 1.02 USD.
- `ship`: "7 of 7 PASS", "do not merge yet" naming the finding; `.whetstone/memory/alerting.md` written with six constraints, most carrying as their check one of this unit's own checks, and one fact from the owner (the channels coming next quarter, from the epic's D-7); the candidates that did not enter named with the question each failed; five rows for the builder's decisions. 0.71 USD.
- What it costs the approver: twelve rows on a unit where every criterion passed. The first unit in a new area writes many constraints at once. Noted; not acted on before a real project shows whether it is read.
- The log's place was not stated and this pass chose `.whetstone/log.md`. A first wording ("there, or at the root when the repo has no `.whetstone/`") was read two ways: `ship-exceptions` fell to 3/6 on its three log graders because half the runs made the directory. It is now `.whetstone/log.md` without a condition, the graders look there, and the case is back to 6/6 (`ship-memory` 6/6). 7.6 USD for the three ship runs.

# The retrospective, run once by an agent that had not seen it

2026-09-20. `evals/RETRO.md` was given to a fresh session with no plugin, on the tree the end-to-end pass left, with two reports made up for the owner: "I learned after the merge that alerts only go out when someone runs the CLI; I assumed a timer", and "the store file came back empty after a disk-full and every threshold was gone with no error". It wrote `retro.md` in the three parts asked for. Counts: one row, every column filled from the files, `verify.sh` runs "not shown". Events: none, and both reports placed correctly: the first was the epic's D-4, accepted by the owner; the second was the review's finding, on the ship page, merged by the owner's choice (it checked the line was still unfixed at `HEAD`). Nothing found: the four promises named, each with what was looked at. So the procedure can be followed without its authors. What the first report does show, a decision that was on a page and not taken in, is now carried to the length entries of the backlog with the page's size. 1.09 USD.

# Does `review` have to be told to read the memory pages

2026-09-20. A change that works and that nothing in its diff argues against: email alerts sent with `smtplib` through the corporate relay. The one thing against it is a statement on a memory page (the hosts reach the outside over HTTPS only). The `review` skill says nothing of `.whetstone/`. opus, 6 runs an arm, every review read.

| | bare | `review` skill |
|---|---|---|
| the broken constraint reported, citing what the page says | 6/6 | 6/6 |
| findings | 3–6 | 1–2 |

Nothing to wire: both arms read the page unprompted. The skill's arm reports it in one or two findings where bare reports three to six, which is the volume Δ already recorded. The case is not kept in `evals/`: it is green bare, so it is no rule case, and the two smoke places of `review` are taken; it is restorable from the private store. 4.82 USD. Two earlier attempts cost nothing and produced nothing: a fixture that replaced an empty slice (a 70,000-line diff), and a Bash grant, which the harness refuses on a machine whose Docker credential store holds a symbolic link. That refusal is a guard and was not worked around.

# Codex smoke test

2026-09-20, codex-cli 0.154.0, a throwaway `CODEX_HOME` that linked to the existing login. Scripts and prose are not measured here; this is the port check in `CLAUDE.md`.

- Install: `codex plugin marketplace add <repo>` and `codex plugin add whetstone@whetstone` succeeded; 0.1.0, five `SKILL.md` files in the plugin cache.
- One skill headless: `codex exec` with "use the whetstone review skill" on the `review-smoke-clean` fixture wrote `out/review.md` in the skill's format (frontmatter, `independent: true`, one finding per line). It reviewed the change itself, giving the skill's reason: the session wrote none of the diff.
- Fresh-agent dispatch: asked to write a change and then review it with the skill, Codex reported that it dispatched a fresh agent because the skill requires a reviewer who did not write the change, and wrote `clean`. That is the model's own account; no trace was inspected, so dispatch is reported, not confirmed.
- Observed, and nothing is tuned for it: on the fixture where the reference model answers `clean`, Codex reported one finding (a `%d` that silently truncates a fractional quantity `add` accepts), which the lens's second question does admit.

# Two entry points: the stages chained

2026-09-20. The owner's point: five commands for one unit, where the workflow this distils had two. Only three places need a person (accept the epic, accept the brief, approve the merge), so the stages between them can follow on. Measured before anything was wired: one request, "build, then review, then ship", in one session, 2 trials: the three skills were invoked in order, one reviewer agent was dispatched with nothing from the conversation in its prompt (read in the session transcripts), `independent: true`, 3.3 USD and about 13 minutes each, against 3.0 USD for the same three stages in separate sessions.

Wired, 0.1.1: `build` goes on to `review` and `ship` and stops at the ship page; `intent`, once the owner has accepted the epic, goes on to the first unit's `brief` and stops at its signing. `review.md` and `pr.md` have a place (beside the brief), and `epic.md` has one (`.whetstone/epics/<epic>/`), since no person names the files between stages any more.

| | result |
|---|---|
| `intent` asks "Do you accept this epic?" and sets `accepted` only on a yes | 6/6 |
| then writes the first unit's brief under `.whetstone/epics/<epic>/units/`, left at `draft`, untagged, unsigned | 6/6 |
| the coming channels still reach `epic.md` | 6/6 |
| `build` reaches the ship page, first wording ("unless the user asked for the build alone") | 2/4 |
| `build` reaches the ship page, second wording | 4/4 |
| told in words "build only, do not review, do not ship", `build` stops at the verdict | 2/2 |
| held-out tests, chained and not | 12–13 of 13, as before |

- The first wording failed the second sentence test: the driver's prompt says "build it and give me the verdict", and half the runs read that as the build alone. Now the continuation has no condition ("asking for the build or for the verdict does not end the work at the verdict") and one exception, the user's own words.
- Every chained build stopped at a ship page that said "do not merge yet" and named the planted disputes: the chain does not carry a unit past what should stop it.
- Cost: a chained build 1.7–2.0 USD against 0.8 alone; `intent` with the first brief 1.0–1.6 against 0.5.
- Regression, plugin arm: `ship-exceptions`, `ship-all-green`, `ship-memory` 6/6 each; `review-one-root-cause` 3/3. In the other four review cases every failing run is one where the skill did not fire from the plain request (`path-skill-fired`): 7 of 12 runs, where it used to be rare outside one case. Those runs behave as the bare arm does, which is what their other red graders show. With five skills listed the plain request is answered directly more often. The product path is not touched by it: `build` invokes `review` by name (6/6 chained runs), and a person types the command. It does make the plain-request review cases a weaker instrument; see the backlog entry. 38.7 USD for all of this.

# The review skill stopped firing from a plain request, and why

2026-09-20. The regression above showed it; the owner asked why it was being filed and not explained. It matters beyond the evals: a person who types "review my change" without the command gets the bare behaviour, and the three review rules with a measured Δ do nothing.

Same plain request, same model and harness, the two worst cases (`review-smoke-policy`, `review-policy-masks-defect`), runs in which the `review` skill was invoked:

| plugin contents | fired |
|---|---|
| five skills, the description as it was | 3/24 |
| the same, the other four skills removed | 18/24 |
| the commit where `review` was the only skill (same day, so not the environment) | 6/6 |
| five skills; "Use for every request to review …, also when the request names its own output file or format" | 20/24 |
| the same with the trigger words moved to the front | 20/24 |
| five skills; the first of those plus "invoke it before reading the diff" | 24/24 |

- The cause is dilution: with more skills listed, a task the model is confident it can do itself is done directly. A review is such a task. The description is the only lever before a skill fires, and saying when to invoke it, before the diff is read, closes the gap; the likely reason is that once the diff has been read the model sees no need for help, but that is inference.
- With the adopted description all five review cases: fired 15/15, and every behaviour grader passed in every fired run, 15/15. The description changed when the skill fires and nothing about what it does.
- Small samples misled three times on the way: 0/3 and 1/3 looked like a collapse, then 4/6, 5/6 and 6/6 could not be told apart; only twelve runs a cell separated the variants. The two cases had no `runs:` line, so an edit meant to raise it had changed nothing.
- Not measured: whether `intent`, `brief`, `build` and `ship` lose plain-request firing the same way. In every driver run so far they were invoked, but no case counts it. 39.7 USD.

