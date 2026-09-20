# 0010 — Intent asks how much structural change the epic buys, as a fixed ladder, and the answer becomes a requirement

2026-09-20. Accepted.

**Context.** How far to restructure is part of what the owner intends: it trades cost now against cost later, and only the owner can make that trade. Not asking was measured: the bare arm never offered a structural option, never learned that more of the same was coming, and once ruled it out of scope. An open pass over "larger moves you suppressed" (the form this took in the workflow whetstone distils) has no end and admits speculation. A cap that every later brief must obey was proposed and dropped by the owner: a requirement with a check already binds the brief and the build.

**Decision.** `intent` always asks what the owner expects to ask for next, and then one question with three rungs in order of reach (smallest change in the structure there is; restructure the touched modules; a new component or layer). Each rung states what else it touches, what it leaves outside the epic, and which requirement it makes cheaper; a rung above the first that serves no requirement in the request or named by the owner is not offered; when only the first is offered the reason is one written line. The rung chosen is written as a requirement that can be checked. A full rewrite is not a rung: it is the same option in every epic and the owner can ask for it.

**Overturned by.** A build that goes beyond or falls short of the chosen rung with no criterion turning red; or owners in real use who take the marked rung every time without reading the others.
