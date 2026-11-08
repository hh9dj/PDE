# Install the zellij config to ~/.config/zellij (old files are backed up as *.bak-<timestamp>).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$dir = Join-Path $HOME ".config/zellij"
Install-PdeConfig -Source "$PSScriptRoot/config.kdl" -Target "$dir/config.kdl" -DryRun:$DryRun
Install-PdeConfig -Source "$PSScriptRoot/layouts" -Target "$dir/layouts" -DryRun:$DryRun
