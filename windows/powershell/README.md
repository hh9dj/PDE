# PowerShell 7

Primary shell for the Windows PDE. Provides a Unix-like command experience without WSL.

## Role in the stack

- Default shell in WezTerm.
- Hosts the Starship prompt, zoxide, and CLI aliases.
- Runs alongside Windows PowerShell 5.1.

## Installation

Preferred:

```powershell
scoop install pwsh
```

Fallback:

1. Download the official PowerShell ZIP distribution.
2. Extract it into `%USERPROFILE%\apps\powershell`.
3. Execute `pwsh.exe`.

## Configuration

Find your profile:

```powershell
$PROFILE
```

Create its directory:

```powershell
New-Item -ItemType Directory -Force `
    (Split-Path $PROFILE)
```

Example profile:

```powershell
# Starship prompt
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { zoxide init powershell | Out-String })

# Vi editing mode
Set-PSReadLineOption -EditMode Vi

# History predictions
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Aliases
Set-Alias vim nvim
Set-Alias lg lazygit

# Git repository root
function croot {
    $root = git rev-parse --show-toplevel 2>$null

    if ($LASTEXITCODE -eq 0) {
        Set-Location $root
    }
}

# Reload profile
function reload {
    . $PROFILE
}
```

Avoid aliases that conflict with PowerShell commands or scripts unless you intentionally want to override them.

## Alternatives

### Windows PowerShell 5.1 (fallback)

- Ships with Windows.
- Older language features and slower startup.
- Use when PowerShell 7 cannot be installed.

### Git Bash (fallback)

- POSIX shell included with Git for Windows.
- Provides Bash, SSH, grep, sed and awk.
- Use when a Unix shell is required, but it does not integrate with the PowerShell profile.

## Documentation

https://learn.microsoft.com/powershell/
