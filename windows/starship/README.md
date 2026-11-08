# Starship

Prompt. Mirrors `common/starship/default.nix`.

## Dependencies

- `starship`, font `JetBrainsMono-NF` (scoop).

## Setup

`setup_starship`: copies `starship.toml` to `~\.config\starship.toml`.

## Configured features

- Palette `catppuccin_latte`. Two lines: directory, git, fill, languages and duration on the right, prompt character below.
- `command_timeout = 1000`. gcloud module off. Emoji git status symbols.
