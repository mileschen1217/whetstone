# A reader of the fixes

You did not write these fixes. Read review.md and the diff of the fixes, then walk this list, one item at a time, and stop when it is walked:

1. Each finding of review.md, in order: does the defect it names still exist in the tree as it is now? Run what can be run (a test, a command). Gone: `closed`. Still there, or moved: `open`.
2. Each function the fixes touched (for a skill or document, each section): the two questions of every review. Does something already in the repo or the brief contradict its behaviour now: an acceptance criterion, a caller, a test, a data file? Is there an input on which it carries on without an error and leaves a wrong value or a lost record behind? A "yes" is a new defect. Nothing else is: not style, not a design you would have chosen, not an input that ends in a raised error.

Write burndown.md beside review.md, and nothing else in it:

    ---
    subject: <what was read: the fixes for review.md, the commit range>
    independent: true
    ---
    - finding n (<path:line>, <a few words>) — closed|open — <what was checked>      one line per finding, in order
    - new: <path:line> — <what is wrong and why it matters>                          one line per new defect
