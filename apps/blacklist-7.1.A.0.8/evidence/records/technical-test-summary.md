# Blacklist 7.1.A.0.8 技術驗證摘要

## 判定

- 技術判定：`partial`
- 公開模式：僅文件與去識別化截圖
- 私人二進位：最終本地相容性重簽 APK
- Root：不需要
- 重新開機：不需要

## 最終成品

- Package：`com.sonymobile.blacklist`
- Version：`7.1.A.0.8`（`14811144`）
- APK SHA-256：`d29809c05928b6b7e1f0f155dfc52425ad0ae0920d54101f420afb032d5eec44`
- Signer SHA-256：`c8995d8defe8e6b0eda53ac730f4241d0d2cb1d363603be88341d9708388a09d`

## 階段摘要

| 階段 | 結果 | 證據結論 |
| --- | --- | --- |
| 1 | 通過 | 840 筆目錄索引 56，package 與世代已由 manifest 證實 |
| 2 | 通過 | APKMirror 唯一及最新 release 為 `7.1.A.0.8` |
| 3 | 修復後通過 | 原版啟動因舊 `ITelephonyRegistry.listen` 路徑崩潰；三項最小修復後穩定 |
| 4 | 通過 | Sony Android 13 真正主畫面、冷啟動與穩定 frame 通過 |
| 5 | 修復後通過 | 直屏通過；橫屏右側黑邊經 resizeable manifest 修復 |
| 6 | 通過 | HTC Android 6.0.1 安裝同一最終 APK，主頁、分頁及直橫屏通過 |
| 7 | Partial | 32／32 可見控制通過；真實來電／簡訊攔截、TalkBack 與完整權限矩陣未完成 |

## 修復差異

1. `BlockService.onStartCommand` 改為不註冊已移除的內部電話 listener。
2. Manifest 新增 `android:maxAspectRatio="3.0"`。
3. Manifest 新增 `android:resizeableActivity="true"`。

`classes.dex` 與 `resources.arsc` 的最終保留關係由私有修復台帳及 entry hash
記錄證明。公開頁不散布原始或重簽 APK。

## 深度測試

- 畫面：8
- 有限可見控制：32
- 通過：32
- 失敗：0
- 阻擋：0（控制層級）
- 合成資料清理：通過
- 設定還原：通過
- 可歸因 Fatal／ANR／Security／Linkage：均為 0

UI 選項通過不等於電信功能通過。最終版本為避免現代 Android 崩潰而停用
舊 listener，因此實際電話與簡訊封鎖能力沒有被本研究驗證或宣稱。

## 跨品牌

HTC One M8／Android 6.0.1 以 ordinary Package Manager 安裝同一 SHA-256
成品，完成真正主頁、黑名單／VIP／已封鎖分頁與直橫屏測試。測試後 package、
設定與資料均已清理。

## 隱私範圍

公開候選只包含兩張空白清單畫面與本專案撰寫的 Markdown。狀態列、導航列、
電話號碼、聯絡人、帳號、裝置識別資訊、原始 UI tree、完整 log 與 APK 均不在
公開候選內。
