# PlayJ 1.1.A.0.7 修復說明

## 原始缺陷

Sony Android 13 上的舊 Flix 觸控層可以繪製 `READ MORE`，卻不會可靠執行既有 listener。HTC Android 6 的原版可執行同一按鈕，證明 URL 與 listener 本身仍存在。原版及觸控修復 v3 的 UI tree 仍將整頁標成沒有名稱的 `NAF=true` View，無法形成可靠的無障礙操作。

## 最終修改

在 `com/sonymobile/xtream/streaming/PleaseUpdateAppActivity.smali` 加入最小化觸控與無障礙修復：

1. 僅處理 `ACTION_UP`。
2. 只接受畫面中央寬度 `15%–85%`。
3. 寬高比大於 2:1 時接受高度 `65%–77%`。
4. 其他比例接受高度 `68%–88%`。
5. 命中後開啟 App 原本的 Facebook URL。
6. 按鈕外的 `ACTION_UP` 會被消耗；其他觸控事件仍走原始 Activity。
7. 為 Flix 根 View 設定可辨識的內容描述及標準 `View.OnClickListener`。
8. 無障礙 click、鍵盤 Enter 與一般觸控都執行同一個原始 URL。

## 未修改

- Package、versionName、versionCode
- Manifest orientation
- 畫面、圖片、字串與品牌素材
- 權限與後台服務
- Facebook URL
- 已終止的 PlayJ 後端

## 建置

- Apktool `3.0.2`
- JDK `17`
- Android build-tools `35.0.0`
- `zipalign` 4-byte alignment
- `apksigner` v1/v2/v3 驗證通過

公開 repository 不含 Sony 原始碼、反編譯樹、Sony APK 或修復 APK。完整可重建研究資料只保存於私人 NAS。
