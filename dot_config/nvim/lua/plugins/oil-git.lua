return {
  {
    "benomahony/oil-git.nvim",
    ft = { "oil" },
    dependencies = { "stevearc/oil.nvim" },
    opts = {},
    config = function(_, opts)
      require("oil-git").setup(opts)
    end,
  },
}
