# Install the PDE mise tools file to ~/.config/mise/conf.d/pde.toml.
# conf.d is read together with the existing ~/.config/mise/config.toml, which stays untouched.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/pde.toml" -Target (Join-Path $HOME ".config/mise/conf.d/pde.toml") -DryRun:$DryRun

# Shims: small executables in one folder (<mise data>/shims), one per installed tool.
# With the folder in the user PATH, programs that do not start from pwsh (editors, GUI apps, python
# subprocesses, other terminals) find node, python and the other mise tools too.
if ($IsWindows) {
    $data = if ($env:MISE_DATA_DIR) { $env:MISE_DATA_DIR } else { Join-Path $env:LOCALAPPDATA "mise" }
    $shims = Join-Path $data "shims"
    $user = [Environment]::GetEnvironmentVariable("Path", "User")
    $parts = @($user -split ";" | Where-Object { $_ })
    if ($parts -contains $shims) {
        Write-Host "up to date  shims dir is in the user PATH ($shims)"
    } elseif ($DryRun) {
        Write-Host "would add   $shims to the user PATH"
    } else {
        [Environment]::SetEnvironmentVariable("Path", (@($shims) + $parts) -join ";", "User")
        Write-Host "added       $shims to the user PATH (open a new terminal)"
    }
    if (-not $DryRun -and (Get-Command mise -ErrorAction SilentlyContinue)) { mise reshim }
}
if (-not $DryRun) { Write-Host "Next: mise install (downloads through the company npm registry), then run setup_mise again to refresh the shims" }
