local map = vim.keymap.set

require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false, },
  skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
  skip_ts = { "string", },
  skip_unbalanced = true,
  markdown = true,
  mappings = {
    ['"'] = {
      action = "closeopen",
      pair = '""',
      neigh_pattern = "[^%w\\].",
      register = { cr = false, },
    },
    ["`"] = {
      action = "closeopen",
      pair = "``",
      neigh_pattern = "[^%w\\].",
      register = { cr = false, },
    },
  },
})

require("nvim-ts-autotag").setup()

require("mini.comment").setup()

local mini_ai = require("mini.ai")
local function ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1, }, }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1, }, to = { line = end_line, col = to_col, }, }
end

mini_ai.setup({
  n_lines = 500,
  custom_textobjects = {
    o = mini_ai.gen_spec.treesitter({ -- code block
      a = { "@block.outer", "@conditional.outer", "@loop.outer", },
      i = { "@block.inner", "@conditional.inner", "@loop.inner", },
    }),
    c = mini_ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner", }),       -- class
    f = mini_ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner", }), -- function
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$", },                -- tags
    d = { "%f[%d]%d+", },                                                               -- digits
    e = {                                                                               -- Word with case
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]", },
      "^().*()$",
    },
    g = ai_buffer,                                                   -- buffer
    u = mini_ai.gen_spec.function_call(),                            -- u for "Usage"
    U = mini_ai.gen_spec.function_call({ name_pattern = "[%w_]", }), -- without dot in function name
  },
})

require("mini.hipatterns").setup({
  highlighters = {
    fixme = { pattern = "FIXME", group = "MiniHipatternsFixme", },
    hack = { pattern = "HACK", group = "MiniHipatternsHack", },
    todo = { pattern = "TODO", group = "MiniHipatternsTodo", },
    note = { pattern = "NOTE", group = "MiniHipatternsNote", },
  },
})

-- local flash = require("flash")
-- flash.setup({
--   modes = {
--     char = {
--       enabled = true,
--       jump_labels = true,
--       multi_line = false,
--     },
--   },
-- })
-- map({ "n", "x", "o", }, "z", flash.jump,   { desc = "Flash", })
-- map("o",                "Z", flash.remote, { desc = "Remote Flash", })
-- map({ "n", "o", "x", }, "<C-space>", function()
--   flash.treesitter({
--     actions = {
--       ["<c-space>"] = "next",
--       ["<BS>"] = "prev",
--     },
--   })
-- end, { desc = "Treesitter Incremental Selection", })

require("gitsigns").setup()

require("mini.surround").setup()

require("mini.splitjoin").setup()

require("render-markdown").setup({
  code = {
    sign = false,
    width = "block",
    right_pad = 1,
  },
  heading = {
    sign = false,
    icons = {},
  },
  checkbox = {
    enabled = true,
  },
})
