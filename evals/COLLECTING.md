# Collecting eval cases from real history

Real history is where the cases come from. It is not what this repo publishes.

## Three homes

| Home | Holds | Leaves the machine |
|---|---|---|
| `evals/` in this repo | synthetic cases only | everything; it is public |
| `evals-private/` (gitignored; a clone of a private repo, or a plain local directory) | cases built from real code and records | nothing, or only to the private repo |
| a machine whose code may not be copied | cases built there, run there | numbers only: pass rate, finding count, cost per case |

Run a private suite with `--eval-dir evals-private`. The harness requires the eval directory to sit below the plugin, so the private directory lives here and is ignored by git.

## From a real case to a public one

1. **Mine** a candidate from history (sources below) and write its record.
2. **Build** the private case: fixture from the recorded commits, graders from the recorded oracle.
3. **Run** it bare. A case that passes 3/3 bare discriminates nothing; drop it.
4. **Abstract** a case that shows red: name the defect class in one line, with no project nouns.
5. **Rewrite** it as a synthetic case in `evals/` on the shared synthetic project.
6. **Confirm** the synthetic case shows the same red, bare. If it does not, the abstraction lost the difficulty; go back to 4.

Only steps 5 and 6 produce files in this repo.

## Where candidates come from

| Stage | Source | Fixture | Oracle |
|---|---|---|---|
| review | a fix commit and the commit that introduced the defect; a review record whose findings were later labelled real, rejected, or waived | the tree before the introducing commit, plus its diff | the lines the fix changed; the labels |
| build | a fix commit that came with tests; a held-out verdict that disagreed with the builder's claim | the tree before the fix, plus the issue text | the fix's tests, unseen by the builder |
| intent, brief | an interview record with the owner's corrections; a contract whose criteria count grew across review rounds | the task statement | the owner's facts and rulings, as a closed list |
| ship | a PR text, and what was later found to be unverified or failing at that time | the verdict and review as they stood | the items that were not green |

A ledger of misses that records, per entry, the stage that should have caught it is the best single source: each line is already a labelled candidate.

## Case record

One file per candidate, `record.md`, frontmatter only:

```yaml
stage: review            # intent | brief | build | review | ship
repo: EVAL_REPO_A        # a name defined in repos.env; never a path
base: <sha>              # tree the fixture starts from
head: <sha>              # the change under test
defect: one sentence, what was wrong
where: path:start-end    # as of head
found_by: who or which gate found it, and when
should_have: the stage that should have caught it
class: the defect class, no project nouns   # filled at step 4
```

The fixture script sources `repos.env`, a local file beside the private cases that maps each name to a repository location. The harness does not pass shell variables to fixture scripts, so the file is the only place a path appears. No record or script contains a local path, a person's name, or an address.

## What never enters `evals/`

Code, prose, identifiers, paths, or transcripts from a real project; raw reviewer or agent output; anything a reader could trace back to its source. The defect class and the shape of the difficulty are what cross over.
