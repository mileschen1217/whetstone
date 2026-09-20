"""Reference implementation for grading a brief's checks. POLICY picks the reading of the things
the request leaves open; MUT plants one defect. Not shown to the agent under test."""
import json, os, time
P = set(filter(None, os.environ.get("POLICY", "").split(","))); M = os.environ.get("MUT", "")
_stock, _res, _gone = {}, {}, set()
def add(item, qty):
    if qty <= 0: raise ValueError("qty must be positive")
    _stock[item] = _stock.get(item, 0) + qty
def level(item): return _stock.get(item, 0)
def reset(): _stock.clear(); _res.clear(); _gone.clear()
def reserve(item, qty, order_id, at=None):
    if qty <= 0: raise ValueError("qty must be positive")
    if order_id in _res and M != "dup-overwrites": raise ValueError("order already reserved")
    if _stock.get(item, 0) < qty: raise LookupError(f"not enough {item}")
    if M != "reserve-keeps-level": _stock[item] -= qty
    if M != "reserve-not-recorded": _res[order_id] = [item, qty, time.time() if at is None else at]
    _gone.discard(order_id)
def reserved(order_id):
    if order_id in _res: return (_res[order_id][0], _res[order_id][1])
    if "reserved-raises" in P: raise KeyError(order_id)
    return None
def _give_back(order_id, stock=True):
    item, qty, _ = _res.pop(order_id); _gone.add(order_id)
    if stock: _stock[item] = _stock.get(item, 0) + qty
    return item, qty
_last = {}
def release(order_id):
    if order_id in _res:
        _last[order_id] = _res[order_id][:2]
        _give_back(order_id, stock=M != "release-keeps-stock"); return
    if order_id in _gone:
        if M == "repeat-raises": raise KeyError(order_id)
        if M == "repeat-credits-again": _stock[_last[order_id][0]] += _last[order_id][1]
        return
    if "unknown-silent" not in P: raise KeyError(order_id)
def expire(now):
    if M == "expire-nothing": return
    for oid in [o for o, r in _res.items() if (now - r[2] >= 600 if "edge-released" in P else now - r[2] > 600) or (M == "expire-young" and now - r[2] > 60)]:
        _last[oid] = _res[oid][:2]; _give_back(oid, stock=M != "expire-keeps-stock")
def save(path):
    with open(path, "w") as f: json.dump({"stock": _stock, "res": {} if M == "save-drops-holds" else _res, "gone": sorted(_gone)}, f)
def load(path):
    if not os.path.exists(path):
        if "load-missing-raises" in P: raise FileNotFoundError(path)
        return
    d = json.load(open(path)); reset(); _stock.update(d["stock"]); _res.update(d["res"]); _gone.update(d["gone"])
