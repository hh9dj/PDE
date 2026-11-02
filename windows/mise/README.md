# mise

Multi-language runtime manager. Manages Python, Node.js, Go, Rust, and other tools from one configuration.

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
