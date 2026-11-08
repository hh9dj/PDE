# PowerShell 7 profile. Mirrors common/zsh (env vars, aliases, line editing).
# First install: copy this file to $PROFILE once. After that, use setup_profile (see README.md).
# The PDE repo must be in $HOME\PDE (or set $env:PDE_DIR before the profile loads).

# ENV VARS
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
$env:BAT_THEME = "Catppuccin Latte"
$env:ZELLIJ_CONFIG_DIR = "$env:USERPROFILE\.config\zellij"
$env:TELEVISION_CONFIG = "$env:USERPROFILE\.config\television"
$global:PdeDir = $env:PDE_DIR ?? "$env:USERPROFILE\PDE"


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

# PDE SETUP (each setup_<tool> runs windows\<tool>\setup.ps1 from the PDE repo)
# Old config is backed up as <file>.bak-<timestamp>. Add -DryRun to see what would change.
$global:PdeSetupScripts = [ordered]@{
    profile    = "powershell\setup.ps1"
    zellij     = "zellij\setup.ps1"
    starship   = "starship\setup.ps1"
    alacritty  = "alacritty\setup.ps1"
    git        = "git\setup.ps1"
    television = "television\setup.ps1"
    gemini     = "gemini\apply.ps1"
    glazewm    = "glazewm\setup.ps1"
    zebar      = "zebar\setup.ps1"
    flow       = "flow-launcher\setup.ps1"
    tools      = "powershell\install.ps1"
}
foreach ($tool in $global:PdeSetupScripts.Keys) {
    $path = Join-Path $global:PdeDir "windows\$($global:PdeSetupScripts[$tool])"
    Set-Item -Path "function:global:setup_$tool" -Value ([scriptblock]::Create("& '$path' @args"))
}
# Every tool except "tools" (scoop installs, run it once by hand: setup_tools)
function setup_all {
    foreach ($tool in $global:PdeSetupScripts.Keys | Where-Object { $_ -ne "tools" }) {
        Write-Host "== setup_$tool"
        & "setup_$tool" @args
    }
}
function setup_list { $global:PdeSetupScripts.Keys | ForEach-Object { "setup_$_" }; "setup_all" }
function pde_pull { git -C $global:PdeDir pull --ff-only }

# zellij sessions (tmux: t = tmuxp load, ta = tv tmux-sessions). Here: z = layout, za = picker.
# Layout name -> start directory. The repo path can be changed with $env:PDE_DIR.
$global:ZellijLayoutDirs = @{ dots = $global:PdeDir }
function z {
    param([Parameter(Mandatory)][string]$Name)
    if ($global:ZellijLayoutDirs.ContainsKey($Name)) { Set-Location $global:ZellijLayoutDirs[$Name] }
    if (zellij list-sessions --short --no-formatting 2>$null | Where-Object { $_ -eq $Name }) {
        zellij attach $Name
    } else {
        zellij --session $Name --new-session-with-layout $Name
    }
}
function za { tv zellij-sessions }

# INTEGRATIONS (only if the tool is installed)
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
# zoxide replaces cd (zsh: --cmd cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
}
