# The line

Every signed page (`epic.md`, `brief.md`, `pr.md`) has two parts. An item is above the line when both tests below hold; every other item is below it. Nothing is dropped.

## Boundary

The boundary is the system's boundary toward what is outside it. It is read from the system page under .whetstone/memory/ when the project has one; otherwise from the Outside: line of the accepted epic.md, the last line of its Today, which the owner ruled on; an epic.md without that line counts as no page. A system page is a memory page whose `about:` names the system and which lists its inside, its outside and its exchanges; code in this repo, another unit and a later epic are inside the boundary. And with neither page, the other end of an exchange is a person or a thing outside the repo, and the page says which it took (the ship page's `Boundary:` line).

## Two tests

1. Its tag is one of these three; otherwise it is `logged`:
   - `required: silent` when, left as it is, it would carry on without an error and leave a wrong value or a lost record;
   - `required: state` when it leaves state outside this diff;
   - `required: reader` when it changes what a reader outside this diff sees.
2. It fixes one cell of an exchange across the boundary: which end does it; what it carries (a number or a threshold; a name or a message a user sees); what is inside and outside; what happens when it is not there or fails. A verdict other than `PASS` and an open finding fix the cell their criterion names; a finding whose fix is already in the range is `logged`. A module split, an algorithm, and a format or a name that only code inside the boundary reads fixes no cell; a format, a reply or a protocol between programs fixes no cell by itself, while what a program does when the thing at its other end is absent or fails is the fourth cell; what must hold across units inside the boundary is a rule in the project's REVIEW.md or a constraint on a memory page, walked by the reviewer; it is not a row for the owner.

Both hold: above the line. Either fails: below it.

## The two parts

The heading `Needs the owner`, then the heading `Record`. The page's fact list carries `Decisions needed: <n>`, n the number of items under the first heading; with n = 0 the first part is the one word `none`. Each decision line (`D-n`, `B-n`) carries its tag in brackets, `[silent]`, `[state]`, `[reader]` or `[logged]`, at its end; in a brief the `[AC-n, …]` or `[no check]` that `brief` fixes follows the tag.
