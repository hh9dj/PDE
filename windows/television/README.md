# Television (tv)

Fuzzy finder with channels. Used for the zellij session picker.

## Dependencies

- `tv` (scoop: `scoop install television`).
- `zellij` for the `zellij-sessions` channel.

## Setup

```powershell
setup_television        # copy config.toml and channels to ~\.config\television
setup_television -DryRun
```

- The profile sets `TELEVISION_CONFIG` to `~\.config\television`.
- An existing `config.toml` or `cable` directory is copied to `*.bak-<timestamp>` first.
- Check: `tv list-channels` shows `zellij-sessions`.

## Configured features

- Channel `zellij-sessions` (`cable\zellij-sessions.toml`): lists live zellij sessions (`zellij list-sessions --short --no-formatting`).
  - Enter: attach. Action `kill`: kill the selected session.
- Profile function `za` runs `tv zellij-sessions`.

- `config.toml` (from `common/television/default.nix`):
  - Navigation: `ctrl-n` / `ctrl-j` next, `ctrl-p` / `ctrl-k` previous. `esc` quits.
  - `ctrl-y` copies the entry, `ctrl-o` toggles the preview, `ctrl-t` opens the channel list.
  - Default channel `files`. Landscape layout, preview 50%.
- Channels `files` (fd + bat preview) and `dirs` (fd + eza preview), written for Windows so they do not depend on downloaded channels.
- Shell integration in the profile (`tv init power-shell`):
  - `Ctrl+f`: smart autocomplete. tv picks a channel from the command before the cursor (for example `cd` gives `dirs`, `nvim` gives `files`, `git switch` gives `git-branch`). The fallback channel is `files`.
  - `Ctrl+r` stays on fzf (`windows/fzf/fzf.ps1`). The profile loads fzf after tv, so it wins.

## Defaults changed

- `config.toml` replaces the tv defaults for keys, UI and shell integration triggers.
- Channels `files` and `dirs` override the built-in ones with the same name.
- Clipboard history is not a tv channel: Windows has no command for it. Use `Win+V` or Flow Launcher.

## Manual tests

- `tv list-channels` shows `zellij-sessions`. If it does not, check where tv reads its config on Windows (`tv --help`, `$env:TELEVISION_CONFIG`).
- `Ctrl+f` after `cd ` lists directories. After `git switch ` it lists branches (needs the `git-branch` channel, check `tv list-channels`).
- `ctrl-j` / `ctrl-k` move in tv lists.
- `za` shows live sessions only. Enter attaches.
