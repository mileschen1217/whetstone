# Running an eval question to an answer

The rules are in `CLAUDE.md` and `README.md` here. This is the procedure that the rules do not give, with the mistake each step came from. Numbers are in `BASELINE.md`; decisions and their reasons are in `docs/adr/`.

## Before writing anything

1. **Find real material first.** Look for the failure in recorded history (review records, a held-out verdict that disagreed with a builder, a contract that grew). Two review probes and one build case designed from imagination were all green on the bare arm.
2. **Run the bare arm before writing a rule**, 6 runs, not 3. A red seen 1/3 did not reproduce at 13/14. No red, no rule: record the green baseline and stop.
3. **State what each planted item is evidence of**, in the fixture's header comment. A case whose plants cannot be named cannot be read afterwards.

## Measuring

4. **Pair every outcome grader with a volume grader** in the same case: what must be reported, and what must not be. A rule enters when the first rises and the second does not get worse.
5. **Read the outputs, every run, before believing a regex.** Twice a string match was wrong: a pattern with "same" matched an unrelated finding and scored 6/6 where the truth was 0/6; a review that named a file inside a different finding was counted as having found it. Keep outcome patterns to words only that finding would use.
6. **Count the runs where the skill did not fire apart.** They behave like the bare arm and dilute the with arm. `path-skill-fired` tells them apart.
7. **One factor per run.** When two things changed between a red and a green, run the ablation before saying which one did it. A fixture with a second difference (a function that reads the corrupted record) hid the real cause for one round.
8. **Test a sentence where the failure actually is.** A sentence was first tried on a fixture in which the defect had no consequence, and looked useless for the wrong reason.
9. **`--max-cost-usd` is checked before each launch only.** Set it below the ceiling, or lower `-j`.

## After changing a lens or a skill

10. Run that skill's cases, with arm only (`--ablation none`).
11. **Run the dispatch driver** (`review-self-vs-fresh/run.sh`, skill arm) after any rewrite of `lens/generic.md`. The harness cases start from an empty session and never take the dispatch path; a rewrite that passed all of them had taken the dispatched review from 6/6 to 2/6.
12. **An exclusion names the question it belongs to.** "An input that ends in a raised error is not a finding", written for the whole lens, cancelled a finding another question had admitted.

## Where the harness does not reach

- Multi-turn (a builder session, then its review): `claude -p --safe-mode`, then `--resume <id> --fork-session`. `--safe-mode` also disables plugins; the plugin arm uses `--setting-sources project --plugin-dir <repo>`.
- A built tree that has to be executed (`build-reservations`): the harness seals the workspaces it keeps. Use a driver and grade the tree directly. Do not unseal kept directories.
- A fixture script gets no shell environment variables from the harness.
- On a case-insensitive filesystem `review.md` is `REVIEW.md`. Cases write to `out/`.

## Recording

Every run that answers a question gets a line in `BASELINE.md`: what was asked, n, the number, the cost, what it does not show. A result that was wrong and then corrected stays in, with the correction.
