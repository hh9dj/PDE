# PowerShell 7 profile. Mirrors common/zsh (env vars, aliases, line editing).
# Install: see README.md (copy to $PROFILE).

# ENV VARS
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
$env:BAT_THEME = "Catppuccin Latte"
$env:ZELLIJ_CONFIG_DIR = "$env:USERPROFILE\.config\zellij"


# LINE EDITING (zsh: emacs keymap + autosuggestions)
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -MaximumHistoryCount 5000
Set-PSReadLineOption -HistoryNoDuplicates
# Keep the cursor at the end of the line after Ctrl+p / Ctrl+n (zsh behavior).
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
# Syntax colors (Catppuccin Latte). The defaults use DarkGray for parameters
# and operators, which is almost invisible on a light background.
Set-PSReadLineOption -Colors @{
    Command                = "`e[38;2;64;160;43m"    # green    #40a02b
    Parameter              = "`e[38;2;30;102;245m"   # blue     #1e66f5
    Default                = "`e[38;2;76;79;105m"    # text     #4c4f69
    String                 = "`e[38;2;23;146;153m"   # teal     #179299
    Variable               = "`e[38;2;136;57;239m"   # mauve    #8839ef
    Keyword                = "`e[38;2;136;57;239m"   # mauve    #8839ef
    Operator               = "`e[38;2;4;165;229m"    # sky      #04a5e5
    Number                 = "`e[38;2;254;100;11m"   # peach    #fe640b
    Member                 = "`e[38;2;114;135;253m"  # lavender #7287fd
    Type                   = "`e[38;2;223;142;29m"   # yellow   #df8e1d
    Comment                = "`e[38;2;124;127;147m"  # overlay2 #7c7f93
    Error                  = "`e[38;2;210;15;57m"    # red      #d20f39
    InlinePrediction       = "`e[38;2;140;143;161m"  # overlay1 #8c8fa1
    ListPrediction         = "`e[38;2;30;102;245m"   # blue     #1e66f5
    ListPredictionSelected = "`e[48;2;204;208;218m"  # surface0 #ccd0da
    Selection              = "`e[48;2;204;208;218m"  # surface0 #ccd0da
    ContinuationPrompt     = "`e[38;2;124;127;147m"  # overlay2 #7c7f93
}
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

# fzf: Ctrl+r history search (file: windows/fzf/fzf.ps1, copy it next to the profile)
$fzfScript = Join-Path (Split-Path $PROFILE) "fzf.ps1"
if (Test-Path $fzfScript) { . $fzfScript }

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
