# 修復說明

## 輸入

- Package：`com.sonymobile.smallbrowser`
- Version：`3.2.3` / `30203`
- 原始 SHA-256：`dbac9c685f3d5072413d037ffa7de12f7617015dd20ace236802ddd2ea707551`

## Manifest 差異

- 移除必要的 `com.sony.smallapp.framework` library 宣告。
- 新增 exported `com.sonymobile.smallbrowser.FullBrowserActivity`，提供
  `MAIN/LAUNCHER` 及 `VIEW/BROWSABLE` intent filter。
- 設定 application 可調整尺寸並加入 `android.max_aspect=3.0`。

精確差異位於 `patches/AndroidManifest.patch`。

## 新增程式

`patches/FullBrowserActivity.java` 會被獨立編譯為 `classes2.dex`。它載入原始
`plusone_main_sys` 與 `plusone_menu` 資源，並沿用 package 內既有瀏覽器、
provider 與設定實作。

Activity 會：

- 在原始網址輸入元件建立前初始化 `SonyCustomizedConfig`；
- 接回導覽、網址／搜尋、書籤、首頁、桌面模式、外部開啟及設定；
- 只隱藏已失效的 Small Apps 浮動視窗控制；
- 在窄於 600dp 的螢幕調整工具列，不依賴特定手機固定像素；
- 恢復原始深色 Sony 選單的可讀文字與 checkbox 對比。

## 重建

執行 `scripts/build-and-sign.sh`。腳本會先驗證原始 SHA-256，再以 apktool
3.0.2 做一次不修改內容的 decode/build 正規化；第二次解碼後才套用 manifest
patch。接著以 Android SDK 35 編譯 Java、透過 build-tools 35.0.0 的 D8
產生第二個 dex、重建、zipalign，最後使用使用者自己的 keystore 簽署。

兩階段是必要的，因為實機最終 `v3c` 源自早期中間版的第二次解碼資源布局。
直接對原始 APK 單次解碼重建雖可安裝，但 ZIP entry 名稱不等同實機版本。
可用 `APKTOOL_JAR` 指向 apktool 3.0.2 jar；版本不符時腳本會停止。也可用
`ANDROID_PLATFORM_VERSION` 與 `ANDROID_BUILD_TOOLS_VERSION` 明確覆寫
工具版本，但那會改變重建位元並失去本次逐 entry 等同性證明。

Sony 原始簽章金鑰不包含於本專案，也無法重現。
