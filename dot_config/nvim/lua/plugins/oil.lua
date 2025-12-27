return {
  {
    "benomahony/oil-git.nvim",
    ft = { "oil", },
    dependencies = { "stevearc/oil.nvim", },
    opts = {},
    config = function(_, opts)
      require("oil-git").setup(opts)
    end,
  },
  {
    "stevearc/oil.nvim",
    cmd = { "Oil", },
    lazy = false,
    dependencies = { "folke/snacks.nvim", },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>",         desc = "Oil: open file explorer", },
      { "<leader>E", "<cmd>Oil --float<cr>", desc = "Oil: open floating", },
    },
    init = function()
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
    config = function(_, opts)
      require("oil").setup(opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilActionsPost",
        callback = function(event)
          if event.data.actions[1].type == "move" then
            Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
          end
        end,
      })
    end,
  },
}
