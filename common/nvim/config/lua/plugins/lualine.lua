local git = require("utils.lualine-git")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = { theme = "auto", disabled_filetypes = { statusline = { "snacks_dashboard", "snacks_picker_preview" } } },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        "branch",
        { "diff", source = git.diff_source },
        { git.staged_indicator, color = git.staged_color },
        "diagnostics",
      },
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "lsp_status" },
      lualine_y = { "progress", { "searchcount", maxcount = 9999, timeout = 500 } },
      lualine_z = { "location" },
    },
  },
  config = function(_, opts)
    local lualine = require("lualine")
    lualine.setup(opts)
    git.setup(lualine)
  end,
}
