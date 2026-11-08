# ripgrep

## Dependencies

- `rg` (scoop: `ripgrep`).

## Setup

`setup_ripgrep`: copies `config` to `~\.config\ripgrep\config` (the profile sets `RIPGREP_CONFIG_PATH`).

## Configured features

- `--smart-case`, `--hidden`, `--glob=!.git/`.
- `grep` = `rg --color=auto` (ripgrep flags, not GNU grep).
- `rgrep` = `rg --no-ignore --hidden` (also ignored files).
