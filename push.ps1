# 一鍵上傳 GitHub
# 用法：直接執行 upload.bat，或 powershell -File push.ps1 "自訂 commit 訊息"
param([string]$Message)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$repo = $PSScriptRoot
Set-Location $repo

function Fail($msg) { Write-Host ""; Write-Host "[失敗] $msg" -ForegroundColor Red; Read-Host "按 Enter 關閉"; exit 1 }

# 找 git
$git = (Get-Command git -ErrorAction SilentlyContinue)
if (-not $git) { Fail "找不到 git，請確認 Git 已安裝且在 PATH 中。" }

if (-not (Test-Path (Join-Path $repo ".git"))) { Fail "這個資料夾不是 git repo。" }

Write-Host "=== 生管 KPI 看板：上傳 GitHub ===" -ForegroundColor Cyan
Write-Host "資料夾：$repo"
Write-Host ""

# 1. 加入所有變更
git add -A
if ($LASTEXITCODE -ne 0) { Fail "git add 失敗。" }

# 2. 有變更才 commit
$changes = git diff --cached --name-only
if ([string]::IsNullOrWhiteSpace($changes)) {
    Write-Host "沒有新的檔案變更，略過 commit。" -ForegroundColor Yellow
} else {
    Write-Host "本次上傳的檔案：" -ForegroundColor Green
    $changes -split "`n" | Where-Object { $_ } | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""
    if ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = "更新看板 " + (Get-Date -Format "yyyy-MM-dd HH:mm")
    }
    git commit -m $Message
    if ($LASTEXITCODE -ne 0) { Fail "git commit 失敗（可能尚未設定 user.name / user.email）。" }
}

# 3. 推上 GitHub
$remote = git remote
if ([string]::IsNullOrWhiteSpace($remote)) { Fail "尚未設定 remote origin，請先建立 GitHub repo 並連結。" }

$branch = (git rev-parse --abbrev-ref HEAD).Trim()
Write-Host ""
Write-Host "推送到 origin/$branch ..." -ForegroundColor Cyan
git push -u origin $branch
if ($LASTEXITCODE -ne 0) { Fail "git push 失敗，請看上方訊息（多半是認證或網路問題）。" }

Write-Host ""
Write-Host "[完成] 已上傳 GitHub。" -ForegroundColor Green
$url = git remote get-url origin
Write-Host "Repo：$url"
Write-Host "網頁更新需等 GitHub Pages 建置約 1 分鐘。"
Write-Host ""
Read-Host "按 Enter 關閉"
