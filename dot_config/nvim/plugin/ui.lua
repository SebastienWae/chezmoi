local map = vim.keymap.set
local snacks = require("snacks")

require("modus-themes").setup({
  style = "modus_vivendi",
})
vim.cmd([[colorscheme modus]])

local lualine_modus_vivendi = require("lualine.themes.modus-vivendi")
lualine_modus_vivendi.inactive = lualine_modus_vivendi.normal
require("lualine").setup({
  options = {
    theme = lualine_modus_vivendi,
    icons_enabled = false,
    component_separators = { left = "", right = "", },
    section_separators = { left = "", right = "", },
  },
  sections = {
    lualine_a = { "mode", },
    lualine_b = {
      "branch",
      "diff",
      "lsp_status",
      "diagnostics",
    },
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype", },
    lualine_y = {
      "searchcount",
      "selectioncount",
    },
    lualine_z = {
      "location",
      "progress",
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        "filename",
        path = 1,
      },
    },
    lualine_x = { "location", },
    lualine_y = {},
    lualine_z = {},
  },
})

require("oil").setup()
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions[1].type == "move" then
      snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})
map("n", "<leader>fd", "<CMD>Oil<CR>", { desc = "Open parent directory", })

-- title
vim.opt.title = true
function _G.get_project_name()
  local clients = vim.lsp.get_clients({ bufnr = 0, })
  for _, client in pairs(clients) do
    if client.config.root_dir then
      return vim.fn.fnamemodify(client.config.root_dir, ":t")
    end
  end
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged", "LspAttach", }, {
  callback = function()
    vim.opt.titlestring = "nvim - %{v:lua.get_project_name()} - %t"
  end,
})
