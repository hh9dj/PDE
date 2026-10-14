local function drop_user_dirs(paths)
  local home = vim.env.HOME or ""
  local out = {}
  for _, p in ipairs(paths) do
    local is_user_config = vim.startswith(p, home .. "/.config/nvim")
    local is_user_data = vim.startswith(p, home .. "/.local/share/nvim")
    if not (is_user_config or is_user_data) then
      table.insert(out, p)
    end
  end
  return out
end

vim.opt.runtimepath = drop_user_dirs(vim.opt.runtimepath:get())
vim.opt.packpath = drop_user_dirs(vim.opt.packpath:get())
vim.opt.runtimepath:prepend(vim.env.PDS_CONFIG)
vim.opt.packpath:prepend(vim.env.PDS_PLUGINS)

vim.cmd("packloadall")

require("options")
require("keybinds")
require("plugins.catppuccin")
require("plugins.treesitter")
require("plugins.flash")
require("plugins.lualine")
require("plugins.blink")
require("plugins.snacks")
require("plugins.lsp")
