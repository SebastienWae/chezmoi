return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {
      n_lines = 500,
    },
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
}
