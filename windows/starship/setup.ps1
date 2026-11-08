# Install the starship config to ~/.config/starship.toml (old file backed up).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/starship.toml" -Target (Join-Path $HOME ".config/starship.toml") -DryRun:$DryRun
