# Install the television config and channels to ~/.config/television (the profile sets TELEVISION_CONFIG to this directory).
# config.toml is shared with Nix (common/television). Only the common channels that work in PowerShell are installed.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$dir = Join-Path $HOME ".config/television"
$common = "$PSScriptRoot/../../common/television"
Install-PdeConfig -Source "$common/config.toml" -Target "$dir/config.toml" -DryRun:$DryRun
foreach ($channel in "git-branch", "git-refs", "git-log", "git-diff", "git-reflog") {
    Install-PdeConfig -Source "$common/cable/$channel.toml" -Target "$dir/cable/$channel.toml" -DryRun:$DryRun
}
# Windows channels last: dirs and files replace nothing from common (not installed above).
Install-PdeConfig -Source "$PSScriptRoot/cable" -Target "$dir/cable" -DryRun:$DryRun
