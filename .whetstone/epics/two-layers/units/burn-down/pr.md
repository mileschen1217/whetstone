**Goal**: review 的修正之後由沒寫修正的讀者做 burn-down：每條 finding 判 closed 或 open，修正動到的函式裡的新缺陷報出來；先量，讀者對「關掉 finding 又帶進一個新缺陷」的修正判對 ≥ 5/6 才進 skill。

- Recommendation: do not merge yet — AC-2, .whetstone/epics/two-layers/units/burn-down/checks/ac5.sh:14
- Result: 7 of 8 PASS · 1 DISPUTED
- Range: 45e687d..63781cf
- Decisions needed: 2
- Boundary: none: a person or a thing outside the repo

## Needs the owner

### AC-2 DISPUTED (PASS) · required: reader
- 決定：REQ-9 review.md 之後 builder 先修 finding。每個修正 commit 由一位沒寫它的讀者讀，候選清單是 review.md 的 finding 與修正動到的函式，走完就停：每個 finding 判 closed／open，動到的函式裡的新缺陷回報為新 finding。修正若定了跨邊界交換的一格，builder 寫進 `decisions.md`，它依線落在 ship 頁線上。open 且關掉它不需要線上決定的退回 builder 一次、再讀一次；第二次仍 open、或關掉它需要線上決定的，在 ship 頁線上並擋 merge；closed 的在線下。派不出讀者時 ship 頁寫「修正沒有獨立讀過」，不擋。先量：讀者對「關掉 finding 並帶進一個新缺陷」的修正判對 ≥ 5/6，才進 skill。；B-2 讀者一次讀什麼？；B-5 沒過門檻怎麼辦？；B-6 進 skill 的字；B-7 讀者的指令放哪
- 註記：`reader text Δ` as the check counts it is +6 (the bare arm never writes the `- finding 1 (…) — closed —` and `- new: path:line` lines), while every bare output read by hand judges the finding closed and names the planted line, so the Δ measures the output form and not the candidate list or the two questions that B-5 keeps on Δ > 0; the code follows the brief and enters the whole text.
- 選項：
  - ★ 接受：依 B-5 的規則（check 算出的 Δ +6 > 0）15 行全文進入；BASELINE 與 disputed.md 已記明這個 Δ 是輸出格式，六份材料上兩臂的判斷都是 6 of 6
  - 只留輸出格式：`skills/build/burndown.md` 縮到格式段，候選清單與兩題拿掉（U2 的先例：沒有 Δ 的字不留），B-5 的規則改為依判斷 Δ，brief 重簽
  - 再量：另種六份材料，兩臂各讀一次（約 2 美元），以判斷 Δ 裁定
- 驗收條件：`evals/BASELINE.md` has `readers correct: k of 6`, `readers correct bare: j of 6`, `reader text Δ: <k−j, signed>` and `burn-down entered: yes` when and only when k ≥ 5, else `burn-down entered: no`; with `yes`: `skills/build/burndown.md` exists, 15 lines or fewer, names `closed`, `open`, `new:`, and with Δ > 0 also the two lens questions, with Δ ≤ 0 neither of them; `skills/build/SKILL.md` says the findings are fixed and committed, one fresh reader is dispatched with that text, the diff and review.md, an open finding goes back once, and no reader means `independent: false`; `skills/review/SKILL.md` says a burn-down is not a second round; `skills/ship/SKILL.md` reads burndown.md, makes a row of each `new:` line and writes `Fixes: not independently read` when it says `independent: false`; with `no`: none of these

### .whetstone/epics/two-layers/units/burn-down/checks/ac5.sh:14 · required: silent
- 發現：.whetstone/epics/two-layers/units/burn-down/checks/ac5.sh:14 — AC-5 (brief.md:100) says the three ship cases pass "every grader", and the `path-` exclusion was written for the review cases' "every result grader"; applied to every case in `want`, a ship run in which the skill did not fire (`path-skill-fired` false) still passes the check, so the recorded 18/18 "every grader" at evals/BASELINE.md:345 is not what the check decides.
- 選項：
  - ★ 接受 evidence 的手讀：path-skill-fired 在 ship 18 of 18、review 15 of 15、case 3 of 3 都通過（evidence/AC-5.log 第 5 行，從 run 的紀錄讀出），check 維持凍結，這條 finding 以 open 留在紀錄
  - 收緊 check：ac5.sh 第 14 行的 `path-` 跳過只套用在五個 review case，brief 以現在的 tag 為父重新接受，verify.sh 重跑

## Record

### AC-1 PASS · logged
- 決定：REQ-9 review.md 之後 builder 先修 finding。每個修正 commit 由一位沒寫它的讀者讀，候選清單是 review.md 的 finding 與修正動到的函式，走完就停：每個 finding 判 closed／open，動到的函式裡的新缺陷回報為新 finding。修正若定了跨邊界交換的一格，builder 寫進 `decisions.md`，它依線落在 ship 頁線上。open 且關掉它不需要線上決定的退回 builder 一次、再讀一次；第二次仍 open、或關掉它需要線上決定的，在 ship 頁線上並擋 merge；closed 的在線下。派不出讀者時 ship 頁寫「修正沒有獨立讀過」，不擋。先量：讀者對「關掉 finding 並帶進一個新缺陷」的修正判對 ≥ 5/6，才進 skill。；B-1 用什麼量讀者判不判得對？
- 選項：
  - ★ 接受：verdict 來自 evidence/AC-1.log（check 在私有材料上跑出 readers correct: 6 of 6、bare 0 of 6）
  - 在本機以 TWO_LAYERS_MATERIAL 重跑 ac1.sh 一次再接受
