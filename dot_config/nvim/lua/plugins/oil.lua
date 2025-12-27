return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil", },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>",         desc = "Oil: open file explorer", },
      { "<leader>E", "<cmd>Oil --float<cr>", desc = "Oil: open floating", },
    },
    init = function()
      -- Recommended by oil.nvim to avoid netrw conflicts.
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      float = {
        border = "single",
        win_options = {
          statusline = " ",
          winhighlight = "StatusLine:NormalFloat,StatusLineNC:NormalFloat",
        },
        get_win_title = function(winid)
          local bufnr = vim.api.nvim_win_get_buf(winid)
          local ok, oil = pcall(require, "oil")
          if not ok then
            return "Oil"
          end

          return oil.get_current_dir(bufnr) or "Oil"
        end,
      },
      preview_win = {
        win_options = {
          statusline = " ",
        },
      },
      confirmation = {
        border = "single",
      },
    },
  },
}
