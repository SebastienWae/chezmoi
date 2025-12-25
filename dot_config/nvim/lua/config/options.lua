---@diagnostic disable: undefined-global
local opt = vim.opt

opt.autowrite = true
opt.confirm = true

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 4

opt.mouse = "a"
opt.showmode = false

-- LazyVim behavior: avoid clipboard over SSH (OSC52 etc.)
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"

opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.splitright = true
opt.splitbelow = true

opt.timeoutlen = 300
opt.updatetime = 250

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.inccommand = "split"
opt.completeopt = "menu,menuone,noselect"
opt.termguicolors = true

if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep"
  opt.grepformat = "%f:%l:%c:%m"
end
