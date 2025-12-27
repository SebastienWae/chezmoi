return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    opts = function()
      local ok, lualine_modus_vivendi = pcall(require, "lualine.themes.modus_vivendi")
      if not ok then
        lualine_modus_vivendi = "auto"
      end

      local function lsp_status()
        local names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if client.name and client.name ~= "" then
            table.insert(names, client.name)
          end
        end
        return #names > 0 and table.concat(names, ",") or ""
      end

      return {
        options = {
          theme = lualine_modus_vivendi,
          icons_enabled = false,
          globalstatus = false,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "snacks_dashboard" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", lsp_status, "diagnostics" },
          lualine_c = {
            {
              "filename",
              path = 1,
            },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "searchcount", "selectioncount" },
          lualine_z = { "location", "progress" },
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
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "lazy", "quickfix" },
      }
    end,
    config = function(_, opts)
      -- Ensure we use one statusline per window.
      vim.opt.laststatus = 2
      require("lualine").setup(opts)
    end,
  },
}
