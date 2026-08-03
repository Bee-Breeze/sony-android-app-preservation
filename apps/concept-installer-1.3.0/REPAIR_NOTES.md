# 修復紀錄

## 原版

Sony 原版 `1.3.0` 可在 Xperia 1 III 安裝、載入必要的 `com.sony.device`，並
執行真正的裝置註冊入口。由於 Sony Concept 後端已結束，流程會顯示「無法註冊」
並由「確定」退出。

功能終止不是 Android 13 異常；可修復的相容性問題是原版被舊式長寬比規則限制，
導致底部出現大面積黑邊。

## v1

唯一修改是 `AndroidManifest.xml` 的 `application`：

```diff
- <application ... android:resizeableActivity="false" ...>
+ <application ... android:maxAspectRatio="3.0" android:resizeableActivity="false" ...>
```

套件名稱、`versionName`、`versionCode`、最低 SDK、target SDK、所有 Activity、
Receiver、Service、Provider、資源與程式碼均保持不變。原版先完成 apktool 未修改
round-trip，才套用這一行修復。

## 驗證

- 原版 SHA-256：`0b3fa49abc17f29838fb5e3c0b6f6732d78b64cafefef6ec77d6c24ca61dd514`
- v1 SHA-256：`03e4a22a6d980b7a9e8d70ed37428de7daeb05c4908aeaf0f416e6950a429512`
- 原版回復、裝置拉回雜湊、v1 恢復及再次拉回雜湊皆通過。
- 五輪冷啟動與「確定」操作通過，零 attributable fatal／ANR。

## 明確不做

- 不偽造 Sony 裝置資格或註冊成功。
- 不繞過帳號、授權或伺服器政策。
- 不重建或假冒 Sony AWS、Firebase、備份及韌體交付後端。
- 不提供 Sony APK、反編譯碼、簽署私鑰或私密測試日誌到 GitHub。
