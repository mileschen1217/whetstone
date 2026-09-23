# The line

Every signed page (`epic.md`, `brief.md`, `pr.md`) has two parts. An item is above the line when both tests below hold; every other item is below it. Nothing is dropped.

## Boundary

The boundary is the system page under `.whetstone/memory/` when the project has one: its inside, its outside and its table of exchanges. Without one: for a brief or a ship page, the unit's diff; for an epic, the modules under Today. The other end of an exchange is the owner, a user, code outside the diff, a later epic, or a thing outside the repo (a host, a service, a program, a file).

## Two tests

1. Its tag is one of these three; otherwise it is `logged`:
   - `required: silent` when, left as it is, it would carry on without an error and leave a wrong value or a lost record;
   - `required: state` when it leaves state outside this diff;
   - `required: reader` when it changes what a reader outside this diff sees.
2. It fixes one cell of an exchange across the boundary: which end does it; what it carries (a number or a threshold; a name or a message a user sees); what is inside and outside; what happens when it is not there or fails. A verdict other than `PASS` and a finding fix the cell their criterion names. A module split, an internal file format and an algorithm fix no cell.

Both hold: above the line. Either fails: below it.

## The two parts

The heading `Needs the owner`, then the heading `Record`. The page's fact list carries `Decisions needed: <n>`, n the number of items under the first heading; with n = 0 the first part is the one word `none`. Each decision line (`D-n`, `B-n`) carries its tag in brackets, `[silent]`, `[state]`, `[reader]` or `[logged]`, at its end; in a brief the `[AC-n, …]` or `[no check]` that `brief` fixes follows the tag.
