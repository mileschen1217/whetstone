---
subject: the fixes for the findings of review.md, git diff 516d8f3..0a54008
independent: true
---
- finding 1 (skills/ship/SKILL.md:23) — closed — the line now reads "the number of rows under `Needs the owner` in part 3", which is the count line.md:21 ("items under the first heading"), the brief's Interface (brief.md:30) and shape.py:37-40 (`rows_under("Needs the owner")`) all fix.
- finding 2 (skills/line.md:21) — closed — the sentence now says the tag sits at the end and "in a brief the `[AC-n, …]` or `[no check]` that `brief` fixes follows the tag", which is the ending brief/SKILL.md:25 states and ac5.sh:15 tests (`[tag] [AC-…|no check]` at end of line); intent/SKILL.md:34 and ac9.sh:10 keep a D-n ending with its tag alone, which the sentence still says for an epic.
- finding 3 (skills/ship/SKILL.md:25) — open — the fix touched neither this line (two headings and a second table on every ship page stand as before) nor AC-6, which is still `DISPUTED (FAIL)` in verdict.md:14 and disputed.md:1, and no ruling exists at HEAD (no `owner.md` anywhere under .whetstone; decisions.md holds only the bullet-line format line).

new:
none
