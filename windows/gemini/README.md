# Gemini CLI

## Dependencies

- `gemini` CLI, installed by the company setup (checked with version 0.67.0).
- `pwsh` 7 (the script uses `ConvertFrom-Json -AsHashtable`).
- `nvim` for the external prompt editor.

## Setup

```powershell
setup_gemini -DryRun    # show what would change
setup_gemini            # apply
```

`setup_gemini` runs `gemini\apply.ps1`. See the details below.

The company manages part of `~/.gemini` (policies, extensions, security and tool settings). These files must not replace company config.

## What this directory does

- `apply.ps1` merges two things into `~/.gemini`. It writes a `*.bak-<timestamp>` backup before any change.
  - `settings.json`: sets only `ui.customThemes.CatppuccinLatte`, `ui.theme` and `general.preferredEditor` (`neovim`). All other keys stay as they are.
  - `keybindings.json`: adds the missing entries of `keybindings.json` (this directory). Existing entries stay.
- `catppuccin-latte.json` is the custom theme.
- `keybindings.json` lists the wanted key bindings.

## Usage

```powershell
pwsh .\apply.ps1 -DryRun   # show what would change
pwsh .\apply.ps1           # apply
```

The script is safe to run again. Run it again if a company update resets `settings.json`.

## Key bindings

- `ctrl+alt+u` / `ctrl+alt+d`: scroll the output (already in your file, kept).
- `ctrl+n` / `ctrl+p`: next / previous in lists (`nav.*`). They already work in completion menus and prompt history.
- `ctrl+n` / `ctrl+p`: down / up in dialogs too (`nav.dialog.*`). `ctrl+j` and `ctrl+k` are not bound.
- `ctrl+g`: open the prompt in the external editor. This is the default. The script also makes sure `general.preferredEditor` is `neovim`.
- `ctrl+y`: accept the completion (`suggest.accept`), like in pwsh. The default `ctrl+y` (`app.toggleYolo`) is unbound.
- `shift+tab`: cycle the approval modes. This is the default. With `disableYoloMode` the modes are default, auto_edit and plan.

Gemini adds user bindings to the defaults. It does not remove a default key for you.

## Not changed on purpose

- `policies/`, `extensions/`, `extension_integrity.json`, `.env`, auth files.
- Security, telemetry, `excludeTools` and `mcp` settings.
