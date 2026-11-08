# Shared helpers for the PDE setup scripts. Dot-source it: . "$PSScriptRoot\..\scripts\lib.ps1"

function Get-PdeTimestamp { Get-Date -Format "yyyyMMdd-HHmmss" }

# True when every file of $Source exists in $Target with the same content.
function Test-PdeSame {
    param([string]$Source, [string]$Target)
    if (-not (Test-Path $Target)) { return $false }
    if (Test-Path $Source -PathType Leaf) {
        if (-not (Test-Path $Target -PathType Leaf)) { return $false }
        return (Get-FileHash $Source).Hash -eq (Get-FileHash $Target).Hash
    }
    $root = (Resolve-Path $Source).Path
    foreach ($file in Get-ChildItem $Source -Recurse -File) {
        $rel = $file.FullName.Substring($root.Length).TrimStart('\', '/')
        $dest = Join-Path $Target $rel
        if (-not (Test-Path $dest -PathType Leaf)) { return $false }
        if ((Get-FileHash $file.FullName).Hash -ne (Get-FileHash $dest).Hash) { return $false }
    }
    return $true
}

# Copy a file or a directory from the repo to its place on this machine.
# - Same content: nothing happens (no backup noise).
# - Different content: the old target is first copied to <target>.bak-<timestamp>.
# - A directory source is overlaid on the target. Extra files in the target stay.
# - With -Replace the old directory is moved to the backup, so no old file mixes with the new config.
function Install-PdeConfig {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Target,
        [switch]$DryRun,
        [switch]$Replace
    )
    if (-not (Test-Path $Source)) { throw "Source not found: $Source" }
    if (Test-PdeSame $Source $Target) { Write-Host "up to date  $Target"; return }

    $backup = $null
    if (Test-Path $Target) { $backup = "$Target.bak-$(Get-PdeTimestamp)" }
    if ($DryRun) {
        Write-Host "would copy  $Source -> $Target$(if ($backup) { " (backup: $backup)" })"
        return
    }
    if ($backup -and $Replace) { Move-Item $Target $backup }
    elseif ($backup) { Copy-Item $Target $backup -Recurse -Force }
    if (Test-Path $Source -PathType Leaf) {
        New-Item -ItemType Directory -Force -Path (Split-Path $Target) | Out-Null
        Copy-Item $Source $Target -Force
    } else {
        New-Item -ItemType Directory -Force -Path $Target | Out-Null
        Copy-Item (Join-Path $Source "*") $Target -Recurse -Force
    }
    Write-Host "installed   $Target$(if ($backup) { " (backup: $backup)" })"
}
