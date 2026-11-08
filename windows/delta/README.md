# delta

Syntax-highlighting pager for Git diffs.

## Dependencies

- `delta` 0.20 or newer (scoop: `scoop install delta`).

## Setup

Config lives in `windows/git/config`. Run `setup_git`. See `git/README.md`.

## Configured features

- `syntax-theme = Catppuccin Latte` and `light = true`, `navigate = true`, `side-by-side = true`.
- The pager itself (`core.pager = delta`) is set by the company `~/.gitconfig`. It is not set here.

## Manual tests

- `git diff` shows side-by-side columns with light colors.

## Role in the stack

- Primary Git diff renderer.
- Improves readability of diffs in the terminal.

## Installation

Preferred:

```powershell
scoop install delta
```

## Configuration (alternative)

Connect it to Git by hand:

```powershell
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
```

## Alternatives

### git diff

- Native Git diff output.
- No syntax highlighting.

### Neovim diff

- Review changes inside the editor.
- No separate pager.

## Documentation

https://github.com/dandavison/delta
