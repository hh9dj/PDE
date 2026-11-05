# fzf

Command-line fuzzy finder.

## Role in the stack

- Primary fuzzy finder.
- Filters files, history, branches, and command output.

## Installation

Preferred:

```powershell
scoop install fzf
```

Check availability with:

```powershell
scoop search fzf
```

## Configuration

`fzf.ps1` binds `Ctrl+r` in PowerShell to an fzf search of the shell history.

- Reads the PSReadLine history file, newest first, without duplicates.
- Starts with the text already typed on the line as the query.
- `Enter` puts the selected command on the prompt. It does not run it.
- Needs `fzf` in `PATH`. It does not need the PSFzf module.

Install:

```powershell
Copy-Item .\fzf.ps1 (Join-Path (Split-Path $PROFILE) "fzf.ps1")
```

The profile (`windows/powershell/profile.ps1`) loads this file if it exists. Copy it again after each change, or use a symbolic link like the profile.

## Alternatives

### Telescope (inside Neovim)

- Fuzzy search inside Neovim.
- Use it when working inside the editor.

### PowerShell filtering

- Filter pipeline output manually.
- No fuzzy matching.

## Documentation

https://github.com/junegunn/fzf
