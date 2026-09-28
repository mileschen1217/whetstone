---
unit: burn-down
status: accepted
base: burn-down-accepted
checks: .whetstone/epics/two-layers/units/burn-down/checks/
---

## Goal

review 的修正之後由沒寫修正的讀者做 burn-down：每條 finding 判 closed 或 open，修正動到的函式裡的新缺陷報出來；先量，讀者對「關掉 finding 又帶進一個新缺陷」的修正判對 ≥ 5/6 才進 skill。

## Done looks like

- 之後每個 unit 在 review.md 之後：builder 修 finding 並 commit，一位沒寫修正的讀者讀那一輪的修正，寫 burndown.md（每條 finding closed／open 加它查了什麼；動到的函式裡的新缺陷是 `new:` 行）；open 且關掉它不需要你決定的退回 builder 一次再讀一次；第二次仍 open、或關掉它需要你決定的，在 ship 頁線上、擋 merge；closed 的在 Record。派不出讀者時 ship 頁寫「Fixes: not independently read」，不擋。
- 你在 ship 頁線上只看仍 open 的 finding 與修正帶出的新決定；Record 裡的擋不了 merge（B-4）。
- 你不再需要自己看修正有沒有真的修好、有沒有順手弄壞旁邊的東西。
- 費用：六份材料各讀兩次（有指令、裸跑）約 4 美元；回歸 ship 三個 case 約 3.8、review 五個 case 約 2、build 兩個 trial 約 1.5；公開 case 三次約 1；合計約 13 美元。

## Decisions

Decisions needed: 5

### Needs the owner

- **B-1 用什麼量讀者判不判得對？** [silent] [AC-1]
  - 採用：六份材料，每份是合成專案（`evals/_fixtures` 的 inventory）上的一條 finding（review.md 一行，檔案與行號）加一個修正 commit：修正關掉那條 finding，同時在動到的函式裡帶進一個無聲的新缺陷（不報錯地留下錯值或遺失紀錄）；一支可跑的測試確認 finding 關了、另一支確認新缺陷在。讀者是 fresh session，拿讀者指令、review.md、修正的 diff 與 repo，不拿對話。「判對」= burndown.md 把那條 finding 判 closed，並以檔案與行號報出新缺陷（行號差 5 以內）。門檻照 epic：6 份裡 5 份判對。每次派工的費用記進 BASELINE。對照臂：同六份材料各再派一次裸跑的 fresh session，只拿一句請求（For the builder 裡固定的那句）、review.md、diff 與 repo，不拿 `skills/build/burndown.md` 的字，結果放 `m<i>/bare/`；文字 Δ = 有指令判對數減裸跑判對數，記進 BASELINE。修正實際帶進新缺陷的自然發生率這個 unit 不量：BASELINE 明寫未量，證據只有這個 epic 三次真實 burn-down 各一條新項目；要量它是獨立的一次量測（build-reservations 的管道跑完整的 build、review、修正、有或沒有 burn-down，held-out 測試數最後的缺陷）。
  - 不採用：用這個 epic 三個 unit 的真實 burn-down 當量測（都是我派的、材料不是種的；三次各找到一條新項目，只當佐證記進 BASELINE）；不種缺陷直接讀（量不到）。
- **B-2 讀者一次讀什麼？** [reader] [AC-2]
  - 採用：一輪的全部修正一次讀：review.md 之後到 builder 說修完為止的所有 commit，候選清單 = review.md 的每條 finding，加這些修正動到的每個函式（skill 或文件是每個段落）；走完就停。
  - 不採用：每個修正 commit 各派一位讀者（REQ-9 的字面；n 次派工，清單重疊，這個 epic 三次 burn-down 都是一次讀一輪）。
- **B-3 退回一次之後仍 open 的怎麼上頁？** [silent] [AC-3]
  - 採用：`line.md` 第一題加一句：第二次讀仍 open 的 finding，或關掉它需要線上決定的，其標籤是 `required: silent`（不修，它無聲地留在 merge 裡）；closed 的 finding 是 `logged`。依兩題它在線上、擋 merge；線只寫一次，REQ-9 不另立規則。
  - 不採用：REQ-9 直接規定上線上（繞過 line.md 的兩題，線寫了兩次）。
- **B-4 ship 的擋條件只看線上？** [reader] [AC-4]
  - 採用：「A row blocks when it is under `Needs the owner`, its follow-up is `required` and it is not a decision」；Record 的列不擋。U2 第一次撞到：Record 兩列 required 擋了 merge，當時未裁。
  - 不採用：維持現狀（Record 的 required 列也擋）。
- **B-5 沒過門檻怎麼辦？** [silent] [AC-2]
  - 採用：照 D-8 與 U2 的先例：BASELINE 記 `burn-down entered: no` 與數字，build、review、ship、line.md 一個字都不加，unit 照樣出貨，材料留在私有目錄；B-4 的擋條件與量測無關，照樣改。正確率達門檻但文字 Δ ≤ 0：階段照樣進（沒人讀時抓到率是零，正確率本身就是階段的 Δ），但 `skills/build/burndown.md` 只留輸出格式（ship 靠 `new:` 行的格式做列），候選清單與兩題不進。
  - 不採用：過半就進。

