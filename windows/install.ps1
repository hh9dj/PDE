# Install the Windows PDE tools (user space, no administrator rights).
# - Scoop: apps and fonts (list below).
# - mise: the tools of mise\pde.toml (hunk, lazysql, nvim language servers and formatters).
# Usage: pwsh -ExecutionPolicy Bypass -File .\install.ps1 [-SkipMise]
# Safe to run again: installed apps are skipped. Configs are installed with setup_all (see README.md).
param([switch]$SkipMise)

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
    "deno"
    "yazi"
    "btop"
    "mise"
    "hyperfine"
    "ast-grep"

    # neovim: language servers and tools (the npm ones come from mise, see mise/pde.toml)
    "lua-language-server"
    "marksman"
    "stylua"
    "shfmt"
    "taplo"
    "ruff"
    "zig"
    "make"
    "tree-sitter"

    # desktop
    "glazewm"
    "yasb"
    "flow-launcher"
    "autohotkey"
)

$installed = scoop list | ForEach-Object { $_.Name }
$failed = @()
foreach ($app in $apps) {
    if ($app -in $installed) {
        Write-Host "up to date  $app"
        continue
    }
    scoop install $app
    if ($LASTEXITCODE -ne 0) {
        $failed += $app
    }
}

# Persistent user environment variables.
# These are needed by programs that do not start from the PowerShell profile
# (for example Zellij started directly by a terminal or a launcher).
$userEnv = @{
    EDITOR            = "nvim"
    VISUAL            = "nvim"
    ZELLIJ_CONFIG_DIR = "$env:USERPROFILE\.config\zellij"
}
foreach ($name in $userEnv.Keys) {
    [Environment]::SetEnvironmentVariable($name, $userEnv[$name], "User")
}

# mise tools. Needs node in the global mise config (npm backend, company registry).
# setup.ps1 installs pde.toml and the shims dir. It runs again after the install to create the new shims.
if (-not $SkipMise) {
    $setupMise = Join-Path $PSScriptRoot "mise\setup.ps1"
    if (-not (Get-Command mise -ErrorAction SilentlyContinue)) {
        Write-Warning "mise not found in this session. Open a new terminal and run install.ps1 again."
    } else {
        & $setupMise
        mise install
        if ($LASTEXITCODE -ne 0) {
            $failed += "mise tools"
        } else {
            & $setupMise
        }
    }
}

if ($failed.Count -gt 0) {
    Write-Warning "Not installed: $($failed -join ', '). Check proxy access or the notes in README.md."
    exit 1
}
Write-Host "Done. Open a new terminal, then run setup_all."
