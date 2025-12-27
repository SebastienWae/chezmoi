return {
  {
    -- https://nvim-mini.org/mini.nvim/doc/mini-files.html
    "echasnovski/mini.files",
    cmd = { "MiniFiles", },
    keys = {
      {
        "<leader>fE",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Files: explorer (mini.files)",
      },
    },
    opts = {
      windows = {
        preview = true,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)
    end,
  },
}
