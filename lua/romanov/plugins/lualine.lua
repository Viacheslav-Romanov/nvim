local status, lualine = pcall(require, "lualine")
if not status then
  return
end

local lualine_nightfly = require("lualine.themes.nightfly")

local new_colors = {
  blue   = "#65D1FF",
  green  = "#3EFFDC",
  violet = "#FF61EF",
  yellow = "#FFDA7B",
  black  = "#000000",
}

lualine_nightfly.normal.a.bg  = new_colors.blue
lualine_nightfly.insert.a.bg  = new_colors.green
lualine_nightfly.visual.a.bg  = new_colors.violet
lualine_nightfly.command = {
  a = {
    gui = "bold",
    bg  = new_colors.yellow,
    fg  = new_colors.black,
  },
}

lualine.setup({
  options = {
    theme                = lualine_nightfly,
    globalstatus         = true, -- IMPROVED: single statusline across all splits (nvim ≥ 0.7)
    section_separators   = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  -- IMPROVED: surfaced useful sections that were missing from the original
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      { "branch", icon = "" },            -- git branch name
      { "diff",   symbols = { added = " ", modified = " ", removed = " " } },
    },
    lualine_c = {
      { "filename", path = 1 },           -- relative path (0 = just filename)
    },
    lualine_x = {
      {
        "diagnostics",
        sources  = { "nvim_diagnostic" },
        symbols  = { error = " ", warn  = " ", info  = " ", hint = " " },
      },
      "encoding",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})
