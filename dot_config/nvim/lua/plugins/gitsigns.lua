return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile", },
    dependencies = { "nvim-lua/plenary.nvim", },
    opts = {},
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
}
