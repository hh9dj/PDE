# Install the Windows PDE tools with Scoop (user space, no administrator rights).
# Usage: pwsh -ExecutionPolicy Bypass -File .\install.ps1
# Safe to run again: installed apps are skipped.

$ErrorActionPreference = "Stop"

# Scoop
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

# Git is required to add buckets
scoop install git

# Buckets
$buckets = scoop bucket list | ForEach-Object { $_.Name }
foreach ($bucket in @("extras", "nerd-fonts")) {
    if ($bucket -notin $buckets) {
        scoop bucket add $bucket
    }
}

# Apps
$apps = @(
    # shell and terminal
    "pwsh"
    "alacritty"
    "zellij"
    "television"
    "starship"
    "JetBrainsMono-NF"

    # editor
    "neovim"

    # CLI tools (same as common/zsh)
    "ripgrep"
    "fd"
    "fzf"
    "zoxide"
    "bat"
    "eza"
    "delta"
    "jq"
    "lazygit"
    "yazi"
    "btop"
    "mise"
    "hyperfine"
    "ast-grep"

    # desktop
    "glazewm"
    "flow-launcher"
)

$failed = @()
foreach ($app in $apps) {
    scoop install $app
    if ($LASTEXITCODE -ne 0) {
        $failed += $app
    }
}

# Persistent user environment variables.
# These are needed by programs that do not start from the PowerShell profile
# (for example Zellij started directly by WezTerm).
$userEnv = @{
    EDITOR            = "nvim"
    VISUAL            = "nvim"
    ZELLIJ_CONFIG_DIR = "$env:USERPROFILE\.config\zellij"
}
foreach ($name in $userEnv.Keys) {
    [Environment]::SetEnvironmentVariable($name, $userEnv[$name], "User")
}

if ($failed.Count -gt 0) {
    Write-Warning "Not installed: $($failed -join ', '). Check proxy access or use the fallback in each tool README."
    exit 1
}
Write-Host "Done. Open a new terminal."
