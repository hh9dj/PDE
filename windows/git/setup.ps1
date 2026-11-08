# Install the extra git config to ~/.config/git/config. ~/.gitconfig (company settings) is not touched.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/config" -Target (Join-Path $HOME ".config/git/config") -DryRun:$DryRun
