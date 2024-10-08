local api = require("julienvincent.modules.lsp.servers.ltex.api")
local fs = require("julienvincent.modules.lsp.servers.ltex.fs")
local mason = require("julienvincent.modules.core.mason")

return function()
  local lang = "en-GB"

  return {
    name = "ltex-ls",
    filetypes = {
      "gitcommit",
      "markdown",
      "html",
      "xhtml",
      "text",
    },

    cmd = mason.command("ltex-ls"),
    root_dir = nil,

    single_file_support = true,

    settings = {
      ltex = {
        enabled = {
          markdown = true,
          plaintext = true,
        },
        dictionary = {
          [lang] = fs.read_file(fs.dict_file(lang)),
        },
        disabledRules = {
          [lang] = fs.read_file(fs.disabled_rules_file(lang)),
        },
        checkFrequency = "save",
        diagnosticSeverity = "warning",
        language = lang,
        additionalRules = {
          enablePickyRules = true,
          motherTongue = lang,
        },
      },
    },

    on_init = function(client)
      vim.lsp.commands["_ltex.addToDictionary"] = function(params)
        api.add_to_dict(client, params)
      end

      vim.lsp.commands["_ltex.disableRules"] = function(params)
        api.add_to_disabled_rules(client, params)
      end

      vim.api.nvim_create_user_command("UpdateDict", function()
        api.remove_from_dict(client, lang)
      end, { nargs = 0 })
    end,
  }
end
