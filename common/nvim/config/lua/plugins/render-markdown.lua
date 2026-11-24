return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    enabled = false,
    completions = { lsp = { enabled = true } },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle({
          name = "Render Markdown",
          get = function()
            if not package.loaded["render-markdown"] then
              return false
            end
            return require("render-markdown").get()
          end,
          set = function(state)
            require("render-markdown").set(state)
          end,
        }):map("<leader>um")
      end,
    })
  end,
}
