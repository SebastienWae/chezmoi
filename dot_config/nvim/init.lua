-- leader
vim.g.mapleader      = " "
vim.g.maplocalleader = ","


-- pack
local specs = {
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/bullets-vim/bullets.vim",
  "https://github.com/folke/flash.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/m4xshen/hardtime.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/miikanissi/modus-themes.nvim",
  "https://github.com/mrjones2014/smart-splits.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/nvim-mini/mini.bufremove",
  "https://github.com/nvim-mini/mini.comment",
  "https://github.com/nvim-mini/mini.hipatterns",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.splitjoin",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/s1n7ax/nvim-window-picker",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/windwp/nvim-ts-autotag",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter",             version = "main", },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main", },
}

vim.pack.add(specs)

local function get_plugin_names()
  local names = {}
  for _, spec in ipairs(specs) do
    local name
    if type(spec) == "string" then
      name = spec:match("[^/]+$")
    elseif type(spec) == "table" and spec.src then
      name = spec.src:match("[^/]+$")
    end
    if name then
      table.insert(names, name)
    end
  end
  return names
end

vim.api.nvim_create_user_command("PackUpdate", function(opts)
  local args = opts.fargs
  local target_plugins
  if #args > 0 then
    target_plugins = args
  else
    target_plugins = get_plugin_names()
  end
  vim.notify("Updating " .. #target_plugins .. " plugins...", vim.log.levels.INFO)
  vim.pack.update(target_plugins)
end, {
  nargs = "*",
  complete = function()
    return get_plugin_names()
  end,
})

vim.api.nvim_create_autocmd(
  "PackChanged",
  {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind

      if name == "blink.cmp" and (kind == "install" or kind == "update") then
        vim.notify("Building blink.cmp", vim.log.levels.INFO)
        local obj = vim.system({ "cargo", "build", "--release", }, { cwd = ev.data.path, }):wait()
        if obj.code == 0 then
          vim.notify("Building blink.cmp done", vim.log.levels.INFO)
        else
          vim.notify(
            "Building blink.cmp failed", vim.log.levels.ERROR)
        end
      end
    end,
  }
)


-- TODO: delete at some point
require("hardtime").setup({
  disabled_filetypes = {
    "qf",
    "netrw",
    "lazy",
    "mason",
    "vim",
  },
  disable_mouse = false,
})
