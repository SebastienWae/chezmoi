local map = Snacks.keymap.set

-- buffer nav
map("n", "bp", ":bprevious<CR>", { silent = true, })
map("n", "bn", ":bnext<CR>",     { silent = true, })

-- better up/down
map({ "n", "x", }, "j",      "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true, })
map({ "n", "x", }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true, })
map({ "n", "x", }, "k",      "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true, })
map({ "n", "x", }, "<Up>",   "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true, })

map({ "i", "n", "s", }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch", })

-- better search
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result", })
map("x", "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next Search Result", })
map("o", "n", "'Nn'[v:searchforward]",      { expr = true, desc = "Next Search Result", })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result", })
map("x", "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev Search Result", })
map("o", "N", "'nN'[v:searchforward]",      { expr = true, desc = "Prev Search Result", })

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- lsp
map("n", "<leader>ca", vim.lsp.buf.code_action, {
  lsp = { method = "textDocument/codeAction", },
  desc = "Code Action",
})
map("n", "<leader>co", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports", },
      diagnostics = {},
    },
  })
end, {
  lsp = { method = "textDocument/codeAction", },
  desc = "Organize Imports",
})
map("n", "<leader>cr", vim.lsp.buf.rename, {
  lsp = { method = "textDocument/rename", },
  desc = "rename",
})
map("n", "<leader>ch", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, {
  lsp = { method = "textDocument/inlayHint", },
  desc = "rename",
})
map("n", "K",  vim.lsp.buf.hover,           { desc = "Hover", })
map("n", "gK", vim.lsp.buf.signature_help,  { desc = "Signature Help", })
map("n", "gd", vim.lsp.buf.definition,      { desc = "Goto Definition", has = "definition", })
map("n", "gI", vim.lsp.buf.implementation,  { desc = "Goto Implementation", })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto T[y]pe Definition", })
map("n", "gD", vim.lsp.buf.declaration,     { desc = "Goto Declaration", })
