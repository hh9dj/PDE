# fd

Fast alternative to `find`.

## Dependencies

- `fd` (scoop: `scoop install fd`).

## Setup

No config file and no setup command. fd has no environment variable for a config path. It uses the defaults (respects `.gitignore`, hides hidden files).

## Configured features

- tv channels `files` and `dirs` use `fd -t f` and `fd -t d` (hidden files with the second source, `ctrl-s`).

## Defaults changed

- None.

## Manual tests

- `fd -t f README` lists the README files below the current directory.

## Role in the stack

- Primary file search tool.
- Used for fast file discovery in the repository.

## Installation (alternative)

Preferred:

```powershell
scoop install fd
```

## Alternatives

### Everything

- Windows file indexing tool.
- Graphical search over the whole disk.

### Get-ChildItem

- Native PowerShell file listing.
- Slower on large trees.

## Documentation

https://github.com/sharkdp/fd
