return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall", },
    event = { "BufReadPost", "BufNewFile", },
    opts = {
      ensure_installed = "all",
      auto_install = true,
      highlight = { enable = true, },
      indent = { enable = true, },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile", },
    dependencies = { "nvim-treesitter/nvim-treesitter", },
    opts = {},
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
  },
}
