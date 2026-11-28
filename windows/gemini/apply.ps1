# Merge the PDE gemini-cli settings into ~/.gemini WITHOUT replacing company config.
# - settings.json: sets only ui.customThemes.<name>, ui.theme and general.preferredEditor (values from settings.json). All other keys stay.
#   Also merges the hook groups of hooks.json (zellij tab notifications, needs setup_zellij). Company hooks stay.
# - keybindings.json: adds the entries of keybindings.json that are missing.
# - GEMINI.md (from AGENTS.md) and skills/: copied from common/ai-harness (one folder per skill; other skills stay).
# A backup (*.bak-<timestamp>) is written before any change. Run again after a company update resets files.
# Usage: pwsh apply.ps1 [-GeminiDir <dir>] [-DryRun]
param(
    [string]$GeminiDir = (Join-Path $HOME ".gemini"),
    [switch]$DryRun
)
$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
$shared = Join-Path $here "../../common/ai-harness"          # AGENTS.md and skills shared with NixOS
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

# settings.json: theme and editor only (values from settings.json)
$want = Get-Content -Raw (Join-Path $here "settings.json") | ConvertFrom-Json -AsHashtable -Depth 20
$settingsPath = Join-Path $GeminiDir "settings.json"
$settings = Read-Json $settingsPath @{}
$theme = Get-Content -Raw (Join-Path $here "catppuccin-latte.json") | ConvertFrom-Json -AsHashtable -Depth 20
if (-not $settings.ContainsKey("ui")) { $settings["ui"] = @{} }
if (-not $settings["ui"].ContainsKey("customThemes")) { $settings["ui"]["customThemes"] = @{} }
$old = $settings["ui"]["customThemes"][$theme.name] | ConvertTo-Json -Depth 20 -Compress
$new = $theme | ConvertTo-Json -Depth 20 -Compress
if (-not $settings.ContainsKey("general")) { $settings["general"] = @{} }
$changed = ($old -ne $new) -or ($settings["ui"]["theme"] -ne $want.ui.theme) -or ($settings["general"]["preferredEditor"] -ne $want.general.preferredEditor)
$settings["ui"]["customThemes"][$theme.name] = $theme
$settings["ui"]["theme"] = $want.ui.theme
$settings["general"]["preferredEditor"] = $want.general.preferredEditor

# hooks: zellij tab notifications (windows/gemini/hooks.json). Company hook groups stay.
# Groups that call zellij\attention.ps1 are PDE groups: they are removed, then the groups of hooks.json are added.
$pdeHooks = Get-Content -Raw (Join-Path $here "hooks.json") | ConvertFrom-Json -AsHashtable -Depth 20
if (-not $settings.ContainsKey("hooks")) { $settings["hooks"] = @{} }
$oldHooks = $settings["hooks"] | ConvertTo-Json -Depth 20 -Compress
$isPde = { param($group) @($group["hooks"] | Where-Object { "$($_["command"])" -like '*zellij\attention.ps1*' }).Count -gt 0 }
foreach ($hookEvent in $pdeHooks.Keys) {
    $groups = @($settings["hooks"][$hookEvent] | Where-Object { $_ -and -not (& $isPde $_) })
    $settings["hooks"][$hookEvent] = @($groups + $pdeHooks[$hookEvent])
}
$changed = $changed -or ($oldHooks -ne ($settings["hooks"] | ConvertTo-Json -Depth 20 -Compress))
Save-Json $settingsPath $settings $changed "settings.json (theme, preferredEditor, hooks)"

# keybindings.json: add missing entries
$kbPath = Join-Path $GeminiDir "keybindings.json"
$existing = @(Read-Json $kbPath @())
$wanted = @(Get-Content -Raw (Join-Path $here "keybindings.json") | ConvertFrom-Json -AsHashtable -Depth 20)
$sig = { param($e) ($e | ConvertTo-Json -Compress -Depth 5) }
$have = @($existing | ForEach-Object { & $sig $_ })
$kbChanged = $false
# Entries an earlier version of this script added and that are no longer wanted
$obsolete = @(
    '{"command":"nav.dialog.down","keys":["ctrl+n","ctrl+j"]}'
    '{"command":"nav.dialog.up","keys":["ctrl+p","ctrl+k"]}'
)
$kept = @($existing | Where-Object { $obsolete -notcontains (& $sig $_) })
if ($kept.Count -ne $existing.Count) { $existing = $kept; $kbChanged = $true }
foreach ($w in $wanted) {
    if ($have -notcontains (& $sig $w)) { $existing += $w; $kbChanged = $true }
}
Save-Json $kbPath $existing $kbChanged "keybindings.json"

# GEMINI.md and skills/ (shared with NixOS in common/ai-harness).
Install-PdeConfig -Source (Join-Path $shared "AGENTS.md") -Target (Join-Path $GeminiDir "GEMINI.md") -DryRun:$DryRun
# One folder per skill so company or other skills in ~/.gemini/skills stay put.
# Backups go in $GeminiDir (not skills/) so gemini-cli does not load backup folders as skills.
foreach ($skill in Get-ChildItem (Join-Path $shared "skills") -Directory) {
    $target = Join-Path $GeminiDir "skills" $skill.Name
    if (Test-PdeSame $skill.FullName $target) { Write-Host "up to date  $target"; continue }
    $backup = if (Test-Path $target) { Join-Path $GeminiDir "skill-$($skill.Name).bak-$stamp" }
    if ($DryRun) { Write-Host "would copy  $($skill.FullName) -> $target$(if ($backup) { " (backup: $backup)" })"; continue }
    if ($backup) { Move-Item $target $backup; Remove-PdeOldBackups -Target (Join-Path $GeminiDir "skill-$($skill.Name)") }
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Copy-Item (Join-Path $skill.FullName "*") $target -Recurse -Force
    Write-Host "installed   $target$(if ($backup) { " (backup: $backup)" })"
}
