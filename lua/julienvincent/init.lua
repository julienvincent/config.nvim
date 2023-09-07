require("julienvincent.core.lazy")
require("julienvincent.core.keymaps")
require("julienvincent.core.autocmds")
require("julienvincent.core.options")

require("julienvincent.lang.authzed").setup()
require("julienvincent.lang.http").setup()

require("julienvincent.behaviours.buffer-switching").setup()
require("julienvincent.behaviours.yank-to-clipboard").setup()
require("julienvincent.behaviours.tab-name").setup()
require("julienvincent.behaviours.auto-save").setup()
require("julienvincent.behaviours.undo").setup()
