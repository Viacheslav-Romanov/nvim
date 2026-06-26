-- plugins/alpha.lua
-- alpha-nvim: startup dashboard shown when nvim is opened with no file args.
-- Night-sky themed to match the nightfly colorscheme.

local ok, alpha = pcall(require, "alpha")
if not ok then return end

local dashboard = require("alpha.themes.dashboard")

-- ── Highlight colours (nightfly palette) ─────────────────────────────────
local function apply_hl()
  -- Dim stars — just barely visible against nightfly's #011627 background
  vim.api.nvim_set_hl(0, "AlphaStar",     { fg = "#1d3b53" })
  -- NEOVIM logo — nightfly blue
  vim.api.nvim_set_hl(0, "AlphaHeader",   { fg = "#82aaff", bold = true })
  -- Language subtitle — nightfly cyan
  vim.api.nvim_set_hl(0, "AlphaSubtitle", { fg = "#4fc1ff" })
  -- Button shortcut key — orange accent
  vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#ff9e64", bold = true })
  -- Button text — soft green
  vim.api.nvim_set_hl(0, "AlphaButtons",  { fg = "#c3e88d" })
  -- Footer — very dim
  vim.api.nvim_set_hl(0, "AlphaFooter",   { fg = "#444b6a", italic = true })
end

apply_hl()
-- Re-apply after any colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_hl,
  desc = "Re-apply alpha dashboard highlights" })

-- ── Sections ─────────────────────────────────────────────────────────────

-- Top sky — sparse stars with depth variation
local sky_top = {
  type = "text",
  val = {
    "  ⋆  ·    ˚    ·   ✦       ·    ˚    ·    ⋆    ˚    ✦    ·    ⋆  ·   ",
    "       ✦     ·    ⋆    ˚    ·         ˚    ·    ⋆         ˚    ·     ",
    "  ·        ˚         ·    ✦    ·    ⋆    ·       ✦    ·        ˚     ",
  },
  opts = { hl = "AlphaStar", position = "center" },
}

-- NEOVIM ASCII logo
local header = {
  type = "text",
  val = {
    "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
    "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
    "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
    "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
    "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
    "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
  },
  opts = { hl = "AlphaHeader", position = "center" },
}

-- Language stack
local subtitle = {
  type = "text",
  val = { "Rust  ·  JavaScript  ·  PHP  ·  C++  ·  Kotlin  ·  Swift" },
  opts = { hl = "AlphaSubtitle", position = "center" },
}

-- Bottom sky — denser, different star pattern
local sky_bot = {
  type = "text",
  val = {
    "  ·    ⋆    ˚    ·    ✦    ·    ⋆    ˚    ·    ✦    ·    ˚    ⋆   ·  ",
    "       ˚    ·    ⋆         ✦    ·    ˚    ·    ⋆    ˚         ·     ",
    "  ✦    ·         ˚    ·       ⋆    ·    ˚         ·    ✦    ⋆    ˚  ",
  },
  opts = { hl = "AlphaStar", position = "center" },
}

-- Action buttons
local buttons = {
  type = "group",
  val = {
    dashboard.button("f", "  Find File",       ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent Files",    ":Telescope oldfiles<CR>"),
    dashboard.button("s", "  Live Grep",       ":Telescope live_grep<CR>"),
    dashboard.button("t", "  Browse TODOs",    ":TodoTelescope<CR>"),
    dashboard.button("e", "  New File",        ":enew<CR>"),
    dashboard.button("l", "  Lazy",            ":Lazy<CR>"),
    dashboard.button("q", "  Quit",            ":qa<CR>"),
  },
  opts = { spacing = 1 },
}

-- Footer: plugin count via lazy.nvim
local footer = {
  type = "text",
  val = function()
    local ok2, lazy = pcall(require, "lazy")
    if not ok2 then return { "" } end
    local s = lazy.stats()
    return { string.format("⚡ %d / %d plugins  ·  startup %.0f ms",
      s.loaded, s.count, s.startuptime or 0) }
  end,
  opts = { hl = "AlphaFooter", position = "center" },
}

local pad = function(n) return { type = "padding", val = n } end

-- ── Final layout ─────────────────────────────────────────────────────────
alpha.setup({
  layout = {
    pad(2),
    sky_top,
    pad(1),
    header,
    pad(1),
    subtitle,
    pad(1),
    sky_bot,
    pad(2),
    buttons,
    pad(2),
    footer,
  },
  opts = { margin = 5 },
})

-- Don't show alpha when opening nvim with file arguments or stdin
-- (alpha-nvim handles this automatically, but this makes it explicit)
vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function()
    -- Hide statusline on the dashboard for a cleaner look
    vim.opt_local.laststatus   = 0
    vim.opt_local.showtabline  = 0
  end,
})
vim.api.nvim_create_autocmd("BufUnload", {
  buffer = 0,
  callback = function()
    vim.opt.laststatus  = 2
    vim.opt.showtabline = 1
  end,
})