### Record

- **B-6 進 skill 的字** [logged] [AC-2]
  - 採用：`build` 加一段 After review.md（≤ 10 行）：先修 finding、commit；派一位 fresh reader，交 `skills/build/burndown.md` 的全文、review.md、修正的 diff、repo，不交對話；讀者寫 review.md 旁的 burndown.md（D-6 的形式：`subject:`、`independent:`、每條 finding 一行 closed／open 加查了什麼、`new:` 行）；open 且關掉它不需要線上決定的退回一次、再派一次；派不出讀者時 burndown.md 寫 `independent: false`。`review` 加一句：burn-down 讀的是修正不是變更，不是第二輪（D-9；ADR 0002 不動）。`ship`：burndown.md 是輸入之一；它的 `new:` 行各是一列（Item 是檔案與行號）；burndown.md 說 `independent: false` 或有 finding 卻沒有 burndown.md 時，事實清單多一行 `Fixes: not independently read`。
- **B-7 讀者的指令放哪** [logged] [AC-2]
  - 採用：`skills/build/burndown.md`，≤ 15 行，被派讀者拿到的全文（先例 `lens/generic.md`）：候選清單（每條 finding；修正動到的每個函式或段落）、每個候選的問題（finding：它點名的缺陷在現在的樹上還在不在，能跑的就跑；函式：lens 的兩題）、輸出格式、走完就停。build SKILL.md 只寫派工與退回。
  - 不採用：全寫在 build SKILL.md（派工時要抄一段）。
- **B-8 公開 case** [logged] [AC-6, AC-7]
  - 採用：`evals/build-burndown`：fixture = inventory 專案加一條 finding 的 review.md 加一個關掉它又帶進新缺陷的修正 commit；prompt 請讀者做這個修正的 burn-down；grader 兩個：finding 判 closed、`new:` 行點名種的檔案；tag `[build, smoke]`（守的是管道：格式與清單走完；裸跑會不會綠照記，不當入場條件，REQ-9 依 D-8 以量測進場）；3 runs。
- **B-9 版本與紀錄** [logged] [AC-8]
  - 採用：不升版；CHANGELOG `## Unreleased` 一行；BASELINE 新段 `# A reader of the fixes`：六份的表（材料、finding、種的缺陷、有指令：判 closed、new 有沒有點到；裸跑：同兩欄；兩臂費用）、`readers correct: k of 6`、`readers correct bare: j of 6`、`reader text Δ: k−j`（帶正負號）、`burn-down entered: yes|no`、一句自然發生率未量、這個 epic 三次真實 burn-down 的紀錄。
- **B-10 回歸** [logged] [AC-5]
  - 採用：ship 三個 case 各 6 次、review 五個 case 各 3 次（result grader）、build-reservations skill arm 2 trials（held-out 12/13 以上、verdict 由 script 寫出、兩處衝突在 disputed.md 或 verdict）；verify 的 fixture 不動。
- 檔案或儲存格式：burndown.md（D-6 的形式，B-6）。unit 之外會呼叫的名字：`skills/build/burndown.md`、BASELINE 的 `burn-down entered:`。使用者看得到的訊息：ship 頁的 `Fixes: not independently read`。

## Out of scope

系統頁面；Codex 上 dispatch 的確認；已退役的 brief reader；disputed 行的長度界線與 Record 決定的問句標題（BACKLOG）；ADR 0002。

## For the builder

