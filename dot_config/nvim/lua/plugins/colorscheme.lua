return {
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("modus_vivendi")
    end,
  },
}
