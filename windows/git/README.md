# Git

Extra global Git config. It adds delta and diff settings and does not touch company settings.

## Dependencies

- `git`.
- `delta` (scoop: `scoop install delta`). The pager is already `delta` in `~/.gitconfig`.

`setup_tools` installs delta with scoop.

## Setup

```powershell
setup_git               # copy windows\git\config to ~\.config\git\config
setup_git -DryRun
```

- Git reads `~/.config/git/config` before `~/.gitconfig`. The company file `~/.gitconfig` wins on conflicts.
- An existing target is copied to `config.bak-<timestamp>` first.
- Check: `git config --global --list --show-origin`.

## Configured features

- delta: `navigate = true` (jump between diff sections with `n` and `N`), `side-by-side = true`.
- `merge.conflictstyle = diff3`.
- `diff.colorMoved = default`.

## Not set on purpose

- No user name or email, credential helper, proxy, `url.*.insteadOf` or `core.sshCommand`. These belong to the company config.

## Manual tests

- `git diff` in a repo with changes shows delta with side-by-side columns.
- `git config --show-origin delta.navigate` shows `~/.config/git/config`.
