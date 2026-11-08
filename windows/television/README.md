# Television (tv)

Fuzzy finder with channels. Used for the zellij session picker.

## Dependencies

- `tv` (scoop: `scoop install television`).
- `zellij` for the `zellij-sessions` channel.

## Setup

```powershell
setup_television        # copy channels to ~\.config\television\cable
setup_television -DryRun
```

- The profile sets `TELEVISION_CONFIG` to `~\.config\television`.
- An existing `cable` directory is copied to `cable.bak-<timestamp>` first.
- Check: `tv list-channels` shows `zellij-sessions`.

## Configured features

- Channel `zellij-sessions` (`cable\zellij-sessions.toml`): lists live zellij sessions (`zellij list-sessions --short --no-formatting`).
  - Enter: attach. Action `kill`: kill the selected session.
- Profile function `za` runs `tv zellij-sessions`.

## Defaults changed

- Only the channel is installed. There is no `config.toml` yet, so tv defaults apply (keybinds, UI, shell integration).

## To do

- `config.toml` with `ctrl-n/j` and `ctrl-p/k` navigation (as in `common/television/default.nix`) and shell integration for pwsh (files, history, clipboard history channel).

## Manual tests

- `tv list-channels` shows `zellij-sessions`. If it does not, check where tv reads its config on Windows (`tv --help`, `$env:TELEVISION_CONFIG`).
- `za` shows live sessions only. Enter attaches.
