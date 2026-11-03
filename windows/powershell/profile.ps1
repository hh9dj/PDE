# PowerShell 7 profile. Mirrors common/zsh (env vars, aliases, line editing).
# Install: see README.md (copy to $PROFILE).

# ENV VARS
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
$env:BAT_THEME = "Catppuccin Latte"
$env:ZELLIJ_CONFIG_DIR = "$env:USERPROFILE\.config\zellij"

[Environment]::SetEnvironmentVariable("http_proxy",  "http://proxy.example:8080", "User")
[Environment]::SetEnvironmentVariable("https_proxy", "http://proxy.example:8080", "User")

# LINE EDITING (zsh: emacs keymap + autosuggestions)
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -MaximumHistoryCount 5000
Set-PSReadLineOption -HistoryNoDuplicates
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+y -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord Ctrl+o -Function ForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord Ctrl+n -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord Ctrl+e -Function ViEditVisually
Set-PSReadLineKeyHandler -Chord Ctrl+Spacebar -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# ALIASES
# Remove built-in aliases that collide with the names below
# (gl = Get-Location, gp = Get-ItemProperty, ls = Get-ChildItem).
foreach ($name in @("gl", "gp", "ls")) {
    Remove-Alias -Name $name -Force -ErrorAction SilentlyContinue
}

# git
function gsw { git switch @args }
function gclean { git clean -f @args }
function grs { git restore @args }
function ga { git add @args }
function gaa { git add --all @args }
function gst { git status @args }
function gss { git status --short @args }
function gcam { git commit -a -m @args }
function gcmsg { git commit -m @args }
function gl { git pull @args }
function gll { git log --oneline @args }
function gp { git push @args }
function gd { git diff @args }
function gds { git diff --staged @args }

# eza (same as Home Manager eza integration)
function ls { eza @args }
function ll { eza -l @args }
function la { eza -a @args }
function lt { eza --tree @args }
function lla { eza -la @args }
function tree { eza --tree @args }

# misc
function e { & $env:EDITOR @args }
function c { Clear-Host }
function .. { Set-Location .. }
function dotconf { Set-Location "$env:USERPROFILE\.config" }
function nvim_shada_clear { Remove-Item "$env:LOCALAPPDATA\nvim-data\shada\main.shada" }
function pbench { hyperfine --warmup 5 "pwsh -NoLogo -Command exit" }
function reload { . $PROFILE }

# go to the Git repository root
function croot {
    $root = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0) {
        Set-Location $root
    }
}

# INTEGRATIONS (only if the tool is installed)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
# zoxide replaces cd (zsh: --cmd cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
}
