# 測試結果

## Sony Xperia 1 III／Android 13

| 驗證 | 結果 |
| --- | --- |
| 真正 Launcher 主頁 | 通過，`GalleryActivity` |
| App-only settled frame | 2 秒間隔 pixels 與 UI hierarchy 相同 |
| 直向主頁 | 通過，無 App 黑邊、裁切或重疊 |
| 橫向主頁／橫向掃描器 | 通過 |
| 說明與祕訣 | 六分類、分類 detail 及四頁 ViewPager 通過 |
| 排序 | 日期、名稱、取消通過；最後恢復日期 |
| 設定 | 聲音切換／持久化、校準重設取消、授權頁通過 |
| 五種模式卡 | 全部可滑動檢視，教學入口通過 |
| 前鏡頭 | Camera ID 1，1280×720，約 10 秒 156 frames，零 device error |
| 後鏡頭 | Camera ID 0，1280×720，約 10 秒 277 frames，零 device error |
| 掃描流程 | 「框住」→「校準」通過；繼續／取消按鈕通過 |
| Lifecycle | 模式選單開啟時 5 次直橫屏往返，零 fatal／ANR |
| 回溯 | v4 → v3 → v4 通過，最終 installed hash 一致 |
| 完整 360 度成模 | 未完成，明確保留為 blocked |

ADB screencap 的 camera preview region 呈黑色；因此上表只把 CameraService 的
camera ID、stream configuration、frame production、錯誤計數及 UI state transition
當作相機執行證據，不宣稱預覽 pixels 已由獨立觀察通過。

## HTC One M8／Android 6.0.1

同一最終 APK 以一般 Package Manager 安裝，明確回傳
`INSTALL_FAILED_OLDER_SDK`。上游最低 API 26，而 HTC 為 API 23；package 在測試
前後皆不存在，沒有建立 App data，也沒有用 Root 強裝。

## 控制閉合

- Screens：9
- Controls：32
- Passed：29
- Blocked：3
- Failed：0

Blocked 項目是完整實體 360 度成模、完成模型後的編輯功能，以及依賴退役服務的
雲端／分享／列印功能。這些限制使技術決策維持 `partial`。
