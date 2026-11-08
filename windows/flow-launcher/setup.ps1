# Apply the Flow Launcher config. Mirrors nixos/fuzzel (layout, font, colors, keys).
# Usage: pwsh -File .\setup.ps1
# Flow Launcher must have run once, so that Settings.json exists.

$ErrorActionPreference = "Stop"

# Scoop installs the portable build (UserData next to the app).
# The installer build uses %APPDATA%\FlowLauncher.
$candidates = @(
    "$env:USERPROFILE\scoop\persist\flow-launcher\UserData"
    "$env:APPDATA\FlowLauncher"
)
$dataDir = $candidates | Where-Object { Test-Path "$_\Settings\Settings.json" } | Select-Object -First 1
if (-not $dataDir) {
    throw "Settings.json not found in: $($candidates -join ', '). Start Flow Launcher once, then run this script again."
}
$settingsPath = "$dataDir\Settings\Settings.json"

# Flow Launcher writes Settings.json when it exits, so stop it first.
$flow = Get-Process -Name "Flow.Launcher" -ErrorAction SilentlyContinue
$exe = $flow | Select-Object -First 1 -ExpandProperty Path
if ($flow) {
    $flow | Stop-Process -Force
    $flow | Wait-Process -Timeout 10 -ErrorAction SilentlyContinue
}

# Settings (only these keys change, the rest of the file is kept)
$values = [ordered]@{
    # GlazeWM uses alt+space for the terminal (hyprland SUPER + D = launcher)
    Hotkey                           = "Alt + D"

    # fuzzel: lines=8, width=40, line-height=38, anchor=center
    MaxResultsToShow                 = 8
    KeepMaxResults                   = $true
    WindowSize                       = 600
    WindowHeightSize                 = 42
    ItemHeightSize                   = 44

    # fuzzel: font=JetBrains Mono:size=14, use-bold=yes
    QueryBoxFont                     = "JetBrainsMono Nerd Font"
    QueryBoxFontWeight               = "Bold"
    QueryBoxFontSize                 = 18
    ResultFont                       = "JetBrainsMono Nerd Font"
    ResultItemFontSize               = 16
    ResultSubFont                    = "JetBrainsMono Nerd Font"
    ResultSubItemFontSize            = 12

    # fuzzel: prompt="Search apps ❯  "
    ShowPlaceholder                  = $true
    PlaceholderText                  = "Search apps $([char]0x276F)"

    # fuzzel: next=Down Control+n Control+j, prev=Up Control+p Control+k
    SelectNextItemHotkey             = "Ctrl + N"
    SelectNextItemHotkey2            = "Ctrl + J"
    SelectPrevItemHotkey             = "Ctrl + P"
    SelectPrevItemHotkey2            = "Ctrl + K"

    # No visual extras (fuzzel has none)
    UseAnimation                     = $false
    UseDropShadowEffect              = $false
    UseClock                         = $false
    UseDate                          = $false

    StartFlowLauncherOnSystemStartup = $true
}

$settings = Get-Content $settingsPath -Raw -Encoding UTF8 | ConvertFrom-Json
foreach ($key in $values.Keys) {
    $settings | Add-Member -NotePropertyName $key -NotePropertyValue $values[$key] -Force
}
Copy-Item $settingsPath "$settingsPath.bak" -Force
$settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath -Encoding UTF8

Write-Host "Applied to $dataDir (backup: Settings.json.bak)."

if ($exe) {
    Start-Process $exe
}
