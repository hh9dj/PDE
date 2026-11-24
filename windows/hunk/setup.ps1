# Install the hunk config (source: common/hunk/config.toml, shared with NixOS),
# the hunk-review-plan extension, and the hunk skills for gemini.
# - config.toml -> ~/.config/hunk (hunk reads $XDG_CONFIG_HOME/hunk)
# - hunk-review-plan extension -> ~/.config/hunk/extensions/hunk-review-plan
# - hunk-review-plan skill -> ~/.gemini/skills/hunk-review-plan
# - hunk-review skill: the one bundled with the installed hunk (`hunk skill path`) -> ~/.gemini/skills/hunk-review.
#   Run setup_hunk again after a hunk upgrade to refresh it. Other extensions (hunk-backup) and hunk-extensions skill are not installed.
param([switch]$DryRun)
$ErrorActionPreference = "Stop"
. "$PSScriptRoot/../scripts/lib.ps1"

Install-PdeConfig -Source "$PSScriptRoot/../../common/hunk/config.toml" -Target (Join-Path $HOME ".config/hunk/config.toml") -DryRun:$DryRun
Install-PdeConfig -Source "$PSScriptRoot/../../common/hunk/extensions/hunk-review-plan" -Target (Join-Path $HOME ".config/hunk/extensions/hunk-review-plan") -Replace -DryRun:$DryRun
Install-PdeConfig -Source "$PSScriptRoot/../../common/ai-harness/shared/skills/hunk-review-plan" -Target (Join-Path $HOME ".gemini/skills/hunk-review-plan") -Replace -DryRun:$DryRun

if (-not (Get-Command hunk -ErrorAction SilentlyContinue)) {
    Write-Warning "hunk not found, bundled hunk-review skill not installed. Run setup_mise (npm:hunkdiff), mise install, then setup_hunk again."
    return
}
$skill = (hunk skill path hunk-review | Select-Object -First 1).Trim()
if (-not (Test-Path $skill)) { throw "hunk skill path returned a path that does not exist: $skill" }
Install-PdeConfig -Source (Split-Path $skill) -Target (Join-Path $HOME ".gemini/skills/hunk-review") -DryRun:$DryRun
