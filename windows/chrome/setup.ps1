# Install the Chrome keyboard workaround (AutoHotkey v2 script + link hints bookmarklet).
# - vim-nav.ahk -> ~/.config/chrome-nav/, started at login (Startup shortcut, Windows only)
# - hints.bookmarklet.txt is created next to it and copied to the clipboard.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$dir = Join-Path $HOME ".config/chrome-nav"
Install-PdeConfig -Source "$PSScriptRoot/vim-nav.ahk" -Target (Join-Path $dir "vim-nav.ahk") -DryRun:$DryRun

# One line, no comments in hints.js, so joining the lines is safe.
$js = (Get-Content "$PSScriptRoot/hints.js") | ForEach-Object { $_.Trim() }
$bookmarklet = "javascript:" + ($js -join " ")
$mark = Join-Path $dir "hints.bookmarklet.txt"
if ($DryRun) { Write-Host "would write $mark" }
else {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Set-Content -Path $mark -Value $bookmarklet -NoNewline -Encoding utf8NoBOM
    Write-Host "wrote       $mark"
    if (Get-Command Set-Clipboard -ErrorAction SilentlyContinue) {
        try { Set-Clipboard -Value $bookmarklet; Write-Host "bookmarklet copied to the clipboard" } catch { }
    }
}

if ($IsWindows -and -not $DryRun) {
    $ahk = (Get-Command autohotkey -ErrorAction SilentlyContinue).Source
    if (-not $ahk) { Write-Warning "autohotkey not found. Run: scoop install autohotkey"; return }
    $lnk = Join-Path ([Environment]::GetFolderPath("Startup")) "chrome-nav.lnk"
    $sh = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
    $sh.TargetPath = $ahk
    $sh.Arguments = '"' + (Join-Path $dir "vim-nav.ahk") + '"'
    $sh.Save()
    Write-Host "startup shortcut $lnk"
    Start-Process $ahk -ArgumentList ('"' + (Join-Path $dir "vim-nav.ahk") + '"')
}
Write-Host "Next: add the bookmark (see windows/chrome/README.md)."
