local vue_server = vim.fn.exepath("vue-language-server")
local vue_plugin_path = vue_server:gsub(
  "/bin/vue%-language%-server$",
  "/lib/language-tools/packages/language-server"
)

---@type vim.lsp.Config
return {
  filetypes = { "vue" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_plugin_path,
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
  },
}
