return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cmd = { "ConformInfo", },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback", })
        end,
        mode = { "n", "v", },
        desc = "Format Buffer",
      },
    },
    opts = {
      formatters_by_ft = {},
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
}
