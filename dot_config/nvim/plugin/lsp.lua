local map = vim.keymap.set

vim.lsp.enable({
  "lua_ls",
  "marksman",
})

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
} --[[@as vim.lsp.Config]])

-- lsp config for neovim config
require("lazydev").setup()

-- diagnostic
vim.diagnostic.config({
  virtual_text = { spacing = 4, prefix = "●", },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "single", source = "if_many", },
})
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " ", }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "", })
end

-- keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true, }

    -- map("n", "gd", vim.lsp.buf.definition, opts)
    -- map("n", "gD", vim.lsp.buf.declaration, opts)
    -- map("n", "gi", vim.lsp.buf.implementation, opts)
    -- map("n", "gr", vim.lsp.buf.references, opts)
    -- map("n", "gy", vim.lsp.buf.type_definition, opts)

    map("n", "K",     vim.lsp.buf.hover,          opts)
    map("n", "gK",    vim.lsp.buf.signature_help, opts)
    map("i", "<C-k>", vim.lsp.buf.signature_help, opts)

    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "<leader>cr", vim.lsp.buf.rename,      opts)

    map("n", "<leader>cd", vim.diagnostic.open_float, opts)
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, })
    end, opts)
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, })
    end, opts)
    map("n", "<leader>q", vim.diagnostic.setloclist, opts)

    if vim.lsp.inlay_hint then
      map("n", "<leader>ch", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, opts)
    end
  end,
})
