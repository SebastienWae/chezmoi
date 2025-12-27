return {
  {
    -- https://nvim-mini.org/mini.nvim/readmes/mini-surround.html
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
}
