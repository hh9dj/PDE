# Prevent Windows from sleeping while this process runs. Stop with Ctrl+C.
# -Display: also keep the screen on. -Minutes <n>: stop after n minutes.
# The request ends when the pwsh process ends. Detaching zellij is fine, closing the pane is not.
param(
    [switch]$Display,
    [int]$Minutes = 0
)
$ErrorActionPreference = "Stop"

if (-not ("PdePower" -as [type])) {
    Add-Type @"
using System.Runtime.InteropServices;
public class PdePower {
    [DllImport("kernel32.dll")]
    public static extern uint SetThreadExecutionState(uint flags);
}
"@
}

$ES_CONTINUOUS = [uint32]0x80000000
$ES_SYSTEM_REQUIRED = [uint32]0x00000001
$ES_DISPLAY_REQUIRED = [uint32]0x00000002

$flags = $ES_CONTINUOUS -bor $ES_SYSTEM_REQUIRED
if ($Display) { $flags = $flags -bor $ES_DISPLAY_REQUIRED }

try {
    [PdePower]::SetThreadExecutionState($flags) | Out-Null
    Write-Host "Sleep prevention enabled$(if ($Display) { ' (display on)' })$(if ($Minutes -gt 0) { " for $Minutes min" })."
    Write-Host "Ctrl+C stops it. Check with: powercfg /requests"
    $end = if ($Minutes -gt 0) { (Get-Date).AddMinutes($Minutes) }
    while (-not $end -or (Get-Date) -lt $end) { Start-Sleep -Seconds 1 }
} finally {
    [PdePower]::SetThreadExecutionState($ES_CONTINUOUS) | Out-Null
    Write-Host "Sleep prevention released."
}
