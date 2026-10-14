local catppuccin = require("catppuccin")
catppuccin.setup({ transparent_background = false })
catppuccin.load("latte")

vim.api.nvim_set_hl(0, "CursorLine", { bg = "#cddbf0" })
vim.api.nvim_set_hl(0, "Folded", { fg = "#57606a", bg = "#aec2e7" })
