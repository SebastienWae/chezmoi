return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
}
