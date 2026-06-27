-- plugins/indent-blankline.lua — ibl v3 with scope highlighting
local ok, ibl = pcall(require, "ibl")
if not ok then return end

local hooks = require("ibl.hooks")
local hl = { "IblInd1","IblInd2","IblInd3","IblInd4","IblInd5","IblInd6" }

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  vim.api.nvim_set_hl(0, "IblInd1", { fg = "#2d3550" })
  vim.api.nvim_set_hl(0, "IblInd2", { fg = "#2d4035" })
  vim.api.nvim_set_hl(0, "IblInd3", { fg = "#3d3025" })
  vim.api.nvim_set_hl(0, "IblInd4", { fg = "#352d45" })
  vim.api.nvim_set_hl(0, "IblInd5", { fg = "#253540" })
  vim.api.nvim_set_hl(0, "IblInd6", { fg = "#303540" })
end)

ibl.setup({
  indent = { char = "│", tab_char = "│", highlight = hl },
  scope  = { enabled = true, highlight = hl, show_start = true, show_end = false },
  exclude = {
    filetypes = {
      "help", "alpha", "dashboard", "lazy", "mason",
      "NvimTree", "toggleterm", "TelescopePrompt",
    },
  },
})
