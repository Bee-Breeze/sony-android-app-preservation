# 公開資料去識別化審查

- 候選：2D Code Scanner `1.0.2.A.0.1` portable v2
- 用途：公開保存文件、可重現 patchset 與實機功能證據
- 對象／渠道：公開 GitHub repository
- 審查日期：2026-07-20
- 發布模式：`patchset_only`
- Pre-publication 決策：`passed_after_redaction`

## 範圍與最小化

公開候選只保留繁體中文文件、專案自有 build／verify 工具、兩張實機截圖。
Sony 原始／重簽 APK、完整反編譯程式碼、keystore、logcat、UI hierarchy、
裝置序號及內部絕對路徑均不納入。私人完整原始證據另留研究樹。

## 自動與人工檢查

候選使用 `check_public_release.py` 掃描檔案與 Git 歷史，並以可用的
`gitleaks` 或等價秘密掃描器複查。兩張 PNG 以原始解析度逐張檢視，已裁除
狀態列與導覽列、刪除 ICC／Exif 等非必要 metadata，且 `IEND` 後沒有資料。

App 子樹最終 inventory 為 13 個檔案、0 finding，`gitleaks` 為 0 leak。
完整 repository 與可到達 Git 歷史掃描列出 16 筆 email finding：兩筆在
公開隱私紀錄，其餘位於 Git author／committer 或 patch metadata；
全部是 repository 擁有者刻意公開的 GitHub noreply 身分
`Bee-Breeze@users.noreply.github.com`，逐項判讀後保留，沒有私人 email。
完整歷史 `gitleaks` 仍為 0 leak。

畫面只含 App 的繁中掃描提示、公開測試網址與 IANA Example Domain；沒有
帳號、通知、照片、聯絡人、位置、網路名稱、序號、token 或私人瀏覽內容。

## Motivated-intruder 測試

- `singling_out`：沒有個人、帳號、穩定 pseudonym 或裝置識別碼。
- `linkability`：package、版本、裝置類別及 artifact hash 僅供技術稽核，
  無法由候選連回私人內容。
- `inference`：只能推知明列 App 曾在明列裝置類別測試。

## 發現、修正與殘餘風險

原始截圖含狀態列時間與系統圖示，因此公開副本裁除系統列並移除 metadata；
完整 log 與 UI tree 也因包含裝置時序／識別資訊而排除。任何內容、截圖、
hash、commit、tag 或 Git 歷史變更都必須重新掃描與人工審查。

本次為 human-supervised owner review，不宣稱獨立隱私專家或法律審查。
修正後未留下直接識別碼、credential 或實質重新識別路徑，判定為
`passed_after_redaction`。
