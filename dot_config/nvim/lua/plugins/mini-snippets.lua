return {
  {
    "echasnovski/mini.snippets",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      require("mini.snippets").setup(opts)
      local MiniSnippets = _G.MiniSnippets

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
