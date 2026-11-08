# Install the neovim config. Source of truth: common/nvim/config (shared with NixOS, guarded for Windows).
# Target: %LOCALAPPDATA%\nvim (Linux test: ~/.config/nvim). The old config directory is MOVED to nvim.bak-<timestamp>,
# so old and new files never mix. Plugins are cloned by lazy.nvim at the first start (needs git and network).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$base = if ($IsWindows) { $env:LOCALAPPDATA } else { Join-Path $HOME ".config" }
Install-PdeConfig -Source "$PSScriptRoot/../../common/nvim/config" -Target (Join-Path $base "nvim") -DryRun:$DryRun -Replace
