local map = vim.keymap.set

local trouble = require("trouble")
trouble.setup()
map("n", "<leader>xx", function() trouble.toggle("diagnostics") end, { desc = "Toggle Trouble Diagnostics", })
map("n", "<leader>xl", function() trouble.toggle("loclist") end,     { desc = "Toggle Trouble Loclist", })
map("n", "<leader>xq", function() trouble.toggle("quickfix") end,    { desc = "Toggle Trouble Quickfix", })
map("n", "<leader>cs", function() trouble.toggle("symbols") end,     { desc = "Toggle Trouble Symbolds", })
map("n", "<leader>cS", function() trouble.toggle("lsp") end,         { desc = "Toggle Trouble LSP", })

-- lsp_command: command
-- lsp_declarations: declarations
-- lsp_definitions: definitions
-- lsp_document_symbols: document symbols
-- lsp_implementations: implementations
-- lsp_incoming_calls: Incoming Calls
-- lsp_outgoing_calls: Outgoing Calls
-- lsp_references: references
-- lsp_type_definitions: type definitions

require("quicker").setup({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true, })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
})
