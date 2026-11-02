# zoxide

Smarter `cd` with directory ranking.

## Role in the stack

- Primary directory navigation tool.
- Tracks visited directories and ranks them by frequency.

## Installation

Preferred:

```powershell
scoop install zoxide
```

## Configuration

Enable it from the PowerShell profile:

```powershell
Invoke-Expression (& { zoxide init powershell | Out-String })
```

## Alternatives

### PowerShell function

- Custom `cd` helper in the profile.
- No ranking or history.

### Set-Location

- Native PowerShell directory change.
- No shortcuts.

## Documentation

https://github.com/ajeetdsouza/zoxide
