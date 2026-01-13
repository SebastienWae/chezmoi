-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", }, {
  group = vim.api.nvim_create_augroup("auto reload", { clear = true, }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("yank highlight", { clear = true, }),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized", }, {
  group = vim.api.nvim_create_augroup("window resize", { clear = true, }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close with q", { clear = true, }),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true, })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close man", { clear = true, }),
  pattern = { "man", },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("wrap and spell", { clear = true, }),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown", },
  callback = function()
    vim.opt_local.wrap  = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType", }, {
  group = vim.api.nvim_create_augroup("conceallevel json", { clear = true, }),
  pattern = { "json", "jsonc", "json5", },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre", }, {
  group = vim.api.nvim_create_augroup("auto create dir", { clear = true, }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd({ "FileType", }, {
  group = vim.api.nvim_create_augroup("vertical help", { clear = true, }),
  pattern = "help",
  command = "wincmd L",
})

-- disable auto comment on new line
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("disable auto comment", { clear = true, }),
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o", })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang then
      pcall(vim.treesitter.start)
    end
  end,
})

-- hide cursor on inactive buffer
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", }, {
  group = vim.api.nvim_create_augroup("hide cursor enter", { clear = true, }),
  callback = function()
    if vim.bo.buftype == "" then
      vim.opt_local.cursorline = true
    end
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", }, {
  group = vim.api.nvim_create_augroup("hide curosr leave", { clear = true, }),
  callback = function()
    if vim.bo.buftype == "" then
      vim.opt_local.cursorline = false
    end
  end,
})
