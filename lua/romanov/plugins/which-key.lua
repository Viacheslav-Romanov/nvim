-- plugins/which-key.lua — v3 API
-- v3 changes: "window" → "win",  wk.add() replaces wk.register()

local ok, wk = pcall(require, "which-key")
if not ok then return end

wk.setup({
  preset = "classic",
  delay  = 300,
  plugins = {
    marks = true, registers = true,
    spelling = { enabled = false },
    presets = {
      operators = true, motions = true, text_objects = true,
      windows = true, nav = true, z = true, g = true,
    },
  },
  win = {
    border  = "rounded",
    padding = { 1, 2, 1, 2 },
    wo      = { winblend = 0 },
  },
  layout  = { width = { min = 20, max = 50 }, spacing = 3, align = "left" },
  icons   = { breadcrumb = "»", separator = "➜", group = "+" },
  show_help = true,
  show_keys = true,
})

wk.add({
  { "<leader>f",  group = "Find (Telescope)" },
  { "<leader>g",  group = "Git" },
  { "<leader>h",  group = "Git Hunks" },
  { "<leader>d",  group = "Debug (DAP)" },
  { "<leader>r",  group = "Rust" },
  { "<leader>x",  group = "Xcode / Swift" },
  { "<leader>y",  group = "Yazi" },
  { "<leader>m",  group = "Format / Lint" },
  { "<leader>t",  group = "Toggles" },
  { "<leader>s",  group = "Splits" },
  { "<leader>b",  group = "Buffers" },
  { "<leader>c",  group = "Quickfix" },
  { "<leader>C",  group = "Crates (Cargo.toml)" },
  { "<leader>N",  group = "NPM (package.json)" },
  { "<leader>T",  group = "Trouble / Diagnostics" },
  { "<leader>n",  group = "Doc / Neogen" },
  { "<leader>dg", group = "Diagram (inline mermaid)" },
  { "<leader>mv", group = "Markdown Preview (browser)" },
  { "<leader>a",  desc  = "Harpoon: Add file" },
  { "<leader>l",  desc  = "Harpoon: Quick menu" },
  { "<leader>u",  desc  = "Undotree: Toggle" },
})
