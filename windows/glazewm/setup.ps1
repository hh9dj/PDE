# Install the GlazeWM config to ~/.glzr/glazewm (old file backed up). Reload GlazeWM afterwards.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/config.yaml" -Target (Join-Path $HOME ".glzr/glazewm/config.yaml") -DryRun:$DryRun
