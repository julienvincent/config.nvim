local deps = require("julienvincent.modules.lsp.servers.jdtls.libs")
local mason = require("julienvincent.modules.lsp.utils.mason")
local fs = require("julienvincent.modules.lsp.utils.fs")

return function()
  local jdtls = require("jdtls")

  local home_dir = os.getenv("HOME")
  local cwd = vim.fn.getcwd()

  return {
    name = "jdtls",
    filetypes = { "java" },

    cmd = function()
      local paths = mason.get_package("jdtls")
      if not paths then
        return
      end

      local config_dir = "config_mac"
      if vim.fn.has("linux") == 1 then
        config_dir = "config_linux"
      end

      local project_id = vim.fn.sha256(cwd)
      local data_dir = home_dir .. "/.local/share/nvim/jdtls/projects/" .. project_id

      local launcher = fs.find_file_by_glob(paths.install_dir .. "/plugins", "org.eclipse.equinox.launcher_*")

      return {
        "java",

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        "-jar",
        launcher,

        "-configuration",
        paths.install_dir .. "/" .. config_dir,

        "-data",
        data_dir,
      }
    end,
    root_dir = fs.find_furthest_root({ "deps.edn", ".git" }, fs.fallback_fn_cwd),

    start = function(config, opts)
      local libs = {}
      if config.root_dir then
        libs = deps.find_third_party_libs(config.root_dir)
      end

      return jdtls.start_or_attach(
        vim.tbl_deep_extend("force", {}, config, {
          settings = {
            java = {
              project = {
                referencedLibraries = libs,
              },
            },
          },
        }),
        {},
        opts
      )
    end,

    single_file_support = true,
    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
      },
    },

    init_options = {
      extendedClientCapabilities = vim.tbl_deep_extend("force", {}, jdtls.extendedClientCapabilities, {
        resolveAdditionalTextEditsSupport = true,
      }),
    },
  }
end
