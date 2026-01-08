return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", },
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local util = require("lspconfig.util")
      local servers = {
        basedpyright = {},
        lua_ls = {},
        vtsls = {},
        biome = {},
        dockerls = {},
        docker_language_server = {},
        taplo = {},
        tailwindcss = {},
        bashls = {},
        ruff = {},
        oxfmt = {
          cmd = { "oxfmt", "--lsp", },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          workspace_required = true,
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)

            -- Oxfmt resolves configuration by walking upward and using the nearest config file
            -- to the file being processed. We therefore compute the root directory by locating
            -- the closest `.oxfmtrc.json` (or `package.json` fallback) above the buffer.
            local root_markers = util.insert_package_json({ ".oxfmtrc.json", }, "oxfmt", fname)[1]
            on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true, })[1]))
          end,
        },
        oxlint = {
          cmd = { "oxlint", "--lsp", },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          workspace_required = true,
          on_attach = function(client, bufnr)
            vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
              client:exec_cmd({
                title = "Apply Oxlint automatic fixes",
                command = "oxc.fixAll",
                arguments = { { uri = vim.uri_from_bufnr(bufnr), }, },
              })
            end, {
              desc = "Apply Oxlint automatic fixes",
            })
          end,
          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)

            -- Oxlint resolves configuration by walking upward and using the nearest config file
            -- to the file being processed. We therefore compute the root directory by locating
            -- the closest `.oxlintrc.json` (or `package.json` fallback) above the buffer.
            local root_markers = util.insert_package_json({ ".oxlintrc.json", }, "oxlint", fname)[1]
            on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true, })[1]))
          end,
          init_options = {
            settings = {
              -- ['run'] = 'onType',
              -- ['configPath'] = nil,
              -- ['tsConfigPath'] = nil,
              -- ['unusedDisableDirectives'] = 'allow',
              ["typeAware"] = true,
              -- ['disableNestedConfig'] = false,
              ["fixKind"] = "safe_fix_or_suggestion",
            },
          },
        },
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
