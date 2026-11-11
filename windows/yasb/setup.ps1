# Install the YASB config to ~/.config/yasb (old files backed up). YASB reloads both files on its own.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$dir = Join-Path $HOME ".config/yasb"
Install-PdeConfig -Source "$PSScriptRoot/config.yaml" -Target (Join-Path $dir "config.yaml") -DryRun:$DryRun
Install-PdeConfig -Source "$PSScriptRoot/styles.css" -Target (Join-Path $dir "styles.css") -DryRun:$DryRun
