2026-09-24 · two-layers/line · 8aeff75 · 8/9 PASS · not green: AC-6 · disputed 1 · green-before 0 · decisions 1
FOLLOW-UP · AC-6 DISPUTED (FAIL) · 接受兩張表的格式，REQ-6 只留 prose 那一半，行數那一半撤回
FOLLOW-UP · skills/ship/SKILL.md:25 · 同 AC-6 那一列的裁決
FOLLOW-UP · AC-7 PASS · 接受這個 unit，並在 U2 之前開一個 unit boundary：line.md 第二題的邊界改為系統對人的邊界，重量 REQ-7
2026-09-24 · two-layers/line · owner: AC-6 accept the two tables, REQ-6 keeps its prose half only · skills/ship/SKILL.md:25 same ruling · AC-7 a unit `boundary` before U2 (the line's second test uses the system's boundary toward people) · merge
2026-09-24 · two-layers/boundary · 44d5b72 · 6/8 PASS · not green: AC-1, AC-3, AC-6 · disputed 2 · green-before 0 · decisions 0
FOLLOW-UP · AC-3 DISPUTED (FAIL) · 接受 5 列（兩列「不在或已存在時怎麼辦」算 owner 的事，門檻改 5）
FOLLOW-UP · AC-1 DISPUTED (PASS) · 接受兩個子句與 Boundary: 行
FOLLOW-UP · skills/line.md:15 · 同 AC-3 的裁決
FOLLOW-UP · AC-6 UNVERIFIED · owner 讀 pr-boundary-1.md 線上 5 列後回答
2026-09-24 · two-layers/boundary · owner: AC-3 accept the 5 rows (the two absence-or-already-there rows are the owner's; threshold 5) · skills/line.md:15 same ruling, the fourth cell takes no across-the-boundary condition; its wording against test 2's first sentence is left for the next unit that edits line.md · AC-1 accept the two clauses and the Boundary: line
2026-09-24 · two-layers/boundary · owner: merge
2026-09-24 · two-layers/read-before-signing · 6ee3167 · 5/8 PASS · not green: AC-5, AC-6, AC-7 · disputed 1 · green-before 0 · decisions 0
FOLLOW-UP · AC-5 FAIL · 接受 FAIL：線的字照 B-3 留，停止再用字句收線；下一個槓桿是讓列的位置由 check 或計數決定，記進 BACKLOG
FOLLOW-UP · AC-6 FAIL · 接受 FAIL，epic 結束、U3 再改過 review 之後量一次（branch 與 main 各 6 次，約 2.5 USD）
FOLLOW-UP · AC-7 DISPUTED (PASS) · epic 結束的 PR 前裁一次：case 改 tag smoke，兩個 grader 留著，rule 依 D-8 以量測進場，README 加一個例外
FOLLOW-UP · evals/brief-read/prompt.md:6 · 同 AC-7 的裁決
2026-09-24 · two-layers/read-before-signing · owner: AC-5 and AC-6 not accepted, the unit does not merge with them red; keep looking for a better approach · a new unit in this epic: a FAIL row on the ship page is written back through AC → From → B-n/REQ-n so the owner reads the decision it serves, not the criterion's text (third occurrence of the Text-column entry in BACKLOG) · AC-7: options requested
2026-09-24 · two-layers/read-before-signing · 815adcc · 7/8 PASS · not green: AC-7 · disputed 1 · green-before 0 · decisions 0
FOLLOW-UP · AC-7 DISPUTED (PASS) · 先量 reader 這一步本身的 Δ（brief 那邊加 mutant，有／沒有 review 步驟各 3 次，約 5 美元）再裁 tag 與 README
2026-09-24 · two-layers/read-before-signing · owner: AC-5 option 1 (the two sentences stay, the 2-row target to the system-page epic), brief re-accepted at 8796fc8 · AC-6 cause confirmed in the smoke fixture, fixed · AC-7: the step's own measurement shows no Δ; the reader step, lens/brief.md, the brief subject of review and evals/brief-read retired; brief re-accepted at db7accc; the FOLLOW-UP lines above for AC-7 and evals/brief-read/prompt.md:6 are closed by this
2026-09-24 · two-layers/read-before-signing · c264eaf · 8/8 PASS · not green: skills/line.md:15 (open finding, CLAUDE.md rule against D-8) · disputed 0 · green-before 0 · decisions 0
FOLLOW-UP · skills/line.md:15 · CLAUDE.md 的規則句加 D-8 已簽的例外，由 owner 改
2026-09-24 · two-layers/read-before-signing · owner: skills/line.md:15 accepted as it is (no exception written into the plugin's rules file; the system-page epic comes next and the push to GitHub waits for it) · merge into the epic branch, per-epic merge
2026-09-25 · two-layers/written-back · a4ba53a · 7/7 PASS · not green: AC-1, AC-5, AC-6, AC-7 (green before the change: the brief was re-accepted three times after the build), AC-2, AC-3, AC-4 (from recorded evidence), five findings all closed (2a62853, 19945cb) · disputed 0 · green-before 4 · decisions 0
2026-09-25 · two-layers/written-back · owner: merge into the epic branch; all fourteen Record rows accepted as recommended (the four green-before rows as a consequence of re-signing after the build; the two memory statements enter)
2026-09-28 · two-layers/burn-down · 54c5cb2 · 7/8 PASS · not green: AC-2 (DISPUTED: judgement Δ 0, volume Δ +3, form Δ +6 on six planted fixes), AC-1, AC-5, AC-7 (from recorded evidence), three findings (skills/build/SKILL.md:36 and :10 closed at 1cec303 and dbc85a3; checks/ac5.sh:14 open after the second read, the check is frozen) · disputed 1 · green-before 0 · decisions 0
FOLLOW-UP · AC-2 DISPUTED (PASS) · ★ 接受，理由是量 Δ +3 與格式 Δ +6，判斷 Δ 0 如實記
FOLLOW-UP · .whetstone/epics/two-layers/units/burn-down/checks/ac5.sh:14 · ★ 接受 evidence 的手讀（path-skill-fired 36 of 36），check 維持凍結
2026-09-28 · two-layers/burn-down · owner: merge into the epic branch; AC-2 accepted on the volume and form Δ (judgement Δ 0 stands in BASELINE); checks/ac5.sh:14 accepted on the hand-read evidence, the check stays frozen, the finding stays open in the record; the seven Record rows as recommended (the memory statement enters)
2026-09-28 · two-layers/fix-walk · c353a8b · 5/6 PASS · not green: AC-1 (DISPUTED: the walk sentence sits before the commit, the brief's wording said after), AC-4, AC-5 (from recorded evidence), four findings all closed (f461b9b, 37a8f3b), two new: lines from the second read left in the record (the held-out helper and a defaulted parameter; an amended fixture commit) · disputed 1 · green-before 0 · decisions 0
FOLLOW-UP · AC-1 DISPUTED (PASS) · ★ 接受：句子逐字不變，放在 commit 之前
