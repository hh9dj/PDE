# Hunk

Terminal diff viewer for agent-authored changes. Config: `common/hunk/config.toml` (shared with NixOS).

## Dependencies

- `hunk` (mise, npm backend: `npm:hunkdiff`, installed by `setup_mise` and `mise install`).
- `gemini` for the skill.

## Setup

`setup_hunk`:
- copies `config.toml` to `~\.config\hunk` (hunk reads `$XDG_CONFIG_HOME\hunk`).
- copies the bundled `hunk-review` skill (path from `hunk skill path hunk-review`) to `~\.gemini\skills\hunk-review`. Run it again after a hunk upgrade.

Not installed: hunk extensions (`hunk-backup`) and the `hunk-extensions` skill.

## Configured features

- Theme `catppuccin-latte`, git, auto layout, line numbers, wrapped lines, agent notes, no untracked files.
- Keys: `(` / `)` previous / next file, `h`/`l` scroll code, `alt+l` line numbers.
- Gemini can drive a running hunk session with the `hunk-review` skill (`hunk session ...`). Start hunk yourself first.
