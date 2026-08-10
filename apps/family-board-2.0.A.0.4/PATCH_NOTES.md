# Family Board responsive v4 修復紀錄

## 基準

- Package：`com.sonymobile.familyboard`
- 原始版本：`2.0.A.0.4` (`4194308`)
- 最終版本：`2.0.A.0.4-responsive-v4` (`4194312`)
- 原始 APK SHA-256：
  `74b5ea11ecb3b319a15bf19722875d47eca05067199933e37cbbfd5278fea7b3`
- 最終 APK SHA-256：
  `49db3ace50d67dccebeba8f6787de7c657c4a27bcfad5f01cfec34ad08eee7d7`

## 變更

### responsive v1

- Manifest `maxAspectRatio` 改為 `3.0`。
- 啟用 `resizeableActivity`。
- 看板根節點、主要 frame 與容器改為填滿可用畫面。
- 新增 `sw360dp-land`、`sw400dp-land` 橫向尺寸資源。
- 讓刪除、新增、子選單與 overflow 控制在 Xperia 1 III 內可見。

### responsive v2

- 在目標橫向資源加入 `note_slide_bar_width=133dp` 與
  `note_slide_bar_height=20dp`。
- `BackupAndRestoreManagerBase.getSdCardFile()` 改用
  `Context.getExternalFilesDir("FamilyBoard")`，並以 `getFilesDir()` 備援。

### responsive v3

- `PenWidthPreview` 的字型改為目標韌體存在的
  `/system/fonts/Roboto-Regular.ttf`，取代缺少的歷史絕對路徑
  `/system/fonts/Roboto-Light.ttf`。

### responsive v4

- 將繁體中文備份、還原與儲存空間錯誤訊息由「SD 卡」改為「手機儲存空間」，
  與新的實際路徑一致。

## 未變更

- Package、主要 Activity、資料格式及兩類看板項目沒有重構。
- 沒有改動 Sony 一次性錄影 Intent、網路端點或權限。
- 沒有把原始使用者資料寫進 APK。
- 沒有加入 HTC 或其他 OEM 專用分支。

## 回溯

私人 NAS 封存保留原始 APK、修復前資料 tar、四個 repair tree、每版 APK、
安裝證據與最終 manifest。切換簽章前必須先保存資料；不同簽章不能直接覆蓋。
