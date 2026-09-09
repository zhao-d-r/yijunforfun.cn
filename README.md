# yijunforfun.cn

个人主页，GitHub Pages 托管，自定义域名 `yijunforfun.cn`。

- `index.html` — 主页，直接改。
- `taste/` — Valley Beacon（my-taste-zhao）的静态构建产物，**不要手改**，由 `scripts/sync-taste.sh` 从 `zhao-d-r/subscription-routine` 自动生成（`SITE_BASE=/taste`）。
- Mac 上 launchd `cn.yijunforfun.sync-taste` 每天 09:10 / 21:30 跑一次同步；日志在 `~/Library/Logs/yijunforfun-sync.log`。
