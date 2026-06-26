-- plugins/trouble.lua  (trouble.nvim v3)
-- Beautiful project-wide diagnostics panel. Replaces the quickfix list for
-- LSP errors, shows all warnings across the project, integrates with
-- todo-comments and telescope. Invaluable for large Rust / kernel projects.

local ok, trouble = pcall(require, "trouble")
if not ok then return end

trouble.setup({
  auto_close      = true,  -- close panel when it becomes empty
  auto_preview    = true,  -- preview item under cursor
  use_diagnostic_signs = true,
  modes = {
    diagnostics = {
      auto_close = true,
    },
    -- A custom mode that groups diagnostics by file then severity
    project_errors = {
      mode = "diagnostics",
      filter = { severity = vim.diagnostic.severity.ERROR },
    },
  },
})

local km = vim.keymap.set
-- <leader>T prefix ("Trouble / diagnostics")
km("n", "<leader>Td", "<cmd>Trouble diagnostics toggle<cr>",
  { desc = "Trouble: Workspace diagnostics" })
km("n", "<leader>Tb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "Trouble: Buffer diagnostics" })
km("n", "<leader>Ts", "<cmd>Trouble symbols toggle<cr>",
  { desc = "Trouble: Document symbols" })
km("n", "<leader>Tr", "<cmd>Trouble lsp_references toggle<cr>",
  { desc = "Trouble: LSP references" })
km("n", "<leader>Tq", "<cmd>Trouble qflist toggle<cr>",
  { desc = "Trouble: Quickfix list" })
km("n", "<leader>Tl", "<cmd>Trouble loclist toggle<cr>",
  { desc = "Trouble: Location list" })
km("n", "<leader>TE", "<cmd>Trouble project_errors toggle<cr>",
  { desc = "Trouble: Errors only" })
-- Jump between trouble items without opening the panel
km("n", "]t", function() trouble.next({ skip_groups = true, jump = true }) end,
  { desc = "Trouble: Next item" })
km("n", "[t", function() trouble.prev({ skip_groups = true, jump = true }) end,
  { desc = "Trouble: Prev item" })
