# Install the neovim config. Source of truth: common/nvim/config (shared with NixOS, guarded for Windows).
# Target: ~/.config/nvim (needs XDG_CONFIG_HOME=~/.config). The old ~/.config/nvim is MOVED to nvim.bak-<timestamp>,
# so old and new files never mix. Plugins are cloned by lazy.nvim at the first start (needs git and network).
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

# nvim reads $XDG_CONFIG_HOME/nvim on every system, so the config goes to ~/.config/nvim.
# On Windows the user variable XDG_CONFIG_HOME must point to ~/.config (GUI launches and new terminals read it).
$config = Join-Path $HOME ".config"
Install-PdeConfig -Source "$PSScriptRoot/../../common/nvim/config" -Target (Join-Path $config "nvim") -DryRun:$DryRun -Replace

if ($IsWindows) {
    $want = Join-Path $HOME ".config"
    $have = [Environment]::GetEnvironmentVariable("XDG_CONFIG_HOME", "User")
    if ($have -and $have -ne $want) {
        Write-Warning "User variable XDG_CONFIG_HOME is '$have', not '$want'. nvim reads '$have\nvim'. Not changed."
    } elseif (-not $have -and -not $DryRun) {
        [Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $want, "User")
        Write-Host "set user variable XDG_CONFIG_HOME=$want (open a new terminal)"
    } elseif (-not $have) {
        Write-Host "would set user variable XDG_CONFIG_HOME=$want"
    }
}

# C compiler wrapper for treesitter (zig cc). The profile sets CC to it (see windows/README.md).
Install-PdeConfig -Source "$PSScriptRoot/zig-cc.cmd" -Target (Join-Path $HOME ".config/zig-cc/zig-cc.cmd") -DryRun:$DryRun
