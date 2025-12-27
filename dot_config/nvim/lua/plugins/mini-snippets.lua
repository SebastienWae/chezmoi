return {
  {
    -- https://nvim-mini.org/mini.nvim/readmes/mini-snippets.html
    "echasnovski/mini.snippets",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      require("mini.snippets").setup(opts)
      local MiniSnippets = _G.MiniSnippets

      -- By default, a snippet session stops on Normal-mode exit only if the
      -- cursor is at the final tabstop ($0). If you leave Insert mode early,
      -- tabstop highlighting/virtualtext can stick around.
      --
      -- This mirrors the upstream recipe: stop all active (including nested)
      -- sessions whenever we go back to Normal mode.
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniSnippetsSessionStart",
        callback = function()
          vim.api.nvim_create_autocmd("ModeChanged", {
            pattern = "*:n",
            once = true,
            callback = function()
              while MiniSnippets.session.get() do
                MiniSnippets.session.stop()
              end
            end,
          })
        end,
      })
    end,
  },
}
