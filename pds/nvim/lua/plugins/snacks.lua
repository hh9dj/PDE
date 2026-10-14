require("snacks").setup({
  explorer = { enabled = true },
  indent = { enabled = true, only_scope = false, only_current = true },
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
          ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
        },
      },
    },
  },
  scroll = {
    enabled = true,
    animate = { duration = { step = 10, total = 200 }, easing = "linear" },
    animate_repeat = { delay = 100, duration = { step = 5, total = 20 }, easing = "linear" },
  },
})

local map = vim.keymap.set

map("n", "<leader><space>", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })

map("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "File [E]xplorer" })

map("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Grep" })

map("n", "<leader>sh", function()
  Snacks.picker.help()
end, { desc = "Help Pages" })

map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find Files" })

map("n", "<leader>fh", function()
  Snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find Hidden files" })

map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Buffers" })

map("n", "<leader>fr", function()
  Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Find Recent" })

map("n", "gd", function()
  Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })

map("n", "gD", function()
  Snacks.picker.lsp_declarations()
end, { desc = "Goto Declaration" })

map("n", "gr", function()
  Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })

map("n", "gi", function()
  Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })

map("n", "cft", function()
  Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })

map("n", "<leader>ss", function()
  Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })

map("n", "<leader>sD", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })

map("n", "<leader>sd", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })

map("n", "<leader>bdd", function()
  Snacks.bufdelete()
end, { desc = "Delete current Buffer" })
