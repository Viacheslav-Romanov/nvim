local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

telescope.setup({
	defaults = {
		-- IMPROVED: prompt at the top (feels more natural)
		layout_config = {
			prompt_position = "top",
			horizontal = {
				preview_width = 0.55,
			},
		},
		sorting_strategy = "ascending",
		-- IMPROVED: nicer prompt prefix
		prompt_prefix = " ",
		selection_caret = " ",
		-- IMPROVED: ignore common noise dirs in file search
		file_ignore_patterns = {
			"node_modules",
			".git/",
			"dist/",
			"build/",
			"%.lock",
			"%.png",
			"%.jpg",
			"%.jpeg",
			"%.gif",
			"%.svg",
			"%.ico",
		},
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous,
				["<C-j>"] = actions.move_selection_next,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				-- ADDED: close telescope with ESC in insert mode (default requires two presses)
				["<esc>"] = actions.close,
				-- ADDED: scroll the preview window
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,
			},
			n = {
				["q"] = actions.close,
			},
		},
	},
	pickers = {
		-- IMPROVED: show hidden files in find_files
		find_files = {
			hidden = true,
		},
	},
})

telescope.load_extension("fzf")

-- lazygit extension (only load if lazygit.nvim is installed)
local lazygit_ok = pcall(telescope.load_extension, "lazygit")
if not lazygit_ok then
	-- silently skip; lazygit extension is optional
end
