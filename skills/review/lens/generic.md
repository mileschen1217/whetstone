# Every review

A finding is one of two things: behaviour that is wrong, or a rule in the project's `REVIEW.md` that is broken. Behaviour is wrong when something already in the repo or the brief contradicts it: an acceptance criterion, a caller, a test, a data file. That no code path reaches it today is not a reason to drop it. Naming, formatting, style, and a design you would have chosen differently are not findings. With neither kind present the result is `clean`, and `clean` is a correct review.

A defect and everything that follows from it are one finding. Name the line where the defect is; put the places it shows — a caller that inherits it, a test that cannot catch it — inside that same finding, not in findings of their own.
