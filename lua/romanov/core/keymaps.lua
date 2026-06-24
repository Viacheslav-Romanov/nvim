-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

---------------------
-- General Keymaps
---------------------

-- Use jk to exit insert mode (faster than Escape)
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Delete single character without copying into register
keymap.set("n", "x", '"_x', { desc = "Delete char without yanking" })

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Better up/down movement (respects wrapped lines)
-- IMPROVED: use gj/gk so j/k move through visual lines, not file lines
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move down (respects wrap)" })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move up (respects wrap)" })

-- Toggle line wrap
keymap.set("n", "<leader>tw", ":set wrap!<CR>", { desc = "Toggle line wrap" })

-- Stay in visual mode after indenting
keymap.set("v", "<", "<gv", { desc = "Dedent and reselect" })
keymap.set("v", ">", ">gv", { desc = "Indent and reselect" })

-- Move selected lines up/down in visual mode
-- NEW: very useful for reordering code blocks
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling / searching
-- NEW: prevents losing context while jumping around
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Paste over selection without losing yanked text
-- NEW: prevents the common frustration of losing your yank after a paste-over
keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over selection (keep register)" })

-- Yank to system clipboard explicitly (complement to unnamedplus)
keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })

-- Quick save and quit
keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap.set("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- IMPROVED: simpler tab keybinds (Ctrl-t chords are awkward)
keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Previous tab" })
-- Also keep Ctrl+Tab / Ctrl+Shift+Tab for tab switching (works in most terminals)
keymap.set("n", "<C-Tab>", ":tabn<CR>", { desc = "Next tab" })
keymap.set("n", "<C-S-Tab>", ":tabp<CR>", { desc = "Previous tab" })

-- Buffer navigation
-- NEW: quick buffer switching without needing telescope
keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-Tab>", ":bprev<CR>", { desc = "Previous buffer" })
keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "Toggle window maximization" })

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
keymap.set("n", "<leader>ef", ":NvimTreeFindFile<CR>", { desc = "Find current file in tree" }) -- NEW

-- Telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep word under cursor" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List open buffers" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Search help tags" })
keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" }) -- NEW
keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Search keymaps" }) -- NEW

-- Telescope git commands
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>", { desc = "Git file commits" })
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })

-- LSP
keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP" })

-- Lazygit
keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })

-- Quickfix list navigation
-- NEW: useful after Telescope send-to-qflist or LSP references
keymap.set("n", "<leader>cn", ":cnext<CR>zz", { desc = "Quickfix next" })
keymap.set("n", "<leader>cp", ":cprev<CR>zz", { desc = "Quickfix prev" })
keymap.set("n", "<leader>co", ":copen<CR>", { desc = "Open quickfix" })
keymap.set("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix" })
