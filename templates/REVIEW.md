# Review policy

<!-- Copy this file to the root of your project as REVIEW.md and replace the rules.
     The review skill hands it to the reviewer and walks it one rule at a time: "does the diff break this rule?"
     Whether the work is good is decided here and by the person who signs, not by the plugin.
     A rule is kept only if two readers would give the same answer for the same diff:
       a number or a name, not an adjective; something that can be seen in a diff.
     The lens and this file together may not pass 80 lines. -->

1. A change to the signature of a public function has a line in `CHANGELOG.md` in the same diff.
2. No bare `except:`.
3. No new third-party import without a line in `CHANGELOG.md`.
