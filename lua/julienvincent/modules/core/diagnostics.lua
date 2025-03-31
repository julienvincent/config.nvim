return {
  setup = function()
    vim.diagnostic.config({
      virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = " ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    local virtual_lines_toggled = false
    vim.keymap.set("n", "<localleader>d", function()
      if virtual_lines_toggled then
        vim.diagnostic.config({
          virtual_lines = false,
        })
      else
        vim.diagnostic.config({
          virtual_lines = {
            current_line = true,
          },
        })
      end

      virtual_lines_toggled = not virtual_lines_toggled
    end)

    vim.api.nvim_create_autocmd("CursorMoved", {
      desc = "Turn off virtual lines on cursor moved",
      callback = function(_)
        if virtual_lines_toggled then
          vim.diagnostic.config({
            virtual_lines = false,
          })
          virtual_lines_toggled = false
        end
      end,
    })
  end,
}
