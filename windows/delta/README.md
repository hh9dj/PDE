# delta

Syntax-highlighting pager for Git diffs.

## Role in the stack

- Primary Git diff renderer.
- Improves readability of diffs in the terminal.

## Installation

Preferred:

```powershell
scoop install delta
```

## Configuration

Connect it to Git:

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
