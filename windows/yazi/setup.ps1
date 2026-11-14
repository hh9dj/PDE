# Install the yazi config (source: common/yazi/conf, shared with NixOS) to ~/.config/yazi.
# yazi reads %APPDATA%\yazi\config on Windows, so the user variable YAZI_CONFIG_HOME must point to ~/.config/yazi.
# yazi needs file(1) for MIME detection: the one from Git for Windows (scoop), set with YAZI_FILE_ONE.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$config = Join-Path $HOME ".config/yazi"
Install-PdeConfig -Source "$PSScriptRoot/../../common/yazi/conf" -Target $config -DryRun:$DryRun

function Set-PdeUserVariable {
    param([string]$Name, [string]$Want)
    $have = [Environment]::GetEnvironmentVariable($Name, "User")
    if ($have -eq $Want) { Write-Host "up to date  user variable $Name"; return }
    if ($have) { Write-Warning "User variable $Name is '$have', not '$Want'. Not changed."; return }
    if ($DryRun) { Write-Host "would set   user variable $Name=$Want"; return }
    [Environment]::SetEnvironmentVariable($Name, $Want, "User")
    Write-Host "set         user variable $Name=$Want (open a new terminal)"
}

if ($IsWindows) {
    Set-PdeUserVariable "YAZI_CONFIG_HOME" $config
    $file = Join-Path $HOME "scoop/apps/git/current/usr/bin/file.exe"
    if (Test-Path $file) {
        Set-PdeUserVariable "YAZI_FILE_ONE" $file
    } else {
        Write-Warning "file.exe of Git for Windows not found ($file). Install git with scoop (install.ps1), then run setup_yazi again."
    }
}
