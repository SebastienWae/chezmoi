return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {},
    keys = {
      { "<C-A-h>", function() require("smart-splits").resize_left() end,       desc = "Resize split left",   mode = "n", },
      { "<C-A-j>", function() require("smart-splits").resize_down() end,       desc = "Resize split down",   mode = "n", },
      { "<C-A-k>", function() require("smart-splits").resize_up() end,         desc = "Resize split up",     mode = "n", },
      { "<C-A-l>", function() require("smart-splits").resize_right() end,      desc = "Resize split right",  mode = "n", },

      { "<C-h>",   function() require("smart-splits").move_cursor_left() end,  desc = "Move to left split",  mode = "n", },
      { "<C-j>",   function() require("smart-splits").move_cursor_down() end,  desc = "Move to below split", mode = "n", },
      { "<C-k>",   function() require("smart-splits").move_cursor_up() end,    desc = "Move to above split", mode = "n", },
      { "<C-l>",   function() require("smart-splits").move_cursor_right() end, desc = "Move to right split", mode = "n", },
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)
    end,
  },
}
