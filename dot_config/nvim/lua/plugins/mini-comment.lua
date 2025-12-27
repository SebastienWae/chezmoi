return {
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
}
