local flash = require("flash")
flash.setup({})

local map = vim.keymap.set

map({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash" })

map({ "o", "x" }, "r", function()
  flash.treesitter_search()
end, { desc = "Treesitter Search" })

map({ "n", "o", "x" }, "<c-space>", function()
  flash.treesitter({ actions = { ["<c-space>"] = "next", ["<BS>"] = "prev" } })
end, { desc = "Treesitter Incremental Selection" })
