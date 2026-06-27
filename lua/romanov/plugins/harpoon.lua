-- plugins/harpoon.lua  (harpoon v2)
-- ThePrimeagen's harpoon: bookmark up to 4 "hot" files per project and jump
-- between them instantly without telescope or file search.
-- Perfect for kernel work where you constantly switch between a handful of
-- related files (e.g. driver.rs, Makefile, include/header.h, tests/).

local ok, harpoon = pcall(require, "harpoon")
if not ok then return end

harpoon:setup({
  settings = {
    save_on_toggle    = true,   -- persist list when closing the menu
    sync_on_ui_close  = true,
    key               = function()
      -- Use the git root as the project key so each repo has its own list
      local root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
      return root ~= "" and root or vim.fn.getcwd()
    end,
  },
})

local km = vim.keymap.set

-- Add current file to harpoon list
km("n", "<leader>a",  function() harpoon:list():add() end,
  { desc = "Harpoon: Add file" })

-- Open the harpoon quick-menu (edit the list, pick a file)
km("n", "<leader>l",  function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
  { desc = "Harpoon: Quick menu" })

-- Jump directly to slots 1-4 with Alt+number (fast, no menu needed)
km("n", "<M-1>", function() harpoon:list():select(1) end, { desc = "Harpoon: File 1" })
km("n", "<M-2>", function() harpoon:list():select(2) end, { desc = "Harpoon: File 2" })
km("n", "<M-3>", function() harpoon:list():select(3) end, { desc = "Harpoon: File 3" })
km("n", "<M-4>", function() harpoon:list():select(4) end, { desc = "Harpoon: File 4" })

-- Cycle forward / backward through the list
km("n", "<M-p>", function() harpoon:list():prev() end, { desc = "Harpoon: Prev" })
km("n", "<M-n>", function() harpoon:list():next() end, { desc = "Harpoon: Next" })
