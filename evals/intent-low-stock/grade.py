"""Grade one intent trial from the transcript and epic.md. For each owner fact: did the owner
release it (so a question reached it), and is it in epic.md. A load-bearing fact that is in neither
was decided for the owner or not seen at all. Patterns are loose on purpose: read the transcript
before trusting a cell."""
import glob, json, os, re, sys

out = sys.argv[1]
epic = open(f"{out}/work/epic.md").read() if os.path.exists(f"{out}/work/epic.md") else ""
tr = open(f"{out}/transcript.md").read() if os.path.exists(f"{out}/transcript.md") else ""
dev = "\n".join(re.findall(r"(?s)## developer \d+\n(.*?)(?=\n## |\Z)", tr))
own = "\n".join(re.findall(r"(?s)## owner \d+\n(.*?)(?=\n## |\Z)", tr))
FACTS = {  # fact: (pattern in the owner's replies = released, pattern in epic.md = carried)
    "F1 threshold per item, default 5": (r"per item|each item|own threshold", r"per[- ]item|each item|own threshold|item'?s threshold"),
    "F2 tell purchasing once, on crossing": (r"\bonce\b|duplicate", r"\bonce\b|cross|transition|duplicate|dedup|not again|re-?arm"),
    "F3 webhook down: reserve works, alert retried": (r"retr(y|ied)|still work|must still", r"retr(y|ied)|queue|outbox|not block|must not fail|still succeed"),
    "F4 two more channels coming (scale)": (r"email|sms", r"email|sms"),
    "F5 there is no report command (territory)": (r"then add (one|a)", r"(no|not|n't)[^.\n]{0,40}`?report`?|`?report`?[^.\n]{0,60}(does not exist|doesn't exist|missing|not exist|new command|to be added|must be added)"),
    "F6 webhook URL from PURCHASING_WEBHOOK": (r"PURCHASING_WEBHOOK", r"PURCHASING_WEBHOOK"),
}
facts = {k: {"released": bool(re.search(a, own, re.I)), "in_epic": bool(re.search(b, epic, re.I))} for k, (a, b) in FACTS.items()}
# "no email, no Slack" under out-of-scope is the opposite of carrying the fact: count only lines that do not negate it
facts["F4 two more channels coming (scale)"]["in_epic"] = any(re.search(r"(?i)email|sms", l) and not re.search(r"(?i)\bno\b|\bnot\b|out of scope|one email", l) for l in epic.splitlines())
turns = [json.load(open(f)) for f in sorted(glob.glob(f"{out}/turn*.json")) if os.path.getsize(f)]
print(json.dumps({
    "facts": facts,
    "neither": [k for k, v in facts.items() if not v["released"] and not v["in_epic"]],
    "report_absence_raised_by_developer": bool(re.search(r"(no|not|n't|isn't|without)[^.\n]{0,60}`?report`?|`?report`?[^.\n]{0,60}(does not exist|doesn't exist|not exist|missing|isn't there)", dev, re.I)),
    "structural_options_offered": bool(re.search(r"(?i)(option|approach|alternativ|rung)[^\n]{0,300}(interface|abstraction|plug|notifier|channel|layer|restructur|module)", dev)),
    "asked_what_comes_next": bool(re.search(r"(?i)(ask for|want|need|expect|plan|coming)[^\n?]{0,80}(next|later|after this|down the line|future)[^\n?]{0,80}\?", dev)),
    "owner_replies": len(re.findall(r"## owner \d+", tr)), "questions": dev.count("?"),
    "epic_written": bool(epic), "epic_words": len(epic.split()), "units": len(re.findall(r"(?im)^#+\s*(unit\s*\d|u-?\d)|^[-*|]?\s*\**U-?\d", epic)),
    "cost_usd": round(sum(t.get("total_cost_usd") or 0 for t in turns), 2),
}, indent=1))
