return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true, },
      quickfile = { enabled = true, },
      win = { enabled = true, },
      image = { enabled = true, },
      words = { enabled = true, },
      indent = {
        enabled = true,
        indent = {
          char = "╎",
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = true,
        },
        chunk = {
          enabled = false,
        },
      },
      notifier = { enabled = true, },
      picker = {
        sources = {
        },
      },
    },
    keys = {
      -- buffers
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Buffer: delete",
      },
      {
        "<leader>bD",
        function()
          Snacks.bufdelete({ force = true, })
        end,
        desc = "Buffer: delete (force)",
      },
      -- pickers
      { "<leader>bb", function() Snacks.picker.buffers() end,  desc = "Buffers", },

      { "<leader>fe", function() Snacks.explorer() end,        desc = "File Explorer", },
      { "<leader>ff", function() Snacks.picker.files() end,    desc = "Find Files", },

      { "<leader>sp", function() Snacks.picker.pickers() end,  desc = "Pickers", },
      { "<leader>sg", function() Snacks.picker.grep() end,     desc = "Grep", },
      { "<leader>sh", function() Snacks.picker.help() end,     desc = "Help Pages", },
      { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands", },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
    end,
  },
}
