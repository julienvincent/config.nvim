local function is_node_within_type(node, types)
  for _, type in ipairs(types) do
    if node:type() == type then
      return true
    end
  end

  local parent = node:parent()
  if not parent then
    return false
  end

  return is_node_within_type(parent, types)
end

local function in_ts_capture(types)
  local ts = require("nvim-treesitter.ts_utils")

  local current_node = ts.get_node_at_cursor()
  if not current_node then
    return
  end

  return is_node_within_type(current_node, types)
end

return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.0.*",
    event = "BufReadPost",
    config = function()
      local luasnip = require("luasnip")

      luasnip.setup()
      luasnip.filetype_extend("typescript", { "javascript" })

      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "BufReadPost",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "petertriho/cmp-git",
    },
    config = function()
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local cmp = require("cmp")

      local compare = require("cmp.config.compare")

      cmp.setup({
        -- disable completion in comments
        enabled = function()
          local context = require("cmp.config.context")
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          end

          if context.in_treesitter_capture("comment") then
            return false
          end

          local is_in_string = context.in_treesitter_capture("string")
          local is_in_import_or_export = in_ts_capture({ "import_statement", "export_statement" })
          if is_in_string and not is_in_import_or_export then
            return false
          end

          return true
        end,

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
          }),
          fields = { "abbr", "kind" },
        },

        preselect = "item",
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm(),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              cmp.confirm()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        },

        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "path" },
        },

        sorting = {
          priority_weight = 1.0,
          comparators = {
            compare.locality,
            compare.score,
            compare.recently_used,
            compare.offset,
            compare.order,
          },
        },
      })

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }),
      })

      cmp.setup.filetype("clojure", {
        sources = cmp.config.sources({
          { name = "nvim_lsp", trigger_characters = { "." } },
        }),
      })
    end,
  },
}
