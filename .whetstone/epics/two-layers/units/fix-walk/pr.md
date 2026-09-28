**Goal**: 修 finding 的時候，把 finding 沒點名、但依賴改到的東西的檔案一起修掉，讓 burn-down 讀者要抓的東西變少。

- Recommendation: do not merge yet — AC-1
- Result: 5 of 6 PASS · 1 DISPUTED
- Range: 26ba5a8..c353a8b
- Decisions needed: 1
- Boundary: none: a person or a thing outside the repo

## Needs the owner

### AC-1 DISPUTED (PASS) · required: reader
- 決定：REQ-9 review.md 之後 builder 先修 finding。每個修正 commit 由一位沒寫它的讀者讀，候選清單是 review.md 的 finding 與修正動到的函式，走完就停：每個 finding 判 closed／open，動到的函式裡的新缺陷回報為新 finding。修正若定了跨邊界交換的一格，builder 寫進 `decisions.md`，它依線落在 ship 頁線上。open 且關掉它不需要線上決定的退回 builder 一次、再讀一次；第二次仍 open、或關掉它需要線上決定的，在 ship 頁線上並擋 merge；closed 的在線下。派不出讀者時 ship 頁寫「修正沒有獨立讀過」，不擋。先量：讀者對「關掉 finding 並帶進一個新缺陷」的修正判對 ≥ 5/6，才進 skill。；B-2 走訪的句子逐字用量過的那一段？
- 註記：the brief's B-2 and For the builder place the walk sentence after "commit the fixes", while a walk after the commit leaves its own edits uncommitted (review finding 1); the code puts the sentence before the commit, verbatim, which AC-1 admits either way.
- 選項：
  - ★ 接受：句子逐字不變，只是放在 commit 之前而不是之後；review 指出放在 commit 之後會讓走訪改的東西留在工作樹沒進 commit；skill 臂在這個順序上 6 of 6
  - 照 brief 字面放回 commit 之後，並另加一句「再 commit 一次」（多一句、要重量）
- 驗收條件：`skills/build/SKILL.md`'s After review.md part holds the walk sentence verbatim (`grep the repo for the name, value or format the fix changed and re-read every hit`, `re-read every file that states that behaviour`, `Stop when that list is walked`) and is 10 lines or fewer

## Record

### AC-4 PASS · logged
- 決定：request 修 finding 的時候，把 finding 沒點名、但依賴改到的東西的檔案一起修掉，讓 burn-down 讀者要抓的東西變少。；B-4 case 的身分
- 選項：
  - ★ 接受：verdict 來自 evidence/AC-4.log（skill 臂在最終文字上 6 of 6，每次約 0.5 美元）
  - 在本機重跑 skill 臂一次再接受
- 驗收條件：The skill arm of `build-fix-walk`, 6 trials with the plugin: 7 of 7 cells in 5 or more, `review_untouched` true in all 6

### AC-5 PASS · logged
- 決定：REQ-10 改到的 skill 的既有 eval case 全綠。；B-5 回歸與紀錄
- 選項：
  - ★ 接受：verdict 來自 evidence/AC-5.log（build-reservations 13/13 兩次、build-burndown 3/3，都在最終文字上）
  - 在本機重跑再接受
- 驗收條件：`build-reservations` skill arm 2 trials, each `heldout_passed` ≥ 12 of 13, no `false_green`, `checks_edited` empty; `build-burndown` 3 of 3 runs every grader

### skills/build/SKILL.md:10 · logged
- 發現：skills/build/SKILL.md:10 — "the part After review.md applies from its first step" sends a request with no `brief.md` into a part whose next step after the walk is "run `scripts/verify.sh` again": the script takes a brief as its argument and exits 2 without one, the Verdict part answers exit 2 with "fix that and run it again", which has no end here, and the burn-down sentence beside it carves out "commit and verify" while this one does not. It also means nothing commits what the walk changed on that path: the commit precedes the walk in the text and only verify.sh's refusal of uncommitted changes forces the commit on the brief path. Every skill trial paid for this (`evals/BASELINE.md:482`, "looking for a `brief.md` to verify and saying there is none"), and `grade.py` reads the working tree, so the case cannot see an uncommitted walk.
- 選項：
  - ★ 接受：burndown.md 兩次讀都判 closed（走訪改到 commit 之前；verify 只在有 brief 時跑）
  - 再派一位讀者讀 37a8f3b

