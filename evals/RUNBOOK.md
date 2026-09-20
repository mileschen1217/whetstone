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
- The harness refuses any case that grants Bash on a machine whose Docker credential store holds a symbolic link. It is a guard: grant Bash only where the case needs it, and use a driver when it does. A result with cost 0 and no graders is an error, not a score: read `error` in the json.
- After a fixture that edits by string position, look at the size of the diff it makes before running anything.
- A case without a `runs:` line runs three times. Three runs do not separate 4/6 from 6/6: a firing rate, or any rate, is compared at twelve runs a cell.
- Adding a skill can stop another from firing. After a skill is added, count `path-skill-fired` on the cases of the others.
- A grader copied from another case is run once against an output known to pass before money is spent on it; and a count that needs the trace needs `--keep-temp`.
- A regex grader ignores an inline `(?i)`: put case-insensitivity in `flags:`. A grader that fails on every run is checked against the saved outputs before anything else is concluded.
- Two-agent trials started twelve at a time were killed by the system for lack of memory, all of them, with nothing to show. Four at a time ran. In zsh `for t in $batch` does not split `$batch`: check the directory names of the first batch before trusting the count.
- A headless session is refused file writes under a directory whose name looks like a secret store (`*-private`). Run driver workspaces in a temporary directory and copy the results afterwards. A trial that reports a refused write is not a data point.
- On a case-insensitive filesystem `review.md` is `REVIEW.md`. Cases write to `out/`.

## Recording

Every run that answers a question gets a line in `BASELINE.md`: what was asked, n, the number, the cost, what it does not show. A result that was wrong and then corrected stays in, with the correction.