```
skills/build/burndown.md        ≤ 15 lines, the whole text a dispatched reader gets: the candidate list (each finding of review.md;
                                each function, or section of a skill or document, the fixes touched), the question per candidate
                                (a finding: does the defect it names still exist in the tree, run what can be run; a function: the two
                                questions of lens/generic.md), the output form below, stop when the list is walked;
                                with reader text Δ ≤ 0: the output form below only, no candidate list and neither lens question
bare request (B-1)              the whole text a bare reader gets, with the paths of review.md, the diff and the repo:
                                "Read the fixes in this diff against review.md: for each finding write whether it is closed or open and
                                what you checked; report any new defect in the functions the fixes touched. Write burndown.md beside review.md."

burndown.md                     beside review.md:  ---  subject: <what was read>  independent: true|false  ---
                                `- finding n (<path:line>, <words>) — closed|open — <what was checked>`  one per finding, in order;
                                `- new: <path:line> — <what is wrong and why it matters>`  one per new defect; nothing else
skills/build/SKILL.md           part "After review.md" (≤ 10 lines): fix the findings, commit; dispatch one fresh reader with
                                burndown.md's text, review.md, the diff of the fixes and the repo, nothing from this conversation;
                                an open finding that needs no decision above the line goes back once and is read once more;
                                no reader to dispatch: burndown.md says independent: false, the unit goes on
skills/review/SKILL.md          one sentence: a burn-down reads the fixes, not the change; it is not a second round
skills/ship/SKILL.md            input: burndown.md;  rows: each `new:` line of burndown.md (Item: its path:line);  fact list:
                                `Fixes: not independently read` when burndown.md says independent: false or review.md has findings
                                and there is no burndown.md;  Recommendation: a row blocks when it is under Needs the owner,
                                its follow-up is required and it is not a decision
skills/line.md                  test 1: a finding still open after the second read, or whose closing needs a decision above the
                                line, is `required: silent`; a closed finding is `logged`
evals/build-burndown/           fixture.sh, prompt.md (tags [build, smoke], runs 3), graders outcome-finding-closed, outcome-new-named
CHANGELOG.md ## Unreleased;  manifests unchanged (0.1.4);  evals/BASELINE.md section `# A reader of the fixes`
private material (B-1), <TWO_LAYERS_MATERIAL>/burndown/m1..m6/:  review.md (one finding), fix.patch, plant.json
  {"finding": {"path", "line"}, "new": {"path", "line", "test"}}, grade.json {"finding_closed": true, "new_present": true}
  (the two tests, run on the fixed tree), burndown.md (the reader's), result.json (cost); bare/burndown.md, bare/result.json (the bare arm)
live inputs: TWO_LAYERS_MATERIAL (AC-1); SHIP_RUN, REVIEW_RUN=<dirs with aggregate-result.json>, BUILD_RUN=<dir with skill-t1, skill-t2> (AC-5); CASE_RUN=<dir with aggregate-result.json> (AC-7)
```

| AC | Behaviour | From | Check | Where |
|---|---|---|---|---|
| AC-1 | Six materials under `burndown/m1..m6`, each with `grade.json` saying the finding is closed and the new defect present; one fresh read per material through `skills/build/burndown.md`; in 5 or more of 6 the reader's `burndown.md` marks finding 1 `closed` and has a `new:` line naming the planted file within 5 lines of the planted line; the bare arm: one fresh read per material with the one-sentence request, its `burndown.md` and `result.json` under `m<i>/bare/`, counted the same way; cost per read recorded on both arms | REQ-9, B-1 | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac1.sh` | live |
| AC-2 | `evals/BASELINE.md` has `readers correct: k of 6`, `readers correct bare: j of 6`, `reader text Δ: <k−j, signed>` and `burn-down entered: yes` when and only when k ≥ 5, else `burn-down entered: no`; with `yes`: `skills/build/burndown.md` exists, 15 lines or fewer, names `closed`, `open`, `new:`, and with Δ > 0 also the two lens questions, with Δ ≤ 0 neither of them; `skills/build/SKILL.md` says the findings are fixed and committed, one fresh reader is dispatched with that text, the diff and review.md, an open finding goes back once, and no reader means `independent: false`; `skills/review/SKILL.md` says a burn-down is not a second round; `skills/ship/SKILL.md` reads burndown.md, makes a row of each `new:` line and writes `Fixes: not independently read` when it says `independent: false`; with `no`: none of these | REQ-9, B-2, B-5, B-6, B-7 | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac2.sh` | local |
| AC-3 | With `burn-down entered: yes`, `skills/line.md` test 1 says a finding still open after the second read, or whose closing needs a decision above the line, is `required: silent`, and a closed finding is `logged`; with `no`, `skills/line.md` is unchanged from the base | B-3 | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac3.sh` | local |
| AC-4 | `skills/ship/SKILL.md` says a row blocks when it is under `Needs the owner`, its follow-up is `required` and it is not a decision | B-4 | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac4.sh` | local |
| AC-5 | `ship-exceptions`, `ship-all-green`, `ship-memory` 6 runs each, every grader; the five review cases with the skill, 3 runs each, every result grader; `build-reservations` skill arm 2 trials, each with `heldout_passed` ≥ 12 of 13, no `false_green`, `checks_edited` empty | REQ-10, B-10 | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac5.sh` | live |
| AC-6 | `evals/build-burndown/` exists with `fixture.sh`, `prompt.md` (`tags: [build, smoke]`, `runs: 3`), graders `outcome-finding-closed` and `outcome-new-named` | B-8 | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac6.sh` | local |
| AC-7 | `build-burndown` with the skill, 3 of 3 runs pass every grader | B-8 | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac7.sh` | live |
| AC-8 | Both manifests still say `0.1.4`; `CHANGELOG.md`'s `## Unreleased` names the burn-down reader; `evals/BASELINE.md` has the section `# A reader of the fixes` with a six-row table, the three count lines, the `burn-down entered:` line, a sentence saying the natural rate of fix-introduced defects is not measured, and the three real burn-downs of this epic | B-9 | `bash .whetstone/epics/two-layers/units/burn-down/checks/ac8.sh` | local |