### evals/build-fix-walk/heldout/test_f3.py:12 · logged
- 發現：evals/build-fix-walk/heldout/test_f3.py:12 — the held-out tests fix `order_id` as the third positional argument of `reserve`, which `SPEC.md` does not state (it says only "given at `reserve`"); a correct fix with `reserve(item, qty, now, order_id)` grades `f1_closed` and `f3_closed` false (test_f1's helper then passes `now="o1"` without a TypeError and `expire` fails), reproduced as 5 of 7 on a tree that closes all three findings, and `checks/ac4.sh` counts that as a miss.
- 選項：
  - ★ 接受：burndown.md 兩次讀都判 closed（held-out 依名字綁 order_id、其餘依位置；id 放最後的樹 7 of 7）
  - 再派一位讀者讀 37a8f3b

### evals/build-fix-walk/grade.py:32 · logged
- 發現：evals/build-fix-walk/grade.py:32 — `review_untouched` compares the fixture commit to HEAD while every other cell reads the working tree: an edit to `unit/review.md` left uncommitted grades `true` (reproduced), so AC-4's "untouched in all 6" cannot catch it; and `--grep="reviewed tree" -1` returns a builder commit whose message contains those words, which then hides earlier commits from the diff.
- 選項：
  - ★ 接受：burndown.md 第二讀判 closed（base 改為工作區第二個 commit，對工作樹比對；三棵變體樹如預期）
  - 再派一位讀者讀 37a8f3b

### evals/BASELINE.md:482 · logged
- 發現：evals/BASELINE.md:482 — "Unit cost so far 5.10 USD" while the figures in the same line sum to 6.25 (3.25 + 1.15 + 1.15 + 0.70); one `build-reservations` trial is dropped, and the brief's "about 5" is quoted against the wrong total.
- 選項：
  - ★ 接受：burndown.md 兩次讀都判 closed（6.25，四項相加）
  - 再派一位讀者讀 37a8f3b

### evals/build-fix-walk/heldout/test_f1.py:12 · required: silent
- 發現：evals/build-fix-walk/heldout/test_f1.py:12 (the same helper at test_f2.py:12 and test_f3.py:15) — the helper passes `now` to every parameter of `reserve` other than `item`, `qty` and `order_id`, not to one time parameter: a correct tree with `reserve(item, qty, order_id, now, ttl=HOLD_SECONDS)` (a per-hold ttl, the fixture's tests green) gets `ttl=0`, its hold expires at once, and `f1_closed` grades false with no error (6 of 7 on a copy of skill-t1) where the four-positional helper at be338e2 graded it 7; none of the 18 trees has such a parameter, so no number moves today.
- 選項：
  - ★ 留在紀錄：今天十八棵樹沒有一棵有多餘的參數，數字不受影響；下一次動這個 case 時把 helper 改成只綁 order_id 與一個時間參數、其餘留預設
  - 現在修（多一輪 review 與 burn-down）

### evals/build-fix-walk/grade.py:32 · required: silent
- 發現：evals/build-fix-walk/grade.py:32 — a builder who amends the fixture's "reviewed tree" commit instead of adding one (`git commit --amend` from the fixture's HEAD) makes the amended commit the second of `rev-list`, so an edit to `unit/review.md` folded into it grades `review_untouched` true (reproduced on a copy of skill-t1: 2 commits, review.md changed, true); the grep version had the same hole and no trial amended, so AC-4's six stand, but "untouched in all 6" cannot see that path either.
- 選項：
  - ★ 留在紀錄：沒有 trial 這樣做過；下一次動這個 case 時讓 fixture 把 reviewed-tree 的 sha 寫進工作區外的檔案
  - 現在修（多一輪 review 與 burn-down）

### memory · logged
- 陳述：The rule-count ratchet in `CLAUDE.md` ("one in, one out") has no recorded starting count and has never retired a sentence to admit one; two rules entered without one leaving, `intent`'s dependency walk (2026-09-21) and `build`'s walk after each fix (2026-09-28), and the owner left the sentence itself to the system-page epic. check: `grep -q "one in, one out" CLAUDE.md`. from: two-layers fix-walk B-1
- 選項：
  - ★ accept
  - drop

### memory · logged
- 陳述：The runs of unit `fix-walk` (`runs-fix-walk/harness-run-1`, the skill arm and build regressions on the text before its review fixes; `harness-run-2`, the same on the final text) live outside the public repo under the `TWO_LAYERS_MATERIAL` root; the AC-4 evidence is `FIXWALK_RUN=runs-fix-walk/harness-run-2/skill`, the AC-5 evidence `BUILD_RUN=runs-fix-walk/harness-run-2/build` and `CASE_RUN=runs-fix-walk/harness-run-2/case`; the bare and walk arms of the measurement are under `runs-burn-down/fix-walk/`; without them AC-4 and AC-5 of that unit are UNVERIFIED. check: `grep -q TWO_LAYERS_MATERIAL evals-private/repos.env`. from: two-layers fix-walk B-4
- 選項：
  - ★ accept
  - drop

Candidates that did not enter: B-2, B-3, B-5 (what they fix is read from the skill, the case and the records: the second question); B-4's tag and arms (read from run.sh: the second question).

AC-2, AC-3, AC-6
