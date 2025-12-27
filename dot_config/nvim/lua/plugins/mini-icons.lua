return {
  {
    -- https://nvim-mini.org/mini.nvim/readmes/mini-icons.html
    "echasnovski/mini.icons",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("mini.icons").setup(opts)
    end,
  },
}
