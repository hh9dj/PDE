# Install the alacritty config to %APPDATA%/alacritty (old file backed up).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/alacritty.toml" -Target (Join-Path $env:APPDATA "alacritty/alacritty.toml") -DryRun:$DryRun
