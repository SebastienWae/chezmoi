return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", },
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local servers = {
        ty = {},
        lua_ls = {},
        vtsls = {},
        biome = {},
        dockerls = {},
        docker_language_server = {},
        taplo = {},
        tailwindcss = {},
        bashls = {},
        ruff = {},
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true, },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "", },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
      }

      for name, opts in pairs(servers) do
        vim.lsp.config(name, opts)
        vim.lsp.enable(name)
      end
    end,
  },
}
