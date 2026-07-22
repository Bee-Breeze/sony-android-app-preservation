# Sony Android App 保存研究

這是一個逐項保存、相容性測試與透明記錄 **Sony 品牌時期** Android App 的
研究 repository。完整研究範圍以 APKMirror「All Sony Mobile Communications
apps」合併去重後的 840 筆全域目錄為準；成功、失敗、僅 Sony 可用及跨品牌
可用的結果都會保留。

> 本系列研究、程式分析、修復實作、測試自動化與文件整理，皆由專案擁有者
> 指導 OpenAI Codex 完成。實體手機測試由使用者監督。這是獨立研究，未受
> Sony 或其他裝置廠商贊助、認可或背書。

## 狀態

目前先以 1930's、2D Code Scanner、Browser (small app)、Calculator、
Calendar、Contacts、Email、Lifelog 與 Sony Calculator 建立完整的階段四至八公開範本。
840 筆總目錄尚未全部完成，因此本 repository 不宣稱整體專案已完成。

| 目錄索引 | App | 最終分支 | Sony Android 13 | HTC Android 6 | 發布模式 |
| --- | --- | --- | --- | --- | --- |
| 0 | [1930's](apps/1930s-1.0.1/) | 1.0.1 portable v1 + host max-aspect v3 | 通過 | 失敗：缺少 host | 僅 Patchset |
| 1 | [2D Code Scanner](apps/2d-code-scanner-1.0.2.A.0.1/) | 1.0.2.A.0.1 portable v2 | 通過 | 失敗：32-bit ABI | 僅 Patchset |
| 67 | [Browser (small app)](apps/browser-small-app-3.2.3/) | 3.2.3 authentic standalone v3c | 通過 | 通過 | 僅 Patchset |
| 72（歷史版） | [Calculator](apps/calculator-2.1-update1/) | 2.1-update1 portable responsive v4 | 通過 | 通過 | 僅 Patchset |
| 72 | [Calculator](apps/calculator-8.0.0/) | 8.0.0 portable repair v1 | 通過 | 通過 | 僅 Patchset |
| 74 | [Calendar](apps/calendar-20.0.A.4.22/) | 20.0.A.4.22 portable repair v3 | 通過 | 有限制通過 | 僅 Patchset |
| 169 | [Contacts](apps/contacts-2.3.3/) | 2.3.3 compat v20 | 通過 | 通過 | 僅補丁規格 |
| Z3M-A084 | [Email](apps/email-17.0.A.0.12/) | 17.0.A.0.12 practical repair v1 | 通過 | 失敗：最低 API 30 | 僅 Patchset |
| Z3M-A053 | [Lifelog](apps/lifelog-4.0.A.0.39/) | 4.0.A.0.39 unchanged original | 通過 | 通過 | 僅證據 |
| 518 | [Sony Calculator](apps/sony-calculator-1.0.B.1.0/) | 1.0.B.1.0 unchanged original | 通過 | 通過 | 僅證據 |

歷史版 `2.1-update1` 已完成獨立驗證並建立個別研究頁，但它與 8.0.0
屬於同一 catalog row，因此不重複增加 840 筆目錄的完成數。

## 範圍

公開成果依品牌年代拆成兩個獨立 repository：

- `sony-android-app-preservation`：Sony 品牌時期的 App；
- `sony-ericsson-android-app-preservation`：Sony Ericsson 品牌時期的 App。

兩邊共用同一套 840 筆全域 catalog index，不複製或重新編號同一筆 App。
分類以該版本發布時的品牌、產品年代與可靠來源為準；`com.sonyericsson.*`
package、Sony Ericsson 舊簽章或沿用的技術名稱，不會單獨決定品牌歸屬。

每個 App 必須依序記錄：目錄身分、完整版本序列、最新相容版本決策、原版
安裝結果、真實主頁、直橫屏、黑邊與觸控、崩潰紀錄、逐控制測試、修復、
回溯、跨品牌實機結果及公開發佈資料。

## 授權

Repository 內由本專案撰寫的文件、測試台帳與補丁工具採 MIT License。
Sony APK、程式碼、圖示、名稱、商標及其他 OEM 資產仍屬各權利人；MIT
License 不涵蓋它們。本 repository 不提供 Sony 原始或重簽 APK。
