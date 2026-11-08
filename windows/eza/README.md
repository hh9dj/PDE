# eza

Better `ls` with colors, icons, and Git status.

## Dependencies

- `eza` (scoop: `scoop install eza`).

## Setup

No config file and no setup command. The profile defines the aliases.

## Configured features

- `ls` = `eza`, `ll` = `eza -l`, `la` = `eza -a`, `lla` = `eza -la`, `lt` and `tree` = `eza --tree` (same as Home Manager).
- tv uses `eza` for the `dirs` preview.

## Defaults changed

- The PowerShell alias `ls` (Get-ChildItem) is removed. Use `Get-ChildItem` or `gci` for the original.
- No icons and no custom theme (default colors).

## Manual tests

- `ll` shows a long listing. `lt` shows a tree.

## Role in the stack

- Primary directory listing tool.

## Installation (alternative)

Preferred:

```powershell
scoop install eza
```

## Alternatives

### Get-ChildItem

- Native PowerShell directory listing.
- No icons or Git status.

## Documentation

https://github.com/eza-community/eza
