# Calculator 2.1-update1 portable responsive v4 技術摘要

## 凍結候選

- 原始 package：`com.android.calculator2`
- 可攜 package：`com.android.calculator2.preserved`
- 版本：`2.1-update1`（versionCode 7）
- 最終 APK SHA-256：`cee7ff5b1b9c417c0385674ccd7af64fbda67e54a8ec4cb276201450e138a725`
- 基準 APK SHA-256：`76826e20297f97e31bf0fe381ab69590839d64f0bd943d07641551cf8a033b20`
- 權限：0
- native library：0
- 執行所需 Root：不需要

## Sony Android 13

- 一般 ADB 安裝成功，冷啟動進入真實主頁。
- 最終 APK、Sony installed APK 與 HTC installed APK 的 SHA-256 完全一致。
- 直屏與橫屏填滿 App 可用範圍，舊版大面積黑邊與文字裁切已排除。
- simple 面板 17 個按鍵及 advanced 面板 12 個按鍵均有文字標籤、enabled、
  focusable，觀察到的最小按鍵尺寸大於 48dp。
- 數字 0-9、四則運算、小數、刪除、長按清除、括號、sin/cos/tan、ln/log、
  階乘、pi、e、冪次及平方根已執行。
- 自動字串比對有三筆需人工判讀：小數顯示 `0.` 而非 `.`；pi/e 依顯示
  寬度截短。畫面及計算值符合 App 原有行為，未視為功能失敗。
- Home/resume、Back、force-stop 後重開、歷史操作與除以零均未造成崩潰。

## HTC Android 6.0.1

- 同一 v4 以一般非 Root ADB 安裝成功。
- 直屏與橫屏均進入主頁，`2 + 3 = 5` 通過。
- simple 面板 17 個按鍵具備文字標籤、enabled、focusable，最小控制大於 48dp。
- 卸載與重新安裝通過，未覆蓋 HTC 內建 `com.android.calculator2`。

## 靜態安全與隱私

- Manifest 宣告 0 權限。
- 未發現 URL／network-like 字串或 native library。
- package 改名只為一般 App 共存；沒有要求 privileged、shared UID、Root 或 Magisk。
- 測試簽章是本地研究憑證，不是 Sony production signer。

## 證據保存

完整原始測試紀錄、APK 與逐控制 XML 已在階段 9 封存於：

`/volume1/software-library/sony-calculators-postarchive-current-v2-20260720`

公開 GitHub 僅保留去識別化摘要、截圖、補丁與重建腳本。
