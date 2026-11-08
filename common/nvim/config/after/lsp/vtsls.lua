-- Folder of @vue/language-server, needed by the vtsls Vue plugin.
-- Nix: <prefix>/bin/vue-language-server -> <prefix>/lib/language-tools/packages/language-server.
-- Windows (mise or npm): <install dir>/node_modules/@vue/language-server. Override with $VUE_LS_PATH.
local function vue_plugin_path()
  if vim.env.VUE_LS_PATH then
    return vim.env.VUE_LS_PATH
  end
  local vue_server = vim.fn.exepath("vue-language-server")
  local nix = (vue_server:gsub("/bin/vue%-language%-server$", "/lib/language-tools/packages/language-server"))
  if not vim.g.is_win or vim.uv.fs_stat(nix) then
    return nix
  end
  -- mise npm backend: .../installs/npm-vue-language-server/<version>/node_modules/@vue/language-server
  local bin = vim.fn.fnamemodify(vue_server, ":h")
  for _, path in ipairs({ bin .. "/node_modules/@vue/language-server", bin .. "/../node_modules/@vue/language-server" }) do
    if vim.uv.fs_stat(path) then
      return path
    end
  end
  -- mise npm backend: shims do not hold the package, ask mise where it is installed
  if vim.fn.executable("mise") == 1 then
    local where = vim.fn.system({ "mise", "where", "npm:@vue/language-server" }):gsub("%s+$", "")
    for _, path in ipairs({ where .. "/node_modules/@vue/language-server", where .. "/lib/node_modules/@vue/language-server" }) do
      if vim.uv.fs_stat(path) then
        return path
      end
    end
  end
  -- global npm install (slow call, last resort)
  local root = vim.fn.system({ "npm", "root", "-g" }):gsub("%s+$", "")
  return root .. "/@vue/language-server"
end

---@type vim.lsp.Config
return {
  filetypes = { "vue" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_plugin_path(),
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
  },
}
