# Every review

Walk the functions the diff changes or adds, one at a time. For each, answer only:

1. Does something already in the repo or the brief contradict its behaviour: an acceptance criterion, a caller, a test, a data file? That no code path reaches it today is not a reason to answer no.
2. Is there an input on which it carries on without an error and leaves a wrong value or a lost record behind?

Then walk the rules in the project's `REVIEW.md`, one at a time: does the diff break this rule?

A "yes" is a finding. Nothing else is: not naming, formatting or style, not a design you would have chosen differently, not, under question 2, an input that ends in a raised error. A "yes" on one item does not answer any other item. When both walks are finished the review is finished; with no "yes" the result is `clean`, and `clean` is a correct review.

A defect and everything that follows from it are one finding. Name the line where the defect is; put the places it shows — a caller that inherits it, a test that cannot catch it — inside that same finding, not in findings of their own.
