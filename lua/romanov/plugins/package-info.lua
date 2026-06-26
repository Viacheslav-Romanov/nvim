-- plugins/package-info.lua
-- package-info.nvim: shows npm package versions as virtual text in package.json.
-- Identical concept to crates.nvim but for the JS ecosystem.

local ok, pkg = pcall(require, "package-info")
if not ok then return end

pkg.setup({
  colors = {
    up_to_date = "#3C4048",  -- dim — no action needed
    outdated   = "#d19a66",  -- orange — update available
  },
  icons = {
    enable = true,
    style  = { up_to_date = "  ", outdated = "  " },
  },
  autostart              = true,
  hide_up_to_date        = false,
  hide_unstable_versions = false,
  package_manager        = "npm",
})

-- Buffer-local keymaps (<leader>N prefix, only active in package.json)
vim.api.nvim_create_autocmd("BufRead", {
  pattern  = "package.json",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, buffer = buf, desc = desc })
    end
    map("<leader>Ns", pkg.show,           "NPM: Show versions")
    map("<leader>Nh", pkg.hide,           "NPM: Hide versions")
    map("<leader>Nu", pkg.update,         "NPM: Update package")
    map("<leader>Nd", pkg.delete,         "NPM: Delete package")
    map("<leader>Ni", pkg.install,        "NPM: Install new package")
    map("<leader>Np", pkg.change_version, "NPM: Change version")
  end,
  desc = "package-info.nvim keymaps",
})
