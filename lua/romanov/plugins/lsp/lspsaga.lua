local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
  return
end

saga.setup({
  scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
  definition = {
    edit = "<CR>",
  },
  ui = {
    colors = {
      normal_bg = "#022746",
    },
    border = "rounded",
  },
  lightbulb = {
    enable = false, -- disable the lightbulb floating icon (can be noisy)
  },
})
