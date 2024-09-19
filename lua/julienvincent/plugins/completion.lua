local function is_clojure_core_import(item)
  if not item.data or not item.data.unresolved then
    return false
  end

  for _, entry in ipairs(item.data.unresolved) do
    if entry[1] == "alias" then
      if entry[2]["ns-to-add"] == "clojure.core" then
        return true
      end
    end
  end
end

return {
  {
    "Saghen/blink.cmp",
    config = function()
      require("blink.cmp").setup({
        fuzzy = {
          prebuilt_binaries = {
            -- force_version = "v0.9.0",
          },
        },

        keymap = {
          preset = "enter",

          ["<Tab>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            "snippet_forward",
            "fallback",
          },

          ["<C-u>"] = { "scroll_documentation_up", "fallback" },
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        },

        appearance = {
          use_nvim_cmp_as_default = true,
        },

        completion = {
          documentation = {
            auto_show = true,
          },

          list = {
            selection = function(ctx)
              if ctx.mode == "cmdline" then
                return "auto_insert"
              end
              return "preselect"
            end,
          },

          menu = {
            draw = {
              columns = {
                { "label", "label_description", gap = 1 },
                { "kind_icon" },
              },
            },
          },
        },

        sources = {
          default = { "lsp", "path", "snippets" },

          providers = {
            lsp = {
              -- Primarilly copy-pasted from the default config for blink.cmp
              -- but added a custom item filter to remove `clojure.core` alias
              -- imports.
              --
              -- These are incredibly annoying auto-completion items that show
              -- up as `c/<text>` for all clojure.core functions
              transform_items = function(_, items)
                -- demote snippets
                for _, item in ipairs(items) do
                  if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                    item.score_offset = item.score_offset - 3
                  end
                end

                local is_clojure = vim.bo.filetype == "clojure"

                -- filter out text items, since we have the buffer source
                return vim.tbl_filter(function(item)
                  if item.kind == require("blink.cmp.types").CompletionItemKind.Text then
                    return false
                  end

                  if is_clojure and is_clojure_core_import(item) then
                    return false
                  end

                  return true
                end, items)
              end,
            },

            snippets = {
              opts = {
                get_filetype = function(_)
                  local ft = vim.bo.filetype
                  -- Just use javascript snippets for ts[x] filetypes
                  if string.match(ft, "^typescript") ~= nil then
                    return "javascript"
                  end
                  return ft
                end,
              },
            },
          },
        },
      })
    end,
  },
}
