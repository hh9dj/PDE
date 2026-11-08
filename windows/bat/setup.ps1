# Install the bat config to ~/.config/bat/config (the profile sets BAT_CONFIG_PATH to it).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/config" -Target (Join-Path $HOME ".config/bat/config") -DryRun:$DryRun
