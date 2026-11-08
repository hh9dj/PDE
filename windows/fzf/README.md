# fzf

Fuzzy finder. Here it powers `Ctrl+r` history search in PowerShell and the zellij session picker.

## Dependencies

- `fzf` (scoop: `scoop install fzf`).
- PSReadLine (bundled with PowerShell 7).

`setup_tools` installs fzf with scoop.

## Setup

`fzf.ps1` is installed next to the profile by `setup_profile` (see `powershell/README.md`). The profile loads it when it exists. No separate step.

## Configured features

- `Ctrl+r`: search the shell history with fzf (newest first, no duplicates, the current line is the query).

## Defaults changed

- `Ctrl+r` is replaced (the PSReadLine reverse search is gone).
- fzf options: `--scheme=history --height=40% --reverse --prompt='history> '`.

## Not done yet

- File and directory completion (`Ctrl+t`, `Alt+c`, tab completion). Planned through television.

## Manual tests

- `Ctrl+r` opens a list at the bottom. Enter puts the command on the prompt without running it.
