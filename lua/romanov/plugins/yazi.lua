-- plugins/yazi.lua
-- macOS: brew install yazi
-- Debian: download pre-built binary → /usr/local/bin/yazi
--   curl -Lo /tmp/y.tar.gz https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-musl.tar.gz
--   tar -xzf /tmp/y.tar.gz -C /tmp && sudo mv /tmp/yazi-*/yazi /usr/local/bin/

local ok, yazi = pcall(require, "yazi")
if not ok then return end

yazi.setup({
  open_for_directories            = false,
  floating_window_scaling_factor  = 0.90,
  keymaps = {
    show_help                            = "<f1>",
    open_file_in_vertical_split          = "<c-v>",
    open_file_in_horizontal_split        = "<c-s>",
    open_file_in_tab                     = "<c-t>",
    grep_in_directory                    = "<c-g>",
    replace_in_directory                 = "<c-r>",
    cycle_open_buffers                   = "<tab>",
    copy_relative_path_to_selected_files = "<c-y>",
    send_to_quickfix_list                = "<c-q>",
  },
})

vim.keymap.set("n", "<leader>yz", "<cmd>Yazi<CR>",
  { desc = "Yazi: Open at current file" })
vim.keymap.set("n", "<leader>yc", function()
  require("yazi").yazi(nil, vim.fn.getcwd())
end, { desc = "Yazi: Open at CWD" })
vim.keymap.set("n", "<leader>yf", "<cmd>Yazi toggle<CR>",
  { desc = "Yazi: Resume last session" })
