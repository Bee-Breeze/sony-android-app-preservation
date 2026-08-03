# Network Visualizer 2.0.0 修復說明

## 原始缺陷

未修改的 Sony `2.0.0` 在 Xperia 1 III／Android 13 可顯示介紹頁，進入
主頁時依序遇到三個相容性問題：裝置 board 不在 App 的圖稿表、新 App 呼叫
舊 mmWDI framework 不存在的方法，以及舊 framework 對 callback 註冊套用
Sony signer 白名單。

## 最終修改

`2.0.0-compat-v5` 累積五項最小修改：

1. 未知 board 使用 APK 既有的 `vx9571` drawable family。
2. 缺少的新版 mmWDI 值回傳中性、不可用狀態。
3. callback bookkeeping 留在 App 內，不呼叫不相容的 framework 註冊。
4. 橫屏 graph 高度保留真實底部 system inset。
5. 更多選項按鈕使用 App 既有的 `更多選項` content description。

v5 與 v4 的直、橫屏 App pixels 完全一致；v5 只補足 overflow 的語意名稱。

## 未修改與刻意不恢復

- 未偽造即時吞吐量、天線方向、訊號或可用狀態。
- 未繞過 Sony 私鑰、signature permission 或 framework 信任邊界。
- 未替換 Sony mmWDI framework、system JAR、HAL 或 radio 元件。
- 未把內建手機圖宣稱為 Xperia 1 III 的真實天線位置。
- 未把 Android 14／15 release 降版包裝成 Android 13 相容版本。

## 建置與簽章

- Apktool `3.0.2`
- JDK `17`
- Android build-tools `35.0.0`
- `zipalign` 4-byte alignment
- `apksigner` 驗證通過

公開 repository 不包含 Sony APK、反編譯樹或可重建 OEM binary 的完整程式
內容。完整研究樹與歷次候選只保存在私人 NAS。
