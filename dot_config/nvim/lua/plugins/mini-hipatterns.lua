return {
  {
    "echasnovski/mini.hipatterns",
    event = { "BufReadPost", "BufNewFile", },
    opts = {},
    config = function(_, opts)
      require("mini.hipatterns").setup(opts)
    end,
  },
}
