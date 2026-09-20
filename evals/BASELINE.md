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

