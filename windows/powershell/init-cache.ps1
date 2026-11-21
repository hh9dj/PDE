# Write the init scripts of the shell integrations (tv, starship, mise, wt, zoxide) to a cache dir.
# The profile dot-sources these files, so no tool process starts when pwsh opens.
# Run it again after a tool upgrade: pde_init_cache (setup_profile also runs it).
# Cache dir: $env:PDE_INIT_CACHE, default %LOCALAPPDATA%\pde\init.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"

$dir = $env:PDE_INIT_CACHE ?? (Join-Path $env:LOCALAPPDATA "pde\init")

# Each generator returns the init script, or $null when the tool is not installed (its cache file is then removed).
$generators = [ordered]@{
    tv       = {
        if (Get-Command tv -ErrorAction SilentlyContinue) { tv init power-shell | Out-String }
    }
    # --print-full-init: the full script. The plain init output only starts starship a second time to get it.
    starship = {
        if (Get-Command starship -ErrorAction SilentlyContinue) { starship init powershell --print-full-init | Out-String }
    }
    # Opt-in: mise activate also runs "mise hook-env" at each prompt. Without it, the shims dir in the
    # user PATH (setup_mise) gives the same tools, but not the per-directory env vars of mise.toml.
    mise     = {
        if ($env:PDE_MISE_ACTIVATE -and (Get-Command mise -ErrorAction SilentlyContinue)) { mise activate pwsh | Out-String }
    }
    # Windows Terminal also installs a wt.exe alias (WindowsApps): WORKTRUNK_BIN points the wrapper to the real binary.
    wt       = {
        $wtExe = Get-Command wt -CommandType Application -All -ErrorAction SilentlyContinue |
            Where-Object Source -notmatch 'WindowsApps' | Select-Object -First 1
        if ($wtExe) {
            "`$env:WORKTRUNK_BIN = '$($wtExe.Source -replace "'", "''")'`n" +
                (& $wtExe.Source config shell init powershell | Out-String)
        }
    }
    # zoxide replaces cd (zsh: --cmd cd)
    zoxide   = {
        if (Get-Command zoxide -ErrorAction SilentlyContinue) { zoxide init powershell --cmd cd | Out-String }
    }
}

if (-not $DryRun) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
foreach ($name in $generators.Keys) {
    $file = Join-Path $dir "$name.ps1"
    $content = & $generators[$name]
    if ($DryRun) {
        Write-Host "$(if ($content) { "would write $file" } else { "would skip  $name (not installed or disabled)" })"
    } elseif ($content) {
        Set-Content -Path $file -Value $content -Encoding utf8 -NoNewline
        Write-Host "wrote       $file"
    } else {
        Remove-Item $file -ErrorAction SilentlyContinue
        Write-Host "skipped     $name (not installed or disabled)"
    }
}
