local function vim_sexp_mappings()
  local function map(mode, rhs, lhs, opts)
    opts.buffer = 0
    vim.keymap.set(mode, rhs, lhs, opts)
  end

  local function xmap(rhs, lhs, opts)
    map("x", rhs, lhs, opts)
  end

  local function nmap(rhs, lhs, opts)
    map("n", rhs, lhs, opts)
  end

  local function omap(rhs, lhs, opts)
    map("o", rhs, lhs, opts)
  end

  local function imap(rhs, lhs, opts)
    map("i", rhs, lhs, opts)
  end

  nmap("(", "<Plug>(sexp_move_to_prev_bracket)", { desc = "Sexp move to prev bracket" })
  nmap(")", "<Plug>(sexp_move_to_next_bracket)", { desc = "Sexp move to next bracket" })

  nmap("B", "<Plug>(sexp_move_to_prev_element_head)", { desc = "Sexp move to prev element head" })
  xmap("B", "<Plug>(sexp_move_to_prev_element_head)", { desc = "Sexp move to prev element head" })
  omap("B", "<Plug>(sexp_move_to_prev_element_head)", { desc = "Sexp move to prev element head" })
  nmap("E", "<Plug>(sexp_move_to_next_element_tail)", { desc = "Sexp move to next element tail" })
  xmap("E", "<Plug>(sexp_move_to_next_element_tail)", { desc = "Sexp move to next element tail" })
  omap("E", "<Plug>(sexp_move_to_next_element_tail)", { desc = "Sexp move to next element tail" })

  nmap("<LocalLeader>(", "<Plug>(sexp_round_head_wrap_list)", { desc = "Sexp round head wrap list" })
  xmap("<LocalLeader>(", "<Plug>(sexp_round_head_wrap_list)", { desc = "Sexp round head wrap list" })
  nmap("<LocalLeader>)", "<Plug>(sexp_round_tail_wrap_list)", { desc = "Sexp round tail wrap list" })
  xmap("<LocalLeader>)", "<Plug>(sexp_round_tail_wrap_list)", { desc = "Sexp round tail wrap list" })
  nmap("<localleader>[", "<Plug>(sexp_square_head_wrap_list)", { desc = "Sexp square head wrap list" })
  xmap("<localleader>[", "<Plug>(sexp_square_head_wrap_list)", { desc = "Sexp square head wrap list" })
  nmap("<localleader>]", "<Plug>(sexp_square_tail_wrap_list)", { desc = "Sexp square tail wrap list" })
  xmap("<localleader>]", "<Plug>(sexp_square_tail_wrap_list)", { desc = "Sexp square tail wrap list" })
  nmap("<localleader>{", "<Plug>(sexp_curly_head_wrap_list)", { desc = "Sexp curly head wrap list" })
  xmap("<localleader>{", "<Plug>(sexp_curly_head_wrap_list)", { desc = "Sexp curly head wrap list" })
  nmap("<localleader>}", "<Plug>(sexp_curly_tail_wrap_list)", { desc = "Sexp curly tail wrap list" })
  xmap("<localleader>}", "<Plug>(sexp_curly_tail_wrap_list)", { desc = "Sexp curly tail wrap list" })

  nmap("<localleader>e(", "<Plug>(sexp_round_head_wrap_element)", { desc = "Sexp round head wrap element" })
  xmap("<localleader>e(", "<Plug>(sexp_round_head_wrap_element)", { desc = "Sexp round head wrap element" })
  nmap("<localleader>e)", "<Plug>(sexp_round_tail_wrap_element)", { desc = "Sexp round tail wrap element" })
  xmap("<localleader>e)", "<Plug>(sexp_round_tail_wrap_element)", { desc = "Sexp round tail wrap element" })
  nmap("<localleader>e[", "<Plug>(sexp_square_head_wrap_element)", { desc = "Sexp square head wrap element" })
  xmap("<localleader>e[", "<Plug>(sexp_square_head_wrap_element)", { desc = "Sexp square head wrap element" })
  nmap("<localleader>e]", "<Plug>(sexp_square_tail_wrap_element)", { desc = "Sexp square tail wrap element" })
  xmap("<localleader>e]", "<Plug>(sexp_square_tail_wrap_element)", { desc = "Sexp square tail wrap element" })
  nmap("<localleader>e{", "<Plug>(sexp_curly_head_wrap_element)", { desc = "Sexp curly head wrap element" })
  xmap("<localleader>e{", "<Plug>(sexp_curly_head_wrap_element)", { desc = "Sexp curly head wrap element" })
  nmap("<localleader>e}", "<Plug>(sexp_curly_tail_wrap_element)", { desc = "Sexp curly tail wrap element" })
  xmap("<localleader>e}", "<Plug>(sexp_curly_tail_wrap_element)", { desc = "Sexp curly tail wrap element" })

  nmap("<localleader>@", "<Plug>(sexp_splice_list)", { desc = "Sexp splice list" })
  nmap("<localleader>r", "<Plug>(sexp_raise_element)", { desc = "Raise element", noremap = true })
  xmap("<localleader>r", "<Plug>(sexp_raise_element)", { desc = "Raise element", noremap = true })
  nmap("<localleader>R", "<Plug>(sexp_raise_list)", { desc = "Raise list", noremap = true })
  xmap("<localleader>R", "<Plug>(sexp_raise_list)", { desc = "Raise list", noremap = true })

  nmap("<M-S-h>", "<Plug>(sexp_swap_list_backward)", { desc = "Sexp swap list backward" })
  xmap("<M-S-h>", "<Plug>(sexp_swap_list_backward)", { desc = "Sexp swap list backward" })
  nmap("<M-S-l>", "<Plug>(sexp_swap_list_forward)", { desc = "Sexp swap list forward" })
  xmap("<M-S-l>", "<Plug>(sexp_swap_list_forward)", { desc = "Sexp swap list forward" })
  nmap("<M-h>", "<Plug>(sexp_swap_element_backward)", { desc = "Sexp swap element backward" })
  xmap("<M-h>", "<Plug>(sexp_swap_element_backward)", { desc = "Sexp swap element backward" })
  nmap("<M-l>", "<Plug>(sexp_swap_element_forward)", { desc = "Sexp swap element forward" })
  xmap("<M-l>", "<Plug>(sexp_swap_element_forward)", { desc = "Sexp swap element forward" })

  nmap("<M-S-Left>", "<Plug>(sexp_swap_list_backward)", { desc = "Sexp swap list backward" })
  xmap("<M-S-Left>", "<Plug>(sexp_swap_list_backward)", { desc = "Sexp swap list backward" })
  nmap("<M-S-Right>", "<Plug>(sexp_swap_list_forward)", { desc = "Sexp swap list forward" })
  xmap("<M-S-Right>", "<Plug>(sexp_swap_list_forward)", { desc = "Sexp swap list forward" })
  nmap("<M-Left>", "<Plug>(sexp_swap_element_backward)", { desc = "Sexp swap element backward" })
  xmap("<M-Left>", "<Plug>(sexp_swap_element_backward)", { desc = "Sexp swap element backward" })
  nmap("<M-Right>", "<Plug>(sexp_swap_element_forward)", { desc = "Sexp swap element forward" })
  xmap("<M-Right>", "<Plug>(sexp_swap_element_forward)", { desc = "Sexp swap element forward" })

  nmap("<S-Left>", "<Plug>(sexp_capture_next_element)", { desc = "Slurp" })
  xmap("<S-Left>", "<Plug>(sexp_capture_next_element)", { desc = "Slurp" })
  nmap("<S-Right>", "<Plug>(sexp_emit_tail_element)", { desc = "Barf" })
  xmap("<S-Right>", "<Plug>(sexp_emit_tail_element)", { desc = "Barf" })
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("FileType", {
  group = augroup("VimSexp", { clear = true }),
  pattern = { "clojure" },
  callback = vim_sexp_mappings,
})

return {
  {
    "guns/vim-sexp",
    ft = { "clojure" },

    init = function()
      vim.g.sexp_filetypes = ""
      vim.g.sexp_enable_insert_mode_mappings = 0
    end,

    dependencies = {
      "radenling/vim-dispatch-neovim",
      "tpope/vim-repeat",
    },
  },
}
