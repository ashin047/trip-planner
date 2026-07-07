# 一鍵部署到 shinshing.tw/planner/
# 前置（只做一次）：把 ftp-config.local.json.example 複製成 ftp-config.local.json，填入 FTP 資訊
# 之後每次更新：直接執行本腳本

$ErrorActionPreference = "Stop"
$cfgPath = Join-Path $PSScriptRoot "ftp-config.local.json"
if (-not (Test-Path $cfgPath)) {
    Write-Host "❌ 找不到 ftp-config.local.json — 請先複製 ftp-config.local.json.example 並填入 FTP 資訊" -ForegroundColor Red
    exit 1
}
$cfg = Get-Content $cfgPath -Raw -Encoding UTF8 | ConvertFrom-Json
$src = Join-Path $PSScriptRoot "index.html"

Write-Host "上傳 index.html 到 $($cfg.host)/$($cfg.remoteDir)/ ..."
# Windows 內建 curl；--ssl 表示主機支援時走加密 FTP；--ftp-create-dirs 自動建立 planner 目錄
& curl.exe -sS --ssl -T $src "ftp://$($cfg.host)/$($cfg.remoteDir)/index.html" --user "$($cfg.user):$($cfg.password)" --ftp-create-dirs
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 上傳失敗（檢查 FTP 位址/帳密/目錄路徑）" -ForegroundColor Red
    exit 1
}

# 驗證線上版本
Start-Sleep -Seconds 2
try {
    $r = Invoke-WebRequest -Uri "https://shinshing.tw/planner/?v=$(Get-Random)" -UseBasicParsing -TimeoutSec 15
    if ($r.StatusCode -eq 200 -and $r.Content -match "trip-map-planner|SITE_CONFIG") {
        Write-Host "✅ 部署成功：https://shinshing.tw/planner/" -ForegroundColor Green
    } else {
        Write-Host "⚠️ 已上傳但驗證異常（HTTP $($r.StatusCode)），請手動打開網址確認" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️ 已上傳但網址打不開：$($_.Exception.Message)（可能目錄路徑不對，常見正確值：public_html/planner 或 www/planner 或 htdocs/planner）" -ForegroundColor Yellow
}
