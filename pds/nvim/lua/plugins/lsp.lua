for _, server in ipairs({
  "gopls",
  "pyright",
  "ruff",
  "lua_ls",
  "nixd",
  "bashls",
}) do
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
  end,
})

vim.keymap.set("n", "<leader>rl", function()
  vim.cmd("lsp restart")
end, { desc = "[R]estart [L]SP" })
