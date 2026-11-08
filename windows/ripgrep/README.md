# ripgrep

Fast recursive text search.

## Dependencies

- `rg` (scoop: `scoop install ripgrep`).

## Setup

```powershell
setup_ripgrep           # copy config to ~\.config\ripgrep\config
setup_ripgrep -DryRun
```

- The profile sets `RIPGREP_CONFIG_PATH` to that file. An existing file is copied to `config.bak-<timestamp>` first.

## Configured features

- Config: `--smart-case`, `--hidden`, `--glob=!.git/`.
- Profile functions (the old `grep` and `rgrep` spec):
  - `grep`: `rg --color=auto`. It uses ripgrep flags, not GNU grep flags.
  - `rgrep`: `rg --no-ignore --hidden`. It searches all files below the current directory, also hidden and ignored ones.

## Defaults changed

- Hidden files are searched by default. `.gitignore` is still respected (use `rgrep` to ignore it).

## Manual tests

- `grep TODO` in a repo lists matches with colors. `rgrep TODO` also searches ignored files such as `node_modules`.
- `"abc" | grep b` works on piped text.

## Role in the stack

- Primary text search tool.
- Respects `.gitignore` by default.

## Installation

Preferred:

```powershell
scoop install ripgrep
```

## Alternatives

### Select-String

- Native PowerShell text search.
- Slower on large trees.

### findstr

- Native Windows text search.
- Limited regular expression support.

## Documentation

https://github.com/BurntSushi/ripgrep
