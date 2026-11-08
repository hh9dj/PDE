# Starship

Prompt. Mirrors `common/starship/default.nix`.

## Dependencies

- `starship` (scoop: `scoop install starship`).
- A Nerd Font in the terminal: `JetBrainsMono-NF` (scoop bucket `nerd-fonts`). Install at user level if policy allows.
- `git` for the git segments.

`setup_tools` installs these with scoop.

## Setup

```powershell
setup_starship          # copy starship.toml to ~\.config\starship.toml
setup_starship -DryRun
```

- An existing file is copied to `starship.toml.bak-<timestamp>` first.
- The profile starts starship (`starship init powershell`) when the command exists. Open a new terminal.
- Check: `starship config` and `starship explain`.

## Configured features

- Palette `catppuccin_latte`.
- Left prompt: directory (5 levels, `…/` when truncated, not cut at the repo root), git branch and status, a fill line.
- Right part of the first line: language segments (python, lua, nodejs, golang, rust), package, docker context, jobs, command duration.
- Second line: the prompt character.
- `right_format = "$all"`: other modules go to the right side.

## Defaults changed

- `command_timeout = 1000`.
- `format` and `right_format` are replaced (the default one-line layout is gone).
- gcloud module is disabled in the long form.
- Directory substitutions use icons (Documents, Downloads, Music, Pictures).
- Git status symbols are emoji.

## Manual tests

- Open a new terminal in a git repo. The branch and status show.
- Colors are readable on the light background.
