-- autocommands.lua
-- Centralises all autocommands so they're easy to find and modify.

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ── Highlight on yank ──────────────────────────────────────────────────────
-- Briefly flashes the yanked region so you can confirm what was copied.
-- NEW: extremely useful quality-of-life feature.
local yank_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
  desc = "Highlight yanked text",
})

-- ── Trim trailing whitespace on save ──────────────────────────────────────
-- NEW: keeps diffs clean; avoids spurious whitespace-only changes.
local trim_group = augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = trim_group,
  pattern = "*",
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos) -- restore cursor position
  end,
  desc = "Trim trailing whitespace on save",
})

-- ── Restore cursor position ────────────────────────────────────────────────
-- NEW: jumps back to where you were when reopening a file.
local cursor_group = augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = cursor_group,
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Restore cursor position on file open",
})

-- ── Resize splits on terminal resize ──────────────────────────────────────
-- NEW: keeps splits proportional when you resize the terminal window.
local resize_group = augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = resize_group,
  pattern = "*",
  command = "tabdo wincmd =",
  desc = "Equalize splits on window resize",
})

-- ── Close certain windows with just 'q' ───────────────────────────────────
-- NEW: lets you dismiss help, man, quickfix, etc. by pressing q.
local close_group = augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = close_group,
  pattern = { "help", "man", "qf", "lspinfo", "checkhealth", "startuptime" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Close auxiliary windows with q",
})

-- ── Disable auto-comment on new line ──────────────────────────────────────
-- Neovim's default continues comment prefixes when pressing o/O or Enter.
-- NEW: most people find this annoying.
local comment_group = augroup("NoAutoComment", { clear = true })
autocmd("BufEnter", {
  group = comment_group,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable auto-comment continuation",
})
