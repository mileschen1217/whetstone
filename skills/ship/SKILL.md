---
name: ship
description: Write the pull request description and the log line for a unit that has been built, verified and reviewed. Use when asked to ship a unit, open or describe its pull request, or summarise it for the person who approves the merge. The approver reads the rows that are not green, not the whole unit.
---

# ship

## Input

`brief.md`, the `verdict.md` that `scripts/verify.sh` wrote, `review.md`, and `disputed.md` and `decisions.md` when they exist. With no `verdict.md`: stop and say the unit has not been verified. Nothing else is a source: not the builder's notes, not this conversation.

## The description

These parts, in this order, and nothing else. The approver has not read the brief since signing it; every part stands without it.

1. `**Goal**:` and the goal, as the brief states it.
2. A list, one fact per line, no prose:
   - `Recommendation:` `merge`, or `do not merge yet` and the ids of the rows in part 3 that block it. A row blocks when its follow-up is `required` and it is not a decision. Left out when part 3 has no rows.
   - `Result:` the count of each verdict, as `<p> of <n> PASS · <k> FAIL · …`, zero counts left out.
   - `Range:` the base and head from the verdict.
   - `Decisions needed:` the number of rows in part 3. Left out when there are none.
   - `Review: not independent`, only when `review.md` says `independent: false`.
3. A table, one row for each thing that is not green, rows with follow-up `required` first. Not green is each of:
   - a verdict other than `PASS`;
   - a `PASS` whose note is not empty (green before the change, check file differs from base, from recorded evidence);
   - each finding in `review.md`;
   - each line of `decisions.md`.

   Columns:
   - **Item**: the criterion id and its verdict, the file and line of the finding, or `decision`.
   - **Text**: the criterion copied whole from the brief, or the finding or decision line copied whole.
   - **Evidence**: the output and note columns of the verdict, in their words. Empty for a finding or a decision.
   - **Options**: the two or three things the approver can do with this row, the one you would choose marked `★`.
   - **Follow-up**: `required: silent` when leaving the row as it is would carry on without an error and leave a wrong value or a lost record; `required: state` when it leaves state outside this diff; `required: reader` when it changes what a reader outside this diff sees. Otherwise `logged`. The tag and nothing after it.
4. One line: the ids of the criteria that are `PASS` with an empty note. No table for them.

Do not explain a row beyond its columns.

## The log

Append one line to `log.md`: the date, the unit, the head, `<p>/<n> PASS`, and the ids that are not green. Then one line for each row whose follow-up is `required`: `FOLLOW-UP`, the item, and the option marked `★`.
