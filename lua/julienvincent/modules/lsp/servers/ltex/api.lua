local fs = require("julienvincent.modules.lsp.servers.ltex.fs")

local M = {}

local function update_client_config(client, lang)
  local settings = client.config.settings
  settings.ltex.dictionary[lang] = fs.read_file(fs.dict_file(lang))
  settings.ltex.disabledRules[lang] = fs.read_file(fs.disabled_rules_file(lang))
  client.notify("workspace/didChangeConfiguration", settings)
end

function M.add_to_dict(client, params)
  local args = params.arguments[1].words
  for lang, words in pairs(args) do
    fs.append_file(fs.dict_file(lang), words)
    vim.schedule(function()
      update_client_config(client, lang)
    end)
  end
end

function M.add_to_disabled_rules(client, params)
  local args = params.arguments[1].ruleIds
  for lang, rules in pairs(args) do
    fs.append_file(fs.disabled_rules_file(lang), rules)
    vim.schedule(function()
      update_client_config(client, lang)
    end)
  end
end

function M.remove_from_dict(client, lang)
  local fzf = require("fzf-lua")

  local opts = {
    prompt = "Delete Words❯ ",
    previewer = false,
    winopts = {
      preview = {
        hidden = "hidden",
      },
      height = 0.30,
      width = 0.40,
      row = 0.3,
    },
    fzf_opts = {
      ["--multi"] = true,
      ["--layout"] = "reverse",
    },
    keymap = {
      fzf = {
        ["tab"] = "select",
        ["shift-tab"] = "deselect",
      },
    },
    actions = {
      ["ctrl-d"] = {
        function(selected)
          local words = vim.tbl_filter(function(word)
            return not vim.tbl_filter(function(value)
              return value == word
            end, selected)[1]
          end, fs.read_file(fs.dict_file(lang)))

          fs.write_file(fs.dict_file(lang), words)
          vim.schedule(function()
            update_client_config(client, lang)
          end)
        end,
        fzf.actions.resume,
      },
    },
  }

  local function builder(cb)
    local words = fs.read_file(fs.dict_file("en-GB"))
    for _, word in ipairs(words) do
      cb(word)
    end
    cb()
  end

  fzf.fzf_exec(builder, opts)
end

return M
