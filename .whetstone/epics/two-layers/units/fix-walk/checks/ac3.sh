#!/usr/bin/env bash
# AC-3: the skill arm's request equals the bare arm's; run.sh loads the plugin with PLUGIN_DIR; header names the case rule.
d=evals/build-fix-walk
[ -f $d/arms/skill.md ] && cmp -s $d/arms/skill.md $d/arms/bare.md || { echo "arms/skill.md missing or differs from arms/bare.md"; exit 1; }
grep -q 'PLUGIN_DIR' $d/run.sh && grep -q -- '--plugin-dir' $d/run.sh || { echo "run.sh does not load the plugin with PLUGIN_DIR"; exit 1; }
head -8 $d/run.sh | grep -qiE '\brule\b' || { echo "run.sh header does not name rule"; exit 1; }
