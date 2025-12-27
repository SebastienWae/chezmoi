local g   = vim.g
local o   = vim.o
local opt = vim.opt

-- UI
opt.number         = true
opt.relativenumber = true
opt.cursorline     = true
opt.signcolumn     = "yes"
opt.showmode       = false
opt.laststatus     = 2
opt.scrolloff      = 8
opt.sidescrolloff  = 8
opt.pumheight      = 10

-- Editing
opt.expandtab   = true
opt.shiftwidth  = 2
opt.tabstop     = 2
opt.smartindent = true
opt.shiftround  = true
opt.breakindent = true

-- Wrapping
opt.linebreak = true

-- Search
opt.ignorecase = true
opt.smartcase  = true
opt.inccommand = "split"
opt.grepprg    = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Splits
opt.splitright = true
opt.splitbelow = true
opt.splitkeep  = "screen"

-- System
opt.mouse      = "a"
opt.undofile   = true
opt.undolevels = 10000
opt.updatetime = 200
opt.timeoutlen = 500
opt.confirm    = true
opt.autowrite  = true

-- clipboard
vim.schedule(function()
  opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
end)

-- whitespace display
opt.list      = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", }

-- folding
o.foldmethod = "expr"
o.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel  = 99

-- misc
opt.virtualedit  = "block"
opt.smoothscroll = true
g.health         = { style = "vsplit", }
opt.shortmess:append({ W = true, I = true, c = true, C = true, S = true, })
opt.exrc = true
o.winborder = "single"
