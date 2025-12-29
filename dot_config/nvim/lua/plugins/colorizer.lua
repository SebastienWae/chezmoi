return {
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile", },
    opts = {
      filetypes = { "*", },
      user_default_options = {
        css = true,
        css_fn = true,
        mode = "background",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },
}
