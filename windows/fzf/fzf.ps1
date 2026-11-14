# fzf integration for PowerShell 7: Ctrl+r searches the shell history.
# Mirrors the zsh fzf integration (Home Manager). No extra module needed.
# Loaded from the profile (see windows/README.md). Needs fzf in PATH.

if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) { return }

Set-PSReadLineKeyHandler -Chord Ctrl+r -BriefDescription FzfHistory -ScriptBlock {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # Newest first, no duplicates. The file holds commands saved so far in all sessions.
    $path = (Get-PSReadLineOption).HistorySavePath
    if (-not (Test-Path $path)) { return }
    $history = [System.Collections.Generic.HashSet[string]]::new()
    $items = @(Get-Content -Path $path | Where-Object { $_.Trim() })
    [array]::Reverse($items)
    $items = $items | Where-Object { $history.Add($_) }

    $selected = $items | fzf --scheme=history --height=40% --reverse --query="$line" --prompt='history> '
    if ($selected) {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($selected)
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
