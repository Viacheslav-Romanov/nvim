-- plugins/telescope.lua
local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then return end

local actions_ok, actions = pcall(require, "telescope.actions")
if not actions_ok then return end

telescope.setup({
  defaults = {
    layout_config    = { prompt_position = "top", horizontal = { preview_width = 0.55 } },
    sorting_strategy = "ascending",
    prompt_prefix    = " ",
    selection_caret  = " ",
    file_ignore_patterns = {
      "node_modules", ".git/", "dist/", "build/",
      "%.lock", "%.png", "%.jpg", "%.jpeg", "%.gif", "%.svg", "%.ico",
    },
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<esc>"] = actions.close,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
      },
      n = { ["q"] = actions.close },
    },
  },
  pickers = { find_files = { hidden = true } },
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown() },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
pcall(telescope.load_extension, "lazygit")
