# Gemini CLI

## Dependencies

- `gemini` (company install, checked with 0.67.0), `pwsh` 7, `nvim`.

## Setup

`setup_gemini` (runs `apply.ps1`, `-DryRun` works). It merges into `~\.gemini` and never replaces company config:

- `settings.json`: only `ui.customThemes.CatppuccinLatte`, `ui.theme`, `general.preferredEditor = neovim`.
- `keybindings.json`: adds the missing entries of `keybindings.json`.

Run it again after a company update resets the files.

## Keys

- `ctrl+y`: accept completion (the default YOLO toggle on `ctrl+y` is removed).
- `ctrl+n` / `ctrl+p`: down / up in lists and dialogs.
- `ctrl+alt+u` / `ctrl+alt+d`: scroll the output.
- `ctrl+e`: open the prompt in nvim, like `Ctrl+e` in pwsh (the default end-of-line on `ctrl+e` is removed, `End` still works).
- Defaults kept: `ctrl+g` prompt in nvim, `shift+tab` approval modes.

## Not changed

- `policies/`, `extensions/`, `.env`, auth, security, telemetry, `mcp` settings.
