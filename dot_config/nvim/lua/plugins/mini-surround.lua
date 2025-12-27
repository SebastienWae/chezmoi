return {
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
}
