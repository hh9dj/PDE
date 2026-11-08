# Merge the PDE gemini-cli settings into ~/.gemini WITHOUT replacing company config.
# - settings.json: sets only ui.customThemes.<name>, ui.theme and general.preferredEditor. All other keys stay.
# - keybindings.json: adds the entries of ./keybindings.json that are missing.
# A backup (*.bak-<timestamp>) is written before any change. Run again after a company update resets files.
# Usage: pwsh apply.ps1 [-GeminiDir <dir>] [-DryRun]
param(
    [string]$GeminiDir = (Join-Path $HOME ".gemini"),
    [switch]$DryRun
)
$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
. "$here/../scripts/lib.ps1"
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"

function Read-Json($path, $default) {
    if (-not (Test-Path $path)) { return $default }
    $raw = Get-Content -Raw $path
    if ([string]::IsNullOrWhiteSpace($raw)) { return $default }
    return $raw | ConvertFrom-Json -AsHashtable -Depth 20
}

function Save-Json($path, $data, $changed, $label) {
    if (-not $changed) { Write-Host "$label : unchanged"; return }
    if ($DryRun) { Write-Host "$label : would change (dry run)"; return }
    if (Test-Path $path) { Copy-Item $path "$path.bak-$stamp"; Remove-PdeOldBackups -Target $path }
    New-Item -ItemType Directory -Force -Path (Split-Path $path) | Out-Null
    $json = $data | ConvertTo-Json -Depth 20
    Set-Content -Path $path -Value $json -Encoding utf8NoBOM
    Write-Host "$label : updated"
}

# settings.json: theme only
$settingsPath = Join-Path $GeminiDir "settings.json"
$settings = Read-Json $settingsPath @{}
$theme = Get-Content -Raw (Join-Path $here "catppuccin-latte.json") | ConvertFrom-Json -AsHashtable -Depth 20
if (-not $settings.ContainsKey("ui")) { $settings["ui"] = @{} }
if (-not $settings["ui"].ContainsKey("customThemes")) { $settings["ui"]["customThemes"] = @{} }
$old = $settings["ui"]["customThemes"][$theme.name] | ConvertTo-Json -Depth 20 -Compress
$new = $theme | ConvertTo-Json -Depth 20 -Compress
if (-not $settings.ContainsKey("general")) { $settings["general"] = @{} }
$changed = ($old -ne $new) -or ($settings["ui"]["theme"] -ne $theme.name) -or ($settings["general"]["preferredEditor"] -ne "neovim")
$settings["ui"]["customThemes"][$theme.name] = $theme
$settings["ui"]["theme"] = $theme.name
$settings["general"]["preferredEditor"] = "neovim"
Save-Json $settingsPath $settings $changed "settings.json (theme, preferredEditor)"

# keybindings.json: add missing entries
$kbPath = Join-Path $GeminiDir "keybindings.json"
$existing = @(Read-Json $kbPath @())
$wanted = @(Get-Content -Raw (Join-Path $here "keybindings.json") | ConvertFrom-Json -AsHashtable -Depth 20)
$sig = { param($e) ($e | ConvertTo-Json -Compress -Depth 5) }
$have = @($existing | ForEach-Object { & $sig $_ })
$kbChanged = $false
foreach ($w in $wanted) {
    if ($have -notcontains (& $sig $w)) { $existing += $w; $kbChanged = $true }
}
Save-Json $kbPath $existing $kbChanged "keybindings.json"
