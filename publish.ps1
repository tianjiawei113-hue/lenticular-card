param([string]$Msg = "")
$ErrorActionPreference = "Stop"
$repo    = $PSScriptRoot
$tokFile = Join-Path (Split-Path $repo -Parent) "gh_token.txt"
$remote  = "https://github.com/tianjiawei113-hue/lenticular-card.git"

Push-Location $repo
try {
  if (-not $Msg) { $Msg = "update " + (Get-Date -Format "yyyy-MM-dd HH:mm") }
  git add -A
  $staged = git diff --cached --name-only
  if (-not $staged) { Write-Host "nothing to commit"; return }
  git commit -m $Msg | Out-Null
  if (Test-Path -LiteralPath $tokFile) {
    $tok = (Get-Content -LiteralPath $tokFile -Raw).Trim()
    git -c http.sslBackend=openssl -c credential.helper= push "https://x-access-token:$tok@github.com/tianjiawei113-hue/lenticular-card.git" HEAD:main
  } else {
    git -c http.sslBackend=openssl push origin HEAD:main
  }
  Write-Host "pushed -> https://tianjiawei113-hue.github.io/lenticular-card/"
} finally { Pop-Location }
