vim.keymap.set("n", "<leader>e", "<cmd>:Neotree focus<cr>", {})
vim.keymap.set("n", "<leader>l", ":lua vim.lsp.buf.format()<CR>", {})

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

vim.keymap.set("n", ">)", "<Plug>(sexp_emit_tail_element)")
vim.keymap.set("n", "<)", "<Plug>(sexp_capture_next_element)")
vim.keymap.set("n", ">(", "<Plug>(sexp_emit_head_element)")
vim.keymap.set("n", "<(", "<Plug>(sexp_capture_previous_element)")

-- Store the last two opened buffer numbers in variables
vim.g.last_buffer_1 = -1
vim.g.last_buffer_2 = -1

-- Create a custom Lua function to toggle between the last two opened buffers
function _G.ToggleLastTwoBuffers()
  local current_buffer = vim.api.nvim_get_current_buf()

  if vim.g.last_buffer_1 > 0 and vim.g.last_buffer_2 > 0 then
    if current_buffer == vim.g.last_buffer_1 then
      vim.api.nvim_set_current_buf(vim.g.last_buffer_2)
    else
      vim.api.nvim_set_current_buf(vim.g.last_buffer_1)
    end
  end
end

-- Create a custom Lua function to update the last two opened buffers
function _G.UpdateLastTwoBuffers()
  local current_buffer = vim.api.nvim_get_current_buf()
  local buffer_name = vim.api.nvim_buf_get_name(current_buffer)

  -- Only update the variables for file buffers
  if buffer_name ~= "" then
    if vim.g.last_buffer_2 ~= current_buffer then
      vim.g.last_buffer_1 = vim.g.last_buffer_2
    end
    vim.g.last_buffer_2 = current_buffer
  end
end

-- Set the keymap to call the custom Lua function
vim.api.nvim_set_keymap("n", "<C-Tab>", ":lua ToggleLastTwoBuffers()<CR>", { noremap = true, silent = true })

-- Set the autocommand to update the last two opened buffers
vim.cmd([[
  augroup update_last_two_buffers
    autocmd!
    autocmd BufEnter * lua UpdateLastTwoBuffers()
  augroup END
]])

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})

-- sexp
--
-- local function map(mode, rhs, lhs, opts)
--   opts.buffer = 0
--   vim.keymap.set(mode, rhs, lhs, opts)
-- end
--
-- local function xmap(rhs, lhs, opts)
--   map("x", rhs, lhs, opts)
-- end
--
-- local function nmap(rhs, lhs, opts)
--   map("n", rhs, lhs, opts)
-- end
--
-- local function omap(rhs, lhs, opts)
--   map("o", rhs, lhs, opts)
-- end
--
-- local function imap(rhs, lhs, opts)
--   map("i", rhs, lhs, opts)
-- end
--
--
