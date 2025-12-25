require("blink.cmp").setup({
  completion = {
    menu = {
      draw = {
        treesitter = { "lsp", },
      },
    },
    ghost_text = {
      enabled = true,
    },
  },
  signature = {
    enabled = true,
  },
  cmdline = {
    completion = {
      menu = { auto_show = true, },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
    },
  },
})
