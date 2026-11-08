# Install the PowerShell profile to $PROFILE and fzf.ps1 next to it (old files backed up).
# After the first manual copy of profile.ps1, run setup_profile in a new terminal to update it.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/profile.ps1" -Target $PROFILE -DryRun:$DryRun
Install-PdeConfig -Source "$PSScriptRoot/../fzf/fzf.ps1" -Target (Join-Path (Split-Path $PROFILE) "fzf.ps1") -DryRun:$DryRun