- 驗收條件：Six materials under `burndown/m1..m6`, each with `grade.json` saying the finding is closed and the new defect present; one fresh read per material through `skills/build/burndown.md`; in 5 or more of 6 the reader's `burndown.md` marks finding 1 `closed` and has a `new:` line naming the planted file within 5 lines of the planted line; the bare arm: one fresh read per material with the one-sentence request, its `burndown.md` and `result.json` under `m<i>/bare/`, counted the same way; cost per read recorded on both arms

### AC-5 PASS · logged
- 決定：REQ-10 改到的 skill 的既有 eval case 全綠。；B-10 回歸
- 選項：
  - ★ 接受：verdict 來自 evidence/AC-5.log（ship 與 review 在 5c3594f 跑、文字其後未變；build 兩個 trial 在最終文字 dbc85a3 重跑）
  - 要求 ship 與 review 也在 dbc85a3 重跑（約 6 美元）再接受
- 驗收條件：`ship-exceptions`, `ship-all-green`, `ship-memory` 6 runs each, every grader; the five review cases with the skill, 3 runs each, every result grader; `build-reservations` skill arm 2 trials, each with `heldout_passed` ≥ 12 of 13, no `false_green`, `checks_edited` empty

### AC-7 PASS · logged
- 決定：B-8 公開 case
- 選項：
  - ★ 接受：verdict 來自 evidence/AC-7.log（build-burndown 在最終文字上 3 of 3）
  - 在本機重跑一次 case 再接受
- 驗收條件：`build-burndown` with the skill, 3 of 3 runs pass every grader

### skills/build/SKILL.md:36 · logged
- 發現：skills/build/SKILL.md:36 — the go-back sends "one more fresh reader on the new diff", and `burndown.md` (line 8) has that reader write `burndown.md` beside `review.md`, the same file the first reader wrote; a `new:` line of the first read is not fixed in the go-back (the same line says it is a row for the ship page, not a second review), so when the second reader walks only the functions the new diff touched, its file replaces the first and the first read's `new:` lines are gone; `skills/ship/SKILL.md:30` makes rows from `burndown.md` only, so the ship page never carries them and nothing errors.
- 選項：
  - ★ 接受：burndown.md 第二讀判 closed（第二位讀者的清單改為 review.md 之後全部修正動到的函式）
  - 再派一位讀者讀 dbc85a3

### skills/build/SKILL.md:10 · logged
- 發現：skills/build/SKILL.md:10 — a burn-down alone is routed to the part at line 36 and nothing else, but that part opens with "fix each finding … commit the fixes; run `scripts/verify.sh` again": the caller `evals/build-burndown/prompt.md` hands a tree with the fixes already applied, no git repository and no `brief.md`, on which none of those three can be done, and the text does not say they are skipped; the 3 of 3 in `evals/BASELINE.md:346` came from readers that skipped them on their own.
- 選項：
  - ★ 接受：burndown.md 兩次讀都判 closed（Input 行改為單獨 burn-down 時跳過修正、commit、verify；case 在修後文字 3 of 3 加讀者自己跑的 1 of 1）
  - 再派一位讀者讀 dbc85a3

### memory · logged
- 陳述：- The six planted fix materials (`burndown/m1..m6`, with `_mk.sh`, `reader.md` and `read.sh`), their twelve reads and the harness runs of unit `burn-down` (`runs-burn-down/harness-run-1`, `harness-run-2`) live outside the public repo under the `TWO_LAYERS_MATERIAL` root; the AC-5 evidence is `SHIP_RUN=runs-burn-down/harness-run-1/ship-merged`, `REVIEW_RUN=runs-burn-down/harness-run-1/review`, `BUILD_RUN=runs-burn-down/harness-run-2/build`, the AC-7 evidence `CASE_RUN=runs-burn-down/harness-run-2/case`; without them AC-1, AC-5 and AC-7 of that unit are UNVERIFIED. check: `grep -q TWO_LAYERS_MATERIAL evals-private/repos.env`. from: two-layers burn-down B-1
- 選項：
  - ★ accept
  - drop

Candidates that did not enter: D-6, D-9, D-14, B-2, B-3, B-4, B-6, B-7, B-8, B-10 (what they fix is read from the skills, line.md and the case: the second question); B-5 with D-8's entry on measurement (covered by the first constraint on plugin-rules.md: the third question); B-9 (covered by release.md: the third question); the reader text's Δ being the output form and not the judgement (AC-2 is disputed and the owner has not ruled: not yet a fact to record).

AC-3, AC-4, AC-6, AC-8
