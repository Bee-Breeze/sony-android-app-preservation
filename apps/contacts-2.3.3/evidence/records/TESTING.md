# Contacts 2.3.3 compat-v20 測試摘要

精確候選 SHA-256：
`b9ccf50144f3873b3110236bd57ef304600db9810b1d6ba00851fe05e3efdce1`

## Sony Android 13

| 驗證項目 | 結果 |
| --- | --- |
| 冷啟動至真實主頁 | 通過 |
| 電話／通話記錄／聯絡人／我的最愛 | 四分頁通過 |
| 12 顆撥號鍵、連續輸入、長按刪除 | 通過 |
| 左／中／右觸控對位 | 通過 |
| 撥號交接 | 通過；只開啟系統電話 App |
| 搜尋、新增聯絡人、顯示選項、帳戶 | 通過 |
| 匯入／匯出選單 | 可開啟；未執行會修改或分享私人資料的項目 |
| 本機合成聯絡人 CRUD 與清理 | 通過 |
| 詳細頁、編輯、最愛、鈴聲、語音信箱 | 通過並還原 |
| QuickContact 三個控制 | 通過 |
| TalkBack | 通過並完整還原設定 |
| 直屏版面 | 通過；沒有 App 造成的外圍黑邊 |
| 橫屏 | 不適用；原版 manifest 指定 `nosensor` |
| Fatal exception / ANR | 沒有可歸因於目標 App 的事件 |

電話、簡訊、Email 與分享只測到安全的外部 host 交接，沒有真的送出。SIM／SD
匯入、匯出及大量分享因可能改動或揭露私人資料而有理由跳過。

測試使用 account-less 本機合成聯絡人。完成後 contact URI、raw-contact URI
與合成值掃描均無結果，provider 筆數回到測試前基線。

## HTC Android 6

- 裝置：HTC One M8，Android 6.0.1 / API 23。
- 不使用 Root，以一般 Package Manager 安裝精確同一個 v20。
- 候選、Sony 安裝後拉回檔與 HTC 安裝後拉回檔 SHA-256 完全一致。
- 真實四分頁主頁、1080 px 全寬版面、安全輸入 `1`、刪除及聯絡人分頁通過。
- HTC Security Assistant 顯示舊式權限 overlay，但 App 維持 resumed。
- 沒有目標 App 的 fatal exception 或 ANR；測試後已卸載且 HTC 原生通訊錄
  保持原狀。

## 隱私界線

含真實聯絡人、帳號、通話記錄、私人 UI hierarchy、provider backup 或完整
logs 的證據不進 GitHub。公開截圖只有空白撥號盤，已完成像素、metadata、
  Git history、secret pattern 與 motivated-intruder 檢查。
