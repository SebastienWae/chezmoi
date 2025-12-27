return {
  {
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.splitjoin").setup(opts)
    end,
  },
}
