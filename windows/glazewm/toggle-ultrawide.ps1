# Switch the installed GlazeWM config between normal and ultrawide layout, then reload GlazeWM.
# Ultrawide: big left and right outer gaps, so the windows stay in the middle of the screen.
# Installed by setup_glazewm to ~/.glzr/glazewm. The YASB layout button ([N]/[U]) runs it.
param([int]$SideGap = 1200)
$ErrorActionPreference = "Stop"

$config = Join-Path $HOME ".glzr/glazewm/config.yaml"
$text = Get-Content -Raw $config
# Only the outer_gap block has left: and right: keys.
$gap = if ($text -match "(?m)^\s+left: '30px'") { "${SideGap}px" } else { "30px" }
$text = $text -replace "(?m)^(\s+(?:left|right): )'\d+px'", "`$1'$gap'"
Set-Content -Path $config -Value $text -NoNewline -Encoding utf8NoBOM
glazewm command wm-reload-config
