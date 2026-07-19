# HTC 跨品牌測試摘要

- 裝置：HTC One M8
- Android／API：6.0.1／23
- ABI：`armeabi-v7a,armeabi`（`zygote32`）
- 原有 `com.android.calendar`：無
- 同一份最終 APK：一般 Package Manager 安裝通過
- 拉回 APK hash：與本地及 Sony 完全相同
- Runtime Root：未使用

授權位置與行事曆權限並完成歡迎流程後，App 進入真正的月曆主頁。第一次
OEM 權限流程中，HTC 權限 UI 阻擋 `AsyncQueryServiceHelper` 時出現一次 ANR；
等待並完成權限頁後恢復。後續冷啟動連續觀察 15 秒，正常進入主頁且沒有再次
出現 Calendar fatal exception 或 ANR。

直屏、橫屏與事件編輯器啟動通過。HTC 沒有可解析 `geo:0,0` 的 Activity，
因此修復後的地圖控制留在 Calendar 內但沒有崩潰；沒有為了製造通過結果而
額外安裝地圖 App。

測試後已卸載 Calendar。HTC Calendar Provider、預設 IME、旋轉及
`system_server` PID 2281 均維持或恢復，沒有重新開機。

- 正規化結果：`htc_tested_passed`
- 可攜層級：`universal_no_root_partial`
