# Television (tv)

## Dependencies

- `tv` (scoop: `television`), `fd`, `bat`, `eza`, `zellij`.

## Setup

`setup_television`: copies `config.toml` and `cable\` to `~\.config\television` (the profile sets `TELEVISION_CONFIG`). Check: `tv list-channels`.

## Configured features

- `config.toml` (from `common/television/default.nix`): `ctrl-n`/`ctrl-j` next, `ctrl-p`/`ctrl-k` previous, `esc` quits, default channel `files`.
- Channels: `files` (fd + bat), `dirs` (fd + eza), `zellij-sessions` (live sessions, `ctrl-x` then `kill`).
- Profile: `Ctrl+f` smart autocomplete (`tv init power-shell`, channel from the command: `cd` gives dirs, `nvim` gives files). `za` = session picker. `Ctrl+r` stays on fzf.
