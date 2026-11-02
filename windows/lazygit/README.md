# Lazygit

Terminal UI for Git.

## Role in the stack

- Primary Git interface.
- Runs inside WezTerm.
- Provides staging, committing, branching, and diff review.

## Installation

Preferred:

```powershell
scoop install lazygit
```

## Configuration

Define a shell alias in the PowerShell profile:

```powershell
Set-Alias lg lazygit
```

## Alternatives

### Git CLI (fallback)

- Native Git commands.
- No TUI and no visual staging.
- Use it when Lazygit is unavailable or forbidden.

### GitHub Desktop (fallback)

- Graphical Git client.
- Requires a graphical workflow.

## Documentation

https://github.com/jesseduffield/lazygit
