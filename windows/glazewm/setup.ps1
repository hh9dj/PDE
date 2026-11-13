# Install the GlazeWM config to ~/.glzr/glazewm (old file backed up). Reload GlazeWM afterwards.
# -Ultrawide: big left and right gaps, so the windows stay in the middle of the screen.
# -SideGap: the left and right gap in pixels for -Ultrawide (default 700, for a 3440 px wide screen).
param([switch]$DryRun, [switch]$Ultrawide, [int]$SideGap = 1200)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

$source = "$PSScriptRoot/config.yaml"
if ($Ultrawide) {
    $text = Get-Content -Raw $source
    $text = $text -replace "(?m)^(\s+right: )'30px'", "`$1'${SideGap}px'"
    $text = $text -replace "(?m)^(\s+left: )'30px'", "`$1'${SideGap}px'"
    $source = Join-Path ([IO.Path]::GetTempPath()) "config.yaml"
    Set-Content -Path $source -Value $text -NoNewline -Encoding utf8NoBOM
}
Install-PdeConfig -Source $source -Target (Join-Path $HOME ".glzr/glazewm/config.yaml") -DryRun:$DryRun
