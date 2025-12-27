return {
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "1.*",
    dependencies = {
      "echasnovski/mini.snippets",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      snippets = { preset = "mini_snippets", },
      keymap = {
        preset = "enter",
        ["<CR>"] = { "select_and_accept", "fallback", },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback", },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback", },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp", },
          },
        },
        ghost_text = {
          enabled = true,
        },
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
      signature = {
        enabled = true,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev", },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          snippets = {
            opts = {
              -- Keep using the built-in snippets provider (friendly-snippets + ~/.config/nvim/snippets)
              -- while using mini.snippets as the snippet engine.
              preset = "default",
            },
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning", },
    },
    opts_extend = { "sources.default", },
  },
}
