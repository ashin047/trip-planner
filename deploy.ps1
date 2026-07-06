# 一鍵部署到 GitHub Pages
# 前置：先跑一次 `gh auth login`（選 GitHub.com → HTTPS → 瀏覽器登入）
# 之後每次更新只要重跑本腳本即可

$ErrorActionPreference = "Stop"
$repo = "trip-planner"

Set-Location $PSScriptRoot

# 確認 gh 已登入
gh auth status | Out-Null
if (-not $?) { Write-Host "請先執行 gh auth login" -ForegroundColor Red; exit 1 }

# 首次：建立遠端 repo 並推送
$hasRemote = git remote 2>$null | Select-String origin
if (-not $hasRemote) {
    gh repo create $repo --public --source . --push
    # 開啟 GitHub Pages（main branch 根目錄）
    $owner = gh api user --jq .login
    gh api -X POST "repos/$owner/$repo/pages" -f "source[branch]=main" -f "source[path]=/" | Out-Null
    Write-Host "已建立 repo 並開啟 GitHub Pages" -ForegroundColor Green
    Write-Host "網址（約 1-2 分鐘後生效）：https://$owner.github.io/$repo/" -ForegroundColor Cyan
} else {
    # 之後的更新
    git add -A
    git commit -m "update planner"
    git push
    Write-Host "已推送更新，GitHub Pages 會在 1-2 分鐘內更新" -ForegroundColor Green
}
