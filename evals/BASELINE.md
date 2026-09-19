# Results — review

`claude plugin eval`, 3 runs per arm unless noted. A cell is runs passed / runs. reference = `opus`, observed = `sonnet` (measured, not tuned for). 2026-09-19. Failing runs were read, not only scored.

## With and without the skill

| Case | Tag | opus with | opus without | sonnet with | sonnet without |
|---|---|---|---|---|---|
| review-one-root-cause | rule | 3/3 | 1/3 | 3/3 | 1/3 |
| review-smoke-clean | smoke | 3/3 | 3/3 | 3/3 | 3/3 |
| review-smoke-policy | smoke | 3/3 | 3/3 | 3/3 | 3/3 |

- `review-one-root-cause`, opus: bare reports the paging defect as two or more findings in 2/3; with the skill, once in 3/3, and findings drop from 4–5 to 3. sonnet: bare returns one policy finding and misses both correctness defects in 2/3; with the skill all three defects in 3/3.
- Cost of the skill arm on opus: about 5 more turns and 0.05–0.12 USD more per review.

## What each sentence in the lens rests on

| Sentence | Evidence |
|---|---|
| one root cause is one finding | `review-one-root-cause`, table above |
| a finding is wrong behaviour or a broken project rule; style is not; `clean` is correct | the skill itself caused the failure: with the skill but without this sentence, opus reported style findings on `review-smoke-clean` in 5/6 runs (bare: 0/3). With the sentence: 6/6 `clean` |

The second row is a rule that repairs a regression the skill introduces, so its case is green on the bare arm by construction.

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
