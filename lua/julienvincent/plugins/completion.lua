return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      -- { "PaterJason/cmp-conjure" },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua"
    },
    config = function()
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local cmp = require("cmp")

      cmp.setup({
        -- disable completion in comments
        enabled = function()
          local context = require 'cmp.config.context'
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == 'c' then
            return true
          else
            return not context.in_treesitter_capture("comment")
                and not context.in_treesitter_capture("string")
          end
        end,

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 80,
            ellipsis_char = "...",
            before = function(_, vim_item)
              return vim_item
            end,
            menu = {
              conjure = "[conjure]",
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              nvim_lua = "[Lua]",
            },
          }),
          fields = { "menu", "abbr", "kind" },
        },

        preselect = "item",
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm(),

          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
        },
        sources = {
          { name = "nvim_lsp" },
          -- { name = 'conjure' },
          { name = 'nvim_lua' },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },
      })

      -- cmp.setup.cmdline({ "/", "?" }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = "buffer" },
      --   },
      -- })
      -- cmp.setup.cmdline(":", {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = "path" },
      --   }, {
      --     { name = "cmdline" },
      --   }),
      -- })
    end,
  }
}
