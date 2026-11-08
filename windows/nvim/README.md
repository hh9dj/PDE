# Neovim

Primary editor. The config is shared with NixOS: the source is `common/nvim/config`. It has guards for Windows (`vim.g.is_win`), so one config serves both systems.

## Dependencies

- `nvim` 0.12 or newer (scoop: `scoop install neovim`). Checked with 0.12.6.
- `git` (lazy.nvim clones the plugins at the first start, through the proxy).
- `pwsh` 7 (used as the shell of nvim).
- `rg` and `fd` (snacks, todo-comments, venv-selector). Both are in `setup_tools`.
- Language servers and formatters. Two sources, both through the company channels:
  - scoop (`setup_tools`): `lua-language-server`, `marksman`, `stylua`, `shfmt`, `taplo`, `ruff`.
  - mise, npm backend (`setup_mise`, then `mise install`): `bash-language-server`, `pyright`, `typescript`, `@vtsls/language-server`, `@vue/language-server`, `vscode-langservers-extracted` (html, css, json), `yaml-language-server`, `@biomejs/biome`, `@fsouza/prettierd`. `node` must be available in mise or on PATH.
- `make` (scoop, in `setup_tools`): LuaSnip builds `jsregexp` with it (uses the `CC` wrapper from the profile).
- `deno` (scoop, in `setup_tools`): builds the markdown preview plugin (peek.nvim).
- Treesitter parsers: built with `zig` and `tree-sitter` (both in `setup_tools`). The profile sets `CC` (see below).

## Setup

```powershell
setup_nvim -DryRun
setup_nvim              # install the config to ~\.config\nvim and set XDG_CONFIG_HOME
setup_mise              # copy mise\pde.toml to ~\.config\mise\conf.d\pde.toml
mise install            # language servers (npm backend)
nvim                    # first start: lazy.nvim installs the plugins
```

- nvim reads `$XDG_CONFIG_HOME\nvim`, so the config lives in `~\.config\nvim`. `setup_nvim` sets the user variable `XDG_CONFIG_HOME` to `~\.config` (a warning shows if it already has another value, and it is not changed). Open a new terminal after the first run.
- An existing `~\.config\nvim` is moved to `nvim.bak-<timestamp>`. Old and new files never mix. Only the 5 newest backups are kept.
- Your old config in `%LOCALAPPDATA%\nvim` is not touched. It is no longer read once `XDG_CONFIG_HOME` is set. Delete it when you do not need it.
- Side effect of `XDG_CONFIG_HOME`: every tool that follows XDG reads `~\.config` too (git, mise, gh and others). If a company tool keeps its config in `%APPDATA%` (for example `gh`), check it still finds its config. To undo: `[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $null, "User")`.
- Plugin data stays in `%LOCALAPPDATA%\nvim-data` (`XDG_DATA_HOME` is not set) and is not touched.
- If you run `:Lazy sync`, `lazy-lock.json` changes. The next `setup_nvim` sees a difference and makes a new backup.
- `setup_mise` writes a new file in `conf.d`. Your `~\.config\mise\config.toml` is not changed.

## Configured features

- Same plugins, keybinds and theme as on NixOS (catppuccin latte, lazy.nvim, snacks, blink.cmp, conform, nvim-lint).
- Language support:
  - PowerShell: no language server (`powershell_es` was removed, it was unstable). Highlighting comes from treesitter.
  - bash: `bashls`. Python: `pyright`, `ruff`. TypeScript and JavaScript: `vtsls`, `biome`.
  - Vue and Pinia: `vue_ls` with `vtsls` (the Vue TypeScript plugin). Pinia needs no extra server.
  - HTML, CSS, JSON: `vscode-langservers-extracted` (`biome` formats them). Also yaml, toml, markdown, lua.
- Windows guards in the shared config (`vim.g.is_win`, set in `lua/options.lua`):
  - The `chmod +x` keybind (`<leader>fx`) is not defined.
  - The Vue plugin path for `vtsls` is found from the mise or npm install (`$env:VUE_LS_PATH` overrides it).

## Defaults changed

- Nothing in the nvim config changes for treesitter. The compiler is set outside nvim: the profile sets `$env:CC` (see below).
- A language server that is not installed may show an error when you open its file type. Install it (`mise install`) or ignore it.

## Treesitter (parsers built with zig)

Treesitter builds its parsers with a C compiler. The laptop has none, so `zig` (scoop) is used as one. The nvim config has no special code for this. Only the compiler comes from the environment.

- A plain `$env:CC = "zig cc"` fails: `unable to parse target query x86_64-pc-windows-msvc: UnknownOperatingSystem`. The tree-sitter CLI passes an MSVC target that zig does not know.
- `setup_nvim` installs a wrapper, `~\.config\zig-cc\zig-cc.cmd` (source: `zig-cc.cmd` in this directory). It changes the target to `x86_64-windows-gnu`. Zig has its own C library for it, so no Visual Studio is needed.
- The profile sets `$env:CC` to the wrapper when the file exists. This applies to every program started from pwsh. If another build tool breaks because of it, run `Remove-Item Env:CC` in that terminal.

Steps (first time):

```powershell
setup_tools                      # zig and tree-sitter
setup_nvim                       # installs the wrapper
. $PROFILE                       # sets CC
& $env:CC --version              # prints the zig clang version
nvim
# inside nvim:
# :Lazy sync
# :TSInstall python
# :checkhealth nvim-treesitter
```

If a build fails, send the error text. The fallback is parser DLLs compiled on NixOS for Windows.

## Manual tests

- `nvim` starts without errors. After the first start, `:Lazy` shows the plugins as installed.
- Open `a.ps1`, `a.sh`, `a.py`, `a.ts`, `a.vue`, `a.html`, `a.css`. In each, `:checkhealth vim.lsp` lists the right server (after `mise install`).
- `K` shows hover docs. `<space>ca` shows code actions. `<leader>gg` formats (a formatter must exist).
- If a Vue file shows no TypeScript info, `:lua print(vim.lsp.config.vtsls.settings.vtsls.tsserver.globalPlugins[1].location)` must print a folder that exists. If not, set `$env:VUE_LS_PATH` to the folder of `@vue/language-server` (`mise where npm:@vue/language-server`, then `node_modules\@vue\language-server`).

## Test on Linux

`PDE_FAKE_WIN=1 nvim` turns on the Windows guards on NixOS. Use it only for tests.

## Alternatives

- VS Code with VSCodeVim, if approved.
- Notepad++ for quick edits.

## Documentation

https://neovim.io/
