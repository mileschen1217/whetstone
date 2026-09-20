"""Grade one second-epic trial. The three things settled in the first epic (P1 plan and the deferred
restructuring, P2 no long-running process, P3 only HTTPS out) should be neither asked again nor
assumed wrongly. Patterns are loose: read the transcript before trusting a cell."""
import glob, json, os, re, sys

out = sys.argv[1]
epic_path = next(iter(sorted(glob.glob(f"{out}/work/epic.md") + [p for p in glob.glob(f"{out}/work/.whetstone/epics/*/epic.md") if "low-stock" not in p or "email" in p])), None)
epic = open(epic_path).read() if epic_path else ""
tr = open(f"{out}/transcript.md").read() if os.path.exists(f"{out}/transcript.md") else ""
dev = "\n".join(re.findall(r"(?s)## developer \d+\n(.*?)(?=\n## |\Z)", tr))
own = "\n".join(re.findall(r"(?s)## owner \d+\n(.*?)(?=\n## |\Z)", tr))
lines = [l for l in epic.splitlines()]
def says(pat, neg=r"(?i)\bno\b|\bnot\b|never|cannot|can't|blocked|closed|instead of|rather than|not taken|rejected"):
    return [l.strip()[:160] for l in lines if re.search(pat, l) and not re.search(neg, l)]
turns = [json.load(open(f)) for f in sorted(glob.glob(f"{out}/turn*.json")) if os.path.getsize(f)]
print(json.dumps({
    "asked_again": len(re.findall(r"(?i)as i said last time", own)),
    "confirmed_known": len(re.findall(r"(?i)yes, still true", own)),
    "developer_cites_the_records": bool(re.search(r"(?i)\.whetstone|last epic|first epic|low-stock epic|D-[1-4]\b|previous epic", dev)),
    "epic_assumes_smtp": says(r"(?i)\bsmtp\b|smtplib"),
    "epic_assumes_long_running": says(r"(?i)daemon|cron|scheduler|background (process|worker|thread)|long-running"),
    "epic_carries": {"P1 sms planned": bool(re.search(r"(?i)\bsms\b", epic)), "P2 no long-running process": bool(re.search(r"(?i)long-running|next CLI run|background", epic)), "P3 https only": bool(re.search(r"(?i)https|proxy|mail (service|api)", epic))},
    "structural_options_offered": bool(re.search(r"(?i)rung|(option|approach)[^\n]{0,300}(notifier|channel|restructur)", dev)),
    "owner_replies": len(re.findall(r"## owner \d+", tr)), "questions": dev.count("?"),
    "epic_found": epic_path.replace(out, "") if epic_path else None, "epic_words": len(epic.split()),
    "cost_usd": round(sum(t.get("total_cost_usd") or 0 for t in turns), 2),
}, indent=1))
