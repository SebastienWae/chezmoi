return {
  {
    -- https://nvim-mini.org/mini.nvim/readmes/mini-hipatterns.html
    "echasnovski/mini.hipatterns",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    config = function(_, opts)
      require("mini.hipatterns").setup(opts)
    end,
  },
}
