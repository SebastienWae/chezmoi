return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cmd = { "ConformInfo", },
    opts = {
      formatters_by_ft = {},
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
}
