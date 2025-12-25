local map = vim.keymap.set

local smart_splits = require("smart-splits")
map("n", "<C-A-h>", smart_splits.resize_left)
map("n", "<C-A-j>", smart_splits.resize_down)
map("n", "<C-A-k>", smart_splits.resize_up)
map("n", "<C-A-l>", smart_splits.resize_right)
map("n", "<C-h>",   smart_splits.move_cursor_left)
map("n", "<C-j>",   smart_splits.move_cursor_down)
map("n", "<C-k>",   smart_splits.move_cursor_up)
map("n", "<C-l>",   smart_splits.move_cursor_right)

local window_picker = require("window-picker")
window_picker.setup({
  show_prompt = false,
})
map("n", "<leader>wo", function()
  -- Swap with visual cue
  local target = window_picker.pick_window({ hint = "floating-big-letter", })
  if not target then
    return
  end
  local current = vim.api.nvim_get_current_win()

  -- swap buffers
  local cur_buf = vim.api.nvim_win_get_buf(current)
  local tgt_buf = vim.api.nvim_win_get_buf(target)

  vim.api.nvim_win_set_buf(current, tgt_buf)
  vim.api.nvim_win_set_buf(target,  cur_buf)
end, { desc = "Swap window using picker", })

-- Global helper function to inspect data in a floating window or split
_G.dump = function(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, "\n"), "\n")

  -- Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set filetype to lua for syntax highlighting
  vim.bo[buf].bufhidden = "wipe" -- Destroy buffer when window is closed
  vim.bo[buf].buftype = "nofile" -- Buffer is not related to a file
  vim.bo[buf].swapfile = false   -- Do not create a swapfile
  vim.bo[buf].filetype = "lua"

  -- Write the data to the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Open the buffer in a split (change to 'vsplit' for vertical)
  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, buf)

  -- Optional: Move cursor to top of the new window
  vim.api.nvim_win_set_cursor(0, { 1, 0, })

  vim.keymap.set("n", "q", "<cmd>close<CR>", {
    buffer = buf,
    silent = true,
    nowait = true,
  })
end

vim.api.nvim_create_user_command("Messages", function()
  local scratch_buffer = vim.api.nvim_create_buf(false, true)
  vim.bo[scratch_buffer].filetype = "vim"
  local messages = vim.fn.execute("messages")
  local lines = vim.split(messages, "\n")
  vim.api.nvim_buf_set_lines(scratch_buffer, 0, -1, false, lines)
  vim.cmd("vertical sbuffer " .. scratch_buffer)
end, {})
