-- core/keymaps.lua
-- Plugin-specific keymaps live in their own files:
--   DAP → dap/dap.lua  |  Yazi → yazi.lua  |  Format → conform.lua
--   Lint → lint.lua    |  Gitsigns → gitsigns.lua  |  LSP → lspconfig.lua

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "x", '"_x', { desc = "Delete char (no yank)" })
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Respect visual lines when wrap is on
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

keymap.set("n", "<leader>tw", ":set wrap!<CR>", { desc = "Toggle line wrap" })

-- Indent and stay in visual mode
keymap.set("v", "<", "<gv", { desc = "Dedent selection" })
keymap.set("v", ">", ">gv", { desc = "Indent selection" })

-- Move selected lines
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centred
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n",     "nzzzv")
keymap.set("n", "N",     "Nzzzv")

-- Paste without losing register
keymap.set("x", "<leader>p", '"_dP', { desc = "Paste (keep register)" })

-- Clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
keymap.set("n",           "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })

-- Save / quit
keymap.set("n", "<leader>w",  ":w<CR>",   { desc = "Save" })
keymap.set("n", "<leader>q",  ":q<CR>",   { desc = "Quit" })
keymap.set("n", "<leader>Q",  ":qa!<CR>", { desc = "Force quit all" })

-- Splits
keymap.set("n", "<leader>sv", "<C-w>v",     { desc = "Split vertical" })
keymap.set("n", "<leader>sh", "<C-w>s",     { desc = "Split horizontal" })
keymap.set("n", "<leader>se", "<C-w>=",     { desc = "Equalise splits" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close split" })
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "Toggle maximise" })

-- Tabs
keymap.set("n", "<leader>to", ":tabnew<CR>",   { desc = "New tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>",     { desc = "Next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>",     { desc = "Prev tab" })

-- Buffers
keymap.set("n", "<Tab>",      ":bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>",    ":bprev<CR>", { desc = "Prev buffer" })
keymap.set("n", "<leader>bd", ":bd<CR>",    { desc = "Delete buffer" })

-- File explorer
keymap.set("n", "<leader>e",  ":NvimTreeToggle<CR>",   { desc = "Toggle file tree" })
keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", { desc = "Find file in tree" })

-- Telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>",  { desc = "Find files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>",   { desc = "Live grep" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep word" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>",     { desc = "Buffers" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>",   { desc = "Help tags" })
keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>",    { desc = "Recent files" })
keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>",     { desc = "Keymaps" })
keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })
keymap.set("n", "<leader>fr", "<cmd>Telescope resume<cr>",      { desc = "Resume picker" })
keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>",         { desc = "Search TODOs" })

-- Telescope git
keymap.set("n", "<leader>gc",  "<cmd>Telescope git_commits<cr>",  { desc = "Git commits" })
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", { desc = "File commits" })
keymap.set("n", "<leader>gb",  "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
keymap.set("n", "<leader>gs",  "<cmd>Telescope git_status<cr>",   { desc = "Git status" })

-- Git
keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })

-- LSP misc
keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })

-- Quickfix
keymap.set("n", "<leader>cn", ":cnext<CR>zz",  { desc = "Quickfix next" })
keymap.set("n", "<leader>cp", ":cprev<CR>zz",  { desc = "Quickfix prev" })
keymap.set("n", "<leader>co", ":copen<CR>",    { desc = "Open quickfix" })
keymap.set("n", "<leader>cc", ":cclose<CR>",   { desc = "Close quickfix" })
