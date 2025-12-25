local map = vim.keymap.set

local conform = require("conform")
conform.setup({
  formatters_by_ft = {
    markdown = { "markdownlint-cli2", },
    javascript = { "biome", "biome-organize-imports", },
    typescript = { "biome", "biome-organize-imports", },
    javascriptreact = { "biome", "biome-organize-imports", },
    typescriptreact = { "biome", "biome-organize-imports", },
    json = { "biome", },
    html = { "biome", },
    css = { "biome", },
    graphql = { "biome", },
  },
  formatters = {
    ["markdownlint-cli2"] = {
      condition = function(_, ctx)
        local diag = vim.tbl_filter(function(d)
          return d.source == "markdownlint"
        end, vim.diagnostic.get(ctx.buf))
        return #diag > 0
      end,
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
})

map({ "n", "v", }, "<leader>cf", function()
  conform.format({ async = true, lsp_fallback = true, })
end)
