-- plugins/crates.lua
-- crates.nvim: inline crate version info in Cargo.toml.
-- Shows latest/compatible/yanked version of each crate as virtual text,
-- provides popups for versions/features/dependencies, and can update crates.
-- Essential for Rust development and kernel module work.

local ok, crates = pcall(require, "crates")
if not ok then return end

crates.setup({
  lsp = {
    enabled    = true,   -- hover, completion, code actions via LSP protocol
    actions    = true,
    completion = true,
    hover      = true,
  },
  completion = {
    cmp = { enabled = true },  -- integrate with nvim-cmp
  },
  popup = { border = "rounded" },
})

-- Keymaps are buffer-local to Cargo.toml only (<leader>C prefix)
vim.api.nvim_create_autocmd("BufRead", {
  pattern  = "Cargo.toml",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, buffer = buf, desc = desc })
    end
    map("<leader>Ct", crates.toggle,                   "Crates: Toggle virtual text")
    map("<leader>Cr", crates.reload,                   "Crates: Reload")
    map("<leader>Cv", crates.show_versions_popup,      "Crates: Browse versions")
    map("<leader>Cf", crates.show_features_popup,      "Crates: Browse features")
    map("<leader>Cd", crates.show_dependencies_popup,  "Crates: Browse dependencies")
    map("<leader>Cu", crates.upgrade_crate,            "Crates: Upgrade to latest")
    map("<leader>CU", crates.upgrade_all_crates,       "Crates: Upgrade all to latest")
    map("<leader>Ca", crates.update_crate,             "Crates: Update (compat range)")
    map("<leader>CA", crates.update_all_crates,        "Crates: Update all (compat)")
    map("<leader>Cx", crates.expand_plain_crate_to_inline_table, "Crates: Expand to table")
    map("<leader>Co", crates.open_crates_io,           "Crates: Open crates.io")
    map("<leader>CH", crates.open_homepage,            "Crates: Open homepage")
    map("<leader>CR", crates.open_repository,          "Crates: Open repository")
  end,
  desc = "crates.nvim Cargo.toml keymaps",
})
