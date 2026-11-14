# Tab notification for the zellij-attention plugin (see config.kdl). Called by the gemini hooks (windows/gemini/hooks.json).
# Usage: pwsh -NoProfile -File attention.ps1 waiting|completed
# - Outside zellij, or when this pane has focus: does nothing.
# - Prints nothing and always exits 0: gemini parses hook output as JSON.
param([ValidateSet("waiting", "completed")][string]$State = "completed")

$pane = $env:ZELLIJ_PANE_ID
if (-not $pane) { exit 0 }

try {
    # The plugin clears an icon only on a focus change, so skip the pane that has focus.
    # list-clients prints: CLIENT_ID ZELLIJ_PANE_ID RUNNING_COMMAND
    $focused = zellij action list-clients 2>$null | Select-Object -Skip 1 | ForEach-Object { ($_ -split '\s+')[1] }
    if ($focused -contains "terminal_$pane") { exit 0 }

    # Empty stdin: without a payload zellij pipe reads stdin.
    $null | zellij pipe --name "zellij-attention::${State}::$pane" *> $null
} catch {}
exit 0
