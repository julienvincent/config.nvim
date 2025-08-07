require("julienvincent.lazy")
require("julienvincent.options")
require("julienvincent.filetypes")

require("julienvincent.modules").setup()

-- Experimental replacement to the vim messages interface
require("vim._extui").enable({})
