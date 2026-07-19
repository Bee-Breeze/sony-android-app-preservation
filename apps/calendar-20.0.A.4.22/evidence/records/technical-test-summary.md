# 技術測試摘要

- 目錄索引：74
- Package／版本：`com.android.calendar`／`20.0.A.4.22`（`41947158`）
- 最終 APK SHA-256：`43f34604aa287d6a84b2d44057cd58433ca9b93591735c6544b9e14a4b4d6473`
- 最終簽章 SHA-256：`b5e26a13f091dd593e8f8024e7de21cc0426d0d383feae3300035b84def9d618`
- 技術結果：Sony 通過；HTC 主流程通過但有限制
- Runtime Root／重新開機：都不需要

## Sony Android 13

- 一般安裝及拉回 APK 精確 hash：通過。
- 真正月曆主頁、月／週／日／年／議程、搜尋與設定：通過。
- 深度控制清單：75／75 均有結案狀態，0 unresolved。
- 隔離事件建立、讀取、修改、刪除及清理：通過。
- 外部 `geo:` 交接至 Google Maps：通過。
- 直屏、橫屏及回到直屏：通過，沒有 App 造成的黑邊。
- 最終 regression 前後的 provider event ID：完全一致。
- 可歸責 fatal exception／ANR：無。
- `system_server`：測試前後 PID 8542，沒有重新開機。

## 修復範圍

1. 修正 manifest resize、max-aspect 與啟動 configuration。
2. 將受憑證限制的內嵌地圖改成可解析的標準 `geo:` 外部交接。
3. 將 Sony Tasks／UX `uses-library` 宣告從 required 改成 optional。

v2 與 v3 的 logical APK 都有 1171 個非 `META-INF` entry，只改變
`AndroidManifest.xml`；較早的地圖修復只改 `classes.dex` 的目標 method。
沒有新增權限、native payload、帳號、tracker 或 endpoint。

## 狀態恢復

暫時測試事件已移除；provider ID、輸入法、旋轉、字級、已啟用無障礙服務、
預設 Calendar view 與核心 process 狀態均已恢復。含私人行程的原始截圖與 log
不進入公開 repository。
