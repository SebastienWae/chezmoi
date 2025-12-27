return {
  {
    -- https://nvim-mini.org/mini.nvim/readmes/mini-splitjoin.html
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.splitjoin").setup(opts)
    end,
  },
}
