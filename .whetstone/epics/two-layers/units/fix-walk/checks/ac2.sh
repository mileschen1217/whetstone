#!/usr/bin/env bash
# AC-2: build's Input routes a fix-the-findings-alone request to After review.md from its first step.
inp="$(awk '/^## Input/{on=1;next} /^## /{on=0} on' skills/build/SKILL.md)"
printf '%s' "$inp" | grep -qiE 'fix the findings' && printf '%s' "$inp" | grep -qiE 'After review.md' && printf '%s' "$inp" | grep -qiE 'first step' || { echo "Input lacks the fix-the-findings sentence"; exit 1; }
