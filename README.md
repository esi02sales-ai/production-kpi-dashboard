# 生管 KPI 看板

廠內品質與產能日報,單一 HTML 檔,無需伺服器或安裝套件。

公開網址:<https://esi02sales-ai.github.io/production-kpi-dashboard/>

## 每日更新怎麼做

1. 打開 `index.html`,找到 `<script>` 裡的 `DATA` 物件(檔案後段)
2. 改裡面的數字,存檔
3. 雙擊 `upload.bat`
4. 等約 1 分鐘,重新整理公開網址

版面會依 `DATA` 自動重繪 — 表格、百分比、長條圖、合計都是算出來的,不用手動改。

## DATA 各欄位

| 欄位 | 說明 |
|---|---|
| `updated` / `source` | 頁首的日期與資料來源說明 |
| `hero` | 最上方三張大數字卡。`tone` 可填 `red` / `amber` / `green` |
| `ngTotal` / `ngTop` | NG 總筆數與前三名。百分比由 `count / ngTotal` 算出 |
| `ngNote` | NG 區塊下方的補充說明文字 |
| `util` | 各機群稼動率。`rate: null` 會顯示「節拍存疑,不填」;`lowSample: true` 會加 ⚠ |
| `wip` | 待完成工單。`urgency` 依序為 `[已逾期, 3天內, 一週內, 一週外]` 的筆數 |

`wip` 的筆數、總量、逾期數與急迫度分布全部自動加總,製程也會自動依筆數排序。

## 檔案

| 檔案 | 用途 |
|---|---|
| `index.html` | 看板本體(CSS / JS / 資料都在裡面) |
| `upload.bat` | 一鍵上傳,雙擊即可 |
| `push.ps1` | 上傳的實際邏輯,`upload.bat` 會呼叫它 |

## 上傳指令

雙擊 `upload.bat` 之外,也可以帶自訂 commit 訊息:

```powershell
.\upload.bat "修正切片製程數量"
```

排程或其他腳本呼叫時加 `-NoPause`,結束後不等待按鍵:

```powershell
powershell -ExecutionPolicy Bypass -File push.ps1 -NoPause
```

## 注意

- `.gitignore` 已排除 `.env`、金鑰檔與內部真實數據樣本
- 這是 **public repo**,填進 `index.html` 的資料任何人都能看到。要放真實廠內數據前,請先評估是否改為 private
