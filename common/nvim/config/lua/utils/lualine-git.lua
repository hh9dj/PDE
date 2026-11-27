local M = {}

local staged_by_buf = {}
local hooked_gitsigns = false

local function is_fully_staged(bufnr, bcache)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
    return false
  end
  if not bcache or (bcache.git_obj and bcache.git_obj:from_tree()) then
    return false
  end
  local hunks = bcache.hunks
  local hunks_staged = bcache.hunks_staged
  return hunks ~= nil and #hunks == 0 and hunks_staged ~= nil and #hunks_staged > 0
end

function M.diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

function M.staged_indicator()
  local bufnr = vim.api.nvim_get_current_buf()
  if not staged_by_buf[bufnr] or vim.bo[bufnr].modified then
    return ""
  end
  return "[+]"
end

function M.staged_color()
  return {
    fg = require("lualine.utils.utils").extract_color_from_hllist(
      "fg",
      { "LuaLineDiffAdd", "GitSignsAdd", "DiffAdd" },
      "#90ee90"
    ),
  }
end

function M.setup(lualine)
  local group = vim.api.nvim_create_augroup("lualine-git-status", { clear = true })

  local function refresh_statusline()
    vim.schedule(function()
      lualine.refresh({ place = { "statusline" } })
    end)
  end

  local function sync_staged(bufnr, bcache)
    local staged = is_fully_staged(bufnr, bcache)
    if staged_by_buf[bufnr] ~= staged then
      staged_by_buf[bufnr] = staged
      refresh_statusline()
    end
  end

  local function hook_gitsigns()
    if hooked_gitsigns then
      return
    end
    hooked_gitsigns = true

    local manager = require("gitsigns.manager")
    local cache = require("gitsigns.cache").cache

    for bufnr, bcache in pairs(cache) do
      staged_by_buf[bufnr] = is_fully_staged(bufnr, bcache)
    end

    manager.on_update(function(ctx)
      sync_staged(ctx.bufnr, ctx.bcache)
    end)

    manager.on_detach(function(bufnr)
      if staged_by_buf[bufnr] ~= nil then
        staged_by_buf[bufnr] = nil
        refresh_statusline()
      end
    end)
  end

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "GitSignsUpdate",
    callback = function()
      hook_gitsigns()
      refresh_statusline()
    end,
  })

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(ev)
      staged_by_buf[ev.buf] = nil
    end,
  })
end

return M
