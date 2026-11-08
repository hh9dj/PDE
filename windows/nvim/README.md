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
- PowerShell Editor Services (optional, see below).
- Treesitter parsers: off by default (see below).

## Setup

```powershell
setup_nvim -DryRun
setup_nvim              # install the config to %LOCALAPPDATA%\nvim
setup_mise              # copy mise\pde.toml to ~\.config\mise\conf.d\pde.toml
mise install            # language servers (npm backend)
nvim                    # first start: lazy.nvim installs the plugins
```

- The old `%LOCALAPPDATA%\nvim` is moved to `nvim.bak-<timestamp>`. Old and new files never mix. To get an old setting back, read the backup.
- Plugin data stays in `%LOCALAPPDATA%\nvim-data` and is not touched.
- If you run `:Lazy sync`, `lazy-lock.json` changes. The next `setup_nvim` sees a difference and makes a new backup.
- `setup_mise` writes a new file in `conf.d`. Your `~\.config\mise\config.toml` is not changed.

## Configured features

- Same plugins, keybinds and theme as on NixOS (catppuccin latte, lazy.nvim, snacks, blink.cmp, conform, nvim-lint).
- Language support:
  - PowerShell: `powershell_es` (optional install).
  - bash: `bashls`. Python: `pyright`, `ruff`. TypeScript and JavaScript: `vtsls`, `biome`.
  - Vue and Pinia: `vue_ls` with `vtsls` (the Vue TypeScript plugin). Pinia needs no extra server.
  - HTML, CSS, JSON: `vscode-langservers-extracted` (`biome` formats them). Also yaml, toml, markdown, lua.
- Windows guards in the shared config:
  - The shell of nvim is `pwsh`.
  - Only installed language servers are enabled (no error for a missing one). `:checkhealth vim.lsp` shows the active ones.
  - Treesitter plugin off (no C compiler).
  - `blink.cmp` uses its Lua matcher (no download of a prebuilt binary).
  - The `make` and `deno` build steps of LuaSnip and peek.nvim run only when `make` or `deno` exists.
  - The `chmod +x` keybind (`<leader>fx`) is not defined.
  - nvim-lint ignores a missing linter.

## Defaults changed

- `shell` is `pwsh` with the flags from `:h shell-powershell`.
- No treesitter parsers beyond the ones bundled with nvim (c, lua, vim, vimdoc, markdown, query). Other languages have no treesitter highlighting.

## PowerShell Editor Services (optional)

1. Download `PowerShellEditorServices.zip` from https://github.com/PowerShell/PowerShellEditorServices/releases (a browser download is enough).
2. Extract it to `$env:LOCALAPPDATA\nvim-data\powershell_es` so that `PowerShellEditorServices\Start-EditorServices.ps1` exists there. Or set `$env:POWERSHELL_ES_PATH` to another folder.
3. Open a `.ps1` file. `:checkhealth vim.lsp` shows `powershell_es`.

Without the bundle the server stays off.

## Treesitter (off, test with zig)

Treesitter needs a C compiler to build parsers. The laptop has none. `zig` (scoop) can act as one. This is not proven yet, so it is opt-in:

```powershell
$env:NVIM_TREESITTER = "1"
$env:CC = "zig cc"
nvim
# inside nvim:
# :Lazy sync
# :TSInstall python
# :checkhealth nvim-treesitter
```

- It needs `tree-sitter` (the CLI, in `setup_tools`) and `zig`.
- If `:TSInstall` works, tell me. Then the variables become permanent in the profile and treesitter is on by default.
- If it fails, send the error text. The fallback is parser DLLs compiled on NixOS for Windows.

## Manual tests

- `nvim` starts without errors. After the first start, `:Lazy` shows the plugins as installed.
- Open `a.ps1`, `a.sh`, `a.py`, `a.ts`, `a.vue`, `a.html`, `a.css`. In each, `:checkhealth vim.lsp` lists the right server (after `mise install`).
- `K` shows hover docs. `<space>ca` shows code actions. `<leader>gg` formats (a formatter must exist).
- `:!echo hi` and `:terminal` run in `pwsh`.
- If a Vue file shows no TypeScript info, `:lua print(vim.lsp.config.vtsls.settings.vtsls.tsserver.globalPlugins[1].location)` must print a folder that exists. If not, set `$env:VUE_LS_PATH` to the folder of `@vue/language-server` (`mise where npm:@vue/language-server`, then `node_modules\@vue\language-server`).

## Test on Linux

`PDE_FAKE_WIN=1 nvim` turns on the Windows guards on NixOS. Use it only for tests.

## Alternatives

- VS Code with VSCodeVim, if approved.
- Notepad++ for quick edits.

## Documentation

https://neovim.io/
