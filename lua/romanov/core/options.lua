local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
-- FIX: tabstop and shiftwidth were inconsistent (4 vs 2). Both set to 2 for Lua/TS/JS work.
-- Change both to 4 if you prefer 4-space indentation.
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true -- NEW: smarter auto-indentation for code

-- Line wrapping
opt.wrap = false -- CHANGED: off by default; long lines indicate code smell. Toggle with <leader>tw.

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false -- NEW: don't highlight all matches persistently (use <leader>nh anyway)
opt.incsearch = true -- NEW: show matches as you type

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.colorcolumn = "120" -- NEW: visual ruler at 120 chars
opt.scrolloff = 8 -- NEW: keep 8 lines above/below cursor when scrolling
opt.sidescrolloff = 8 -- NEW: keep 8 cols left/right when scrolling horizontally

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Keyword characters
opt.iskeyword:append("-")

-- Performance
opt.updatetime = 250 -- NEW: faster CursorHold events (default 4000ms is too slow for LSP)
opt.timeoutlen = 500 -- NEW: faster which-key / keymap timeout

-- Files & undo
opt.swapfile = false -- NEW: no swap files cluttering your project
opt.backup = false -- NEW: no backup files
opt.undofile = true -- NEW: persistent undo across sessions (stored in undodir)
opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- NEW: store undo history outside project

-- Completion
opt.completeopt = "menu,menuone,preview" -- already in nvim-cmp but good to be explicit here too

-- Folds (treesitter-powered when treesitter loads)
opt.foldmethod = "indent" -- sensible default; treesitter.lua overrides to "expr"
opt.foldlevelstart = 99 -- NEW: start with all folds open

-- Transparency for floating windows and popup menus.
-- The terminal background image / colour shows through at this opacity level.
-- 0 = fully opaque, 100 = invisible.  10-15 is subtle but visible.
opt.winblend = 10   -- floating windows (LSP hover, diagnostics, etc.)
opt.pumblend = 10   -- popup completion menu
