# Install the Chrome scroll keys (AutoHotkey v2 script).
# vim-nav.ahk -> ~/.config/chrome-nav/, started at login (Startup shortcut, Windows only).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$dir = Join-Path $HOME ".config/chrome-nav"
$script = Join-Path $dir "vim-nav.ahk"
Install-PdeConfig -Source "$PSScriptRoot/vim-nav.ahk" -Target $script -DryRun:$DryRun

if ($IsWindows -and -not $DryRun) {
    $ahk = (Get-Command autohotkey -ErrorAction SilentlyContinue).Source
    if (-not $ahk) { Write-Warning "autohotkey not found. Run: scoop install autohotkey"; return }
    $lnk = Join-Path ([Environment]::GetFolderPath("Startup")) "chrome-nav.lnk"
    $sh = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
    $sh.TargetPath = $ahk
    $sh.Arguments = '"' + $script + '"'
    $sh.Save()
    Write-Host "startup shortcut $lnk"
    Start-Process $ahk -ArgumentList ('"' + $script + '"')
}
