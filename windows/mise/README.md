# mise

## Dependencies

- `mise` (scoop), `node` in your global mise config (for the npm tools).

## Setup

```powershell
setup_mise     # pde.toml to ~\.config\mise\conf.d\pde.toml, shims dir to the user PATH
mise install   # through the company npm registry
setup_mise     # again, to create the shims of the new tools
```

Your `~\.config\mise\config.toml` is not changed.

## Configured features

- `pde.toml`: `hunk` (`npm:hunkdiff`), `lazysql` (GitHub release) and the nvim language servers and formatters (npm backend).
- pwsh: `mise activate pwsh` in the profile.
- Other programs (GUI apps, `cmd.exe`, python subprocesses): the shims dir (`%LOCALAPPDATA%\mise\shims`) is first in the user PATH.
