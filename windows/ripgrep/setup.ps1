# Install the ripgrep config to ~/.config/ripgrep/config (the profile sets RIPGREP_CONFIG_PATH to it).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/config" -Target (Join-Path $HOME ".config/ripgrep/config") -DryRun:$DryRun
