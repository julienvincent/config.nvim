local M = {}

function M.open()
  if vim.fn.executable("serpl") ~= 1 then
    vim.notify("Serpl not installed on system path", vim.log.levels.ERROR)
    return
  end

  local Popup = require("nui.popup")

  vim.api.nvim_command("highlight FindAndReplaceBackdrop guibg=#1c1c1c")

  local backdrop = Popup({
    position = "50%",
    size = {
      width = "100%",
      height = "100%",
    },
    enter = false,
    focusable = false,
    zindex = 40,
    relative = "editor",
    buf_options = {
      modifiable = false,
      readonly = true,
    },
    win_options = {
      winhighlight = "Normal:FindAndReplaceBackdrop",
      winblend = 40,
    },
  })

  local term_window = Popup({
    zindex = 50,
    enter = true,
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
    border = {
      style = "rounded",
      padding = {
        top = 1,
        bottom = 1,
        left = 3,
        right = 3,
      },
      text = {
        top = " Find and Replace ",
        top_align = "left",
      },
    },

    buf_options = {
      modifiable = false,
      readonly = true,
    },

    relative = "editor",
    position = "50%",
    size = {
      width = "70%",
      height = "60%",
    },
  })

  backdrop:mount()
  term_window:mount()

  vim.schedule(function()
    vim.cmd(":term serpl -p " .. vim.fn.getcwd())
    vim.cmd("startinsert")

    vim.keymap.set("t", "<esc>", function()
      term_window:unmount()
      backdrop:unmount()
    end, {
      buffer = 0,
    })
  end)
end

function M.setup()
  vim.keymap.set("n", "<leader>R", M.open, {
    desc = "find-and-replace",
    noremap = true,
    silent = true,
  })
end

return M
