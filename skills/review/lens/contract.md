# A contract (a spec or a brief)

For a contract these questions are the whole review; they replace the definition of a finding above.

Walk the requirements in document order, and under each its acceptance criteria, one at a time. Then walk the invariants, the non-goals and the declared interfaces. For each item answer only:

1. Does it name the same thing differently from the item it belongs to or cites — a different word, number, path, state or count?
2. Does every id, file, field and term it refers to exist in this document?
3. Does its pass condition admit two readings that one test cannot both satisfy?
4. Would the evidence it accepts also appear when the behaviour it names is absent?
5. For a requirement only: does each behaviour its sentence promises have at least one criterion?

A "yes" to 1, 3 or 4, or a "no" to 2 or 5, is a finding. Nothing else is: not a criterion you would add, not a mechanism you would design differently, not a value you would pin.

When the walk is finished the review is finished.
