# bat

Better `cat` with syntax highlighting and pagination.

## Dependencies

- `bat` 0.25 or newer (scoop: `scoop install bat`). The theme `Catppuccin Latte` is built in.

## Setup

```powershell
setup_bat               # copy config to ~\.config\bat\config
setup_bat -DryRun
```

- The profile sets `BAT_CONFIG_PATH` to that file and `BAT_THEME` to `Catppuccin Latte`.
- An existing file is copied to `config.bak-<timestamp>` first.

## Configured features

- Theme `Catppuccin Latte` (same as Home Manager).
- Profile function `cat` runs `bat --paging=never`. When the output is piped, bat prints plain text like cat.

## Defaults changed

- Theme only. Style, paging and syntax maps stay at the bat defaults.
- The PowerShell alias `cat` (Get-Content) is removed. Use `Get-Content` for the original.

## Manual tests

- `bat --list-themes | Select-String Latte` shows `Catppuccin Latte`. If not, update bat.
- `cat README.md` shows colors that are readable on a light background.

## Role in the stack

- Primary file viewer.
- Adds syntax highlighting and Git diff markers.

## Installation

Preferred:

```powershell
scoop install bat
```

## Alternatives

### Get-Content

- Native PowerShell file reader.
- No syntax highlighting or pagination.

## Documentation

https://github.com/sharkdp/bat
