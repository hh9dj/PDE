# Install the television channels to ~/.config/television (the profile sets TELEVISION_CONFIG to this directory).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$dir = Join-Path $HOME ".config/television"
Install-PdeConfig -Source "$PSScriptRoot/cable" -Target "$dir/cable" -DryRun:$DryRun
Install-PdeConfig -Source "$PSScriptRoot/config.toml" -Target "$dir/config.toml" -DryRun:$DryRun
