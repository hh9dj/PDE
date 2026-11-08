-- PowerShell Editor Services. No Mason: unzip PowerShellEditorServices.zip from
-- https://github.com/PowerShell/PowerShellEditorServices/releases into the bundle dir
-- (default: <nvim data>/powershell_es, or $POWERSHELL_ES_PATH).
local bundle = vim.env.POWERSHELL_ES_PATH or (vim.fn.stdpath("data") .. "/powershell_es")
local start = bundle .. "/PowerShellEditorServices/Start-EditorServices.ps1"
local state = vim.fn.stdpath("cache")
local script = ("& '%s' -BundledModulesPath '%s' -LogPath '%s/pses.log' -SessionDetailsPath '%s/pses.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Warning"):format(
  start,
  bundle,
  state,
  state
)

---@type vim.lsp.Config
return {
  -- cmd[1] is pwsh, so the "installed" check above is also true when the bundle is missing.
  cmd = vim.uv.fs_stat(start) and { "pwsh", "-NoLogo", "-NoProfile", "-Command", script } or { "pses-not-installed" },
  filetypes = { "ps1", "psm1", "psd1" },
  root_markers = { ".git", "PSScriptAnalyzerSettings.psd1" },
  settings = { powershell = { codeFormatting = { preset = "OTBS" } } },
}
