# mise

Multi-language runtime manager. Manages Python, Node.js, Go, Rust, and other tools from one configuration.

## Dependencies

- `mise` (scoop: `scoop install mise`). `mise` 2026.7.4 or newer is not needed: no `[dotfiles]` feature is used.
- `node` in the global mise config (or on PATH) for the npm tools.

## Setup

```powershell
setup_mise -DryRun
setup_mise              # copy pde.toml to ~\.config\mise\conf.d\pde.toml
mise install            # needs the company npm registry (npm config is not changed)
```

- `conf.d\pde.toml` is read together with your own `~\.config\mise\config.toml`, which stays untouched.

## Configured features

- `pde.toml` installs `lazysql` (GitHub release, command `lazysql`) and the neovim language servers and formatters (npm backend): bash-language-server, pyright, typescript, vtsls, vue language server, vscode-langservers-extracted, yaml-language-server, biome, prettierd. See `nvim/README.md`.

## Defaults changed

- None in your global config. No `node`, `python` or `zig` entry is added: keep them in your own file.

## Manual tests

- `mise ls` lists the tools after `mise install`. `lazysql --version` works. If the GitHub download is blocked, run `scoop search lazysql` or download the release by hand. `bash-language-server --version` works.

## Role in the stack

- Preferred runtime manager for backend development.
- Replaces separate version managers when one tool is enough.
- Reads project versions from `mise.toml` or `.tool-versions`.

## Installation

Preferred (Scoop):

```powershell
scoop install mise
```

Alternative (winget):

```powershell
winget install jdx.mise
```

Alternative (PowerShell script):

```powershell
irm https://mise.run/powershell | iex
```

Alternative (manual):

1. Download `mise-v<version>-windows-x64.zip` and `SHASUMS256.txt` from GitHub Releases.
2. Verify the SHA256 hash with `Get-FileHash`.
3. Extract the `mise\bin` folder.
4. Add it to PATH. Keep `mise.exe` and `mise-shim.exe` together.

## Configuration

Activate it in the PowerShell profile:

```powershell
mise activate pwsh | Out-String | Invoke-Expression
```

Example project `mise.toml`:

```toml
[tools]
node = "lts"
python = "3.12"
```

Install the declared tools:

```powershell
mise install
```

## Maintenance

```powershell
mise upgrade
mise self-update
```

`mise upgrade` updates installed tools. `mise self-update` updates mise itself when it was not installed by a package manager.

## Alternatives

### uv (Python only)

- Fast Python package and environment manager.
- Use it when mise is unavailable.

### fnm (Node.js only)

- Fast Node.js version manager.
- Use it when mise is unavailable.

### rustup, Go, and JDK distributions

- Native toolchains for their own runtimes.
- Use them when a project requires the official toolchain.

## Documentation

- https://mise.jdx.dev/installing-mise.html#windows-scoop
- https://github.com/jdx/mise
