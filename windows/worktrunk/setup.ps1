# Install the worktrunk user config to %APPDATA%\worktrunk\config.toml (worktrunk does not read XDG_CONFIG_HOME on Windows).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/config.toml" -Target (Join-Path $env:APPDATA "worktrunk/config.toml") -DryRun:$DryRun
