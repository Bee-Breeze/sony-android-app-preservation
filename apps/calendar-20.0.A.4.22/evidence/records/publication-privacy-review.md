# 公開資料去識別化審查

- 候選：Sony Calendar `20.0.A.4.22` portable repair v3
- 用途：公開保存文件、可重現 patchset 與實機畫面證據
- 對象：公開 GitHub 訪客
- 渠道：`Bee-Breeze/sony-android-app-preservation`
- 審查日期：2026-07-19
- 發布模式：`patchset_only`
- Pre-publication 決策：`passed_after_redaction`

## 範圍與資料最小化

公開候選只保留繁體中文文件、專案自有 build／verify script、最小 unified
patch 與四張裁切實機截圖。Sony 原始／重簽 APK、完整反編譯程式碼、API key、
keystore、簽章私鑰、logcat、UI hierarchy、資料庫、行事曆 provider dump、App
data 備份、事件 CRUD 畫面及任何含私人行程的證據均不納入。

內部原始證據保留於私人研究樹，公開副本的清理不會覆蓋唯一證據。

## 自動檢查

最終候選必須通過：

- `check_public_release.py` 對完整 repository 與可到達 Git 歷史掃描；
- `gitleaks` 對 working tree 與完整歷史掃描；
- 禁止 payload、私人絕對路徑、裝置序號、網路識別碼與 credential pattern；
- Markdown 相對連結；
- ExifTool metadata、PNG chunk 與 `IEND` 後 trailer；
- publication schema、patch dry run、可重現 build 及 checksum 驗證。

Scanner finding 必須逐筆判讀，不建立廣泛 allowlist。Machine-readable report
留在公開候選外，避免把本機絕對工作路徑加入 repository。

Calendar App 子樹最終 inventory 為 13 個檔案，scanner finding 為 0。
完整 repository inventory 為 56 個檔案，scanner 列出 10 筆 email finding：
1 筆位於既有 Calculator 隱私紀錄，9 筆位於 Git author、committer 或 patch
metadata；全部都是同一個 repository 擁有者刻意公開的 GitHub noreply 身分，
沒有私人 email。每個位置已逐項判讀並保留，沒有建立廣泛 allowlist。
`gitleaks` 對完整歷史與 Calendar App 子樹都回報 0 leak。

## 人工截圖審查

四張公開 PNG 已逐張以原始解析度檢視。畫面只呈現 Sony 或 HTC 的 Calendar
月檢視、日期、天氣數值及舊版 Calendar 自帶的 LinkedIn promo；沒有事件標題、
帳號、email、聯絡人、訊息、通知、照片、位置、SSID、裝置序號或認證狀態。

公開副本已裁除 Sony／HTC 系統狀態列與導覽列，移除非必要 metadata 及 PNG
尾端資料。四張圖的自然尺寸、caption 與 orientation 都和技術主張一致。

本次畫面由技術 reviewer 檢查，並沿用使用者對公開截圖流程的監督授權；這是
human-supervised owner review，不表述為獨立隱私專家或法律審查。

## Motivated-intruder 測試

- `singling_out`：公開畫面沒有個人、帳號、穩定 pseudonym 或裝置識別碼。
- `linkability`：package、版本、裝置型號類別、OS、日期及 artifact hash 是
  可稽核技術資料，不能在本候選中連到私人行程或帳號。
- `inference`：公開內容只能推知明列 App 曾在明列裝置類別測試，不能合理
  推論擁有者身分、位置、聯絡人、活動或通訊內容。

## 發現與修正

| 發現 | 公開副本修正 | 驗證 |
|---|---|---|
| 內部截圖與 provider dump 含私人行程／帳號脈絡。 | 完整排除，只製作空白月檢視公開副本。 | File inventory、像素審查及禁止檔案掃描。 |
| 橫屏公開副本最初仍有系統狀態列與導覽列。 | 重新以精確 App bounds 裁切。 | 原始解析度人工檢視及尺寸檢查。 |
| PNG 有非必要 ICC／Exif 或 `IEND` 後 trailer。 | 公開副本重新編碼並移除 metadata／trailer。 | ExifTool 與 PNG trailer 檢查。 |
| Repository 歷史含公開 commit 身分。 | 逐筆區分刻意公開的 GitHub noreply 身分與私人 email。 | 完整 Git-history scanner 及人工 disposition。 |

## 殘餘風險與重審

殘餘風險低但非零。型號類別、Android 版本、測試日期與 package 是必要準
識別資訊；任何文件、截圖、crop、metadata、caption、hash、commit、tag 或
Git 歷史變動，都必須重新執行完整 gate。推送後還必須檢查精確 tracked
commit 的 desktop／narrow rendered page、圖片、表格與連結。

若發現非預期揭露，立即暫停發布、移除或替換公開副本；若涉及 credential
則輪替，重跑 gate 通過後才能恢復。本審查不承諾零重新識別風險，也不是法律
判定。

## 決策

原始內部證據中的私人行程已以資料最小化方式完全排除，公開橫屏截圖的系統
列及四張 PNG 的非必要 metadata／trailer 也已修正。修正後的 App 子樹自動
掃描為 0 finding；完整 repository 僅保留上述刻意公開 GitHub 身分。人工
像素、metadata、連結與 motivated-intruder 審查均未留下直接識別碼、credential
或實質重新識別路徑，因此本精確 pre-publication 候選判定為
`passed_after_redaction`。任何後續 commit 或檔案變動都會使本判定失效。
