return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  -- change base revision for diff picker

  opts = {
    -- TODO: fix on_attach leak
    on_attach = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitsigns-blame",
        callback = function(event)
          local buf = event.buf
          vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
          vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, silent = true })
        end,
      })
    end,
  },
  keys = {
    {
      "<leader>gab",
      function()
        require("gitsigns").stage_buffer()
      end,
      desc = "[G]it [F]ile [S]tage",
    },
    {
      "<leader>gah",
      function()
        require("gitsigns").stage_hunk()
      end,
      desc = "[G]it [H]unk [S]tage",
    },
    {
      "<leader>gbl",
      function()
        require("gitsigns").blame_line()
      end,
      desc = "[G]it [B]lame [L]ine",
    },
    {
      "<leader>gbb",
      function()
        require("gitsigns").blame()
      end,
      desc = "[G]it [B]lame [B]uffer",
    },
    {
      "<leader>gpD",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "[G]it [P]review [D]iff",
    },
    {
      "<leader>gpd",
      function()
        require("gitsigns").preview_hunk_inline()
      end,
      desc = "[G]it [P]review [D]iff Inline",
    },
    {
      "<leader>nh",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      desc = "[N]ext git [H]unk",
    },
    {
      "<leader>ph",
      function()
        require("gitsigns").nav_hunk("prev")
      end,
      desc = "[P]revious git [H]unk",
    },
  },
}
