# Git

Extra global config. The company `~/.gitconfig` is not touched and wins on conflicts.

## Dependencies

- `git`, `delta` (scoop). The pager (`core.pager = delta`) comes from the company config.

## Setup

`setup_git`: copies `config` to `~\.config\git\config`. Check: `git config --global --list --show-origin`.

## Configured features

- delta: `navigate`, `side-by-side`, `light`, `syntax-theme = Catppuccin Latte`.
- `merge.conflictstyle = diff3`, `diff.colorMoved = default`.
- Not set on purpose: identity, credentials, proxy, `url.*.insteadOf`, `core.sshCommand`.
