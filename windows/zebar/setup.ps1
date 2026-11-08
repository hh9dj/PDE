# Install the zebar widget pack to ~/.glzr/zebar/pde-bar (the pack id is the directory name).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/bar" -Target (Join-Path $HOME ".glzr/zebar/pde-bar") -DryRun:$DryRun
