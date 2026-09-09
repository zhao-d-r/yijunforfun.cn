#!/bin/bash
# 把 subscription-routine 的 Valley Beacon 站点构建到本仓库 taste/ 并推送(GitHub Pages 自动发布)。
# 由 launchd cn.yijunforfun.sync-taste 定时调用;也可手动跑。
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
SITE="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$HOME/.cache/valley-beacon-src"
LOG="$HOME/Library/Logs/yijunforfun-sync.log"
exec >>"$LOG" 2>&1
echo "=== $(date '+%F %T') sync start ==="

if [ ! -d "$SRC/.git" ]; then
  git clone -q https://github.com/zhao-d-r/subscription-routine.git "$SRC"
else
  git -C "$SRC" fetch -q origin main && git -C "$SRC" reset -q --hard origin/main
fi
echo "src @ $(git -C "$SRC" log --oneline -1)"

(cd "$SRC" && SITE_BASE=/taste python3 scripts/build_site.py)

rsync -a --delete "$SRC/public/" "$SITE/taste/"

cd "$SITE"
git pull -q --ff-only origin main || echo "warn: pull --ff-only failed, continuing"
git add -A taste
if git diff --cached --quiet; then
  echo "no change"; exit 0
fi
git -c user.name="yijunforfun-sync" -c user.email="sync@yijunforfun.cn" commit -q -m "taste: sync $(date '+%F %H:%M') ($(git -C "$SRC" rev-parse --short HEAD))"
git push -q origin main
echo "pushed $(git rev-parse --short HEAD)"
