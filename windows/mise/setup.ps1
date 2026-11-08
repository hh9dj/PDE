# Install the PDE mise tools file to ~/.config/mise/conf.d/pde.toml.
# conf.d is read together with the existing ~/.config/mise/config.toml, which stays untouched.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/pde.toml" -Target (Join-Path $HOME ".config/mise/conf.d/pde.toml") -DryRun:$DryRun
if (-not $DryRun) { Write-Host "Next: mise install (downloads through the company npm registry)" }
