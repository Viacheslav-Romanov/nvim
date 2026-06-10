-- Core settings (no plugin dependencies, safe to load first)
require("romanov.core.options")
require("romanov.core.keymaps")
require("romanov.core.autocommands")

-- Bootstrap lazy.nvim and load all plugins.
-- Each plugin's config = function() is called by lazy itself after the plugin
-- is loaded — do NOT require plugin config files here manually.
require("romanov.plugins-setup")

-- Colorscheme is set after plugins so nightfly is available
require("romanov.core.colorscheme")
