-- plugins-setup.lua
-- IMPROVED: Migrated from packer.nvim → lazy.nvim.
--
-- Why? packer.nvim is archived / unmaintained (last commit 2023).
-- lazy.nvim is the community standard: faster startup via automatic lazy-loading,
-- better UI, lockfile for reproducibility, and active maintenance.
--
-- Installation: lazy.nvim bootstraps itself on first launch — no manual steps.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- ── Utilities ─────────────────────────────────────────────────────────
	{ "nvim-lua/plenary.nvim", lazy = true }, -- lua helpers used by many plugins

	-- ── Colorscheme ───────────────────────────────────────────────────────
	{
		"bluz71/vim-nightfly-guicolors",
		priority = 1000, -- load before everything else
		lazy = false,
	},

	-- ── Navigation ────────────────────────────────────────────────────────
	"christoomey/vim-tmux-navigator", -- seamless tmux/neovim pane navigation
	"szw/vim-maximizer", -- maximise / restore current split

	-- ── Editing helpers ───────────────────────────────────────────────────
	"tpope/vim-surround", -- cs, ds, ys motions for surrounding chars
	"inkarkat/vim-ReplaceWithRegister", -- gr + motion to replace with register

	-- ── Commenting ────────────────────────────────────────────────────────
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" }, -- lazy-load: only when a buffer opens
		config = function()
			require("romanov.plugins.comment")
		end,
	},

	-- ── File explorer ─────────────────────────────────────────────────────
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("romanov.plugins.nvim-tree")
		end,
	},

	-- ── Statusline ────────────────────────────────────────────────────────
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("romanov.plugins.lualine")
		end,
	},

	-- ── Telescope ─────────────────────────────────────────────────────────
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		cmd = "Telescope", -- lazy-load: only on :Telescope command
		config = function()
			require("romanov.plugins.telescope")
		end,
	},

	-- ── Autocompletion ────────────────────────────────────────────────────
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- lazy-load: only when entering insert mode
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
		},
		config = function()
			require("romanov.plugins.nvim-cmp")
		end,
	},

	-- ── LSP ───────────────────────────────────────────────────────────────
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"jayp0521/mason-null-ls.nvim",
		},
		config = function()
			require("romanov.plugins.lsp.mason")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{
				"glepnir/lspsaga.nvim",
				branch = "main",
				dependencies = {
					"nvim-tree/nvim-web-devicons",
					"nvim-treesitter/nvim-treesitter",
				},
			},
		},
		config = function()
			require("romanov.plugins.lsp.lspsaga")
			require("romanov.plugins.lsp.lspconfig")
		end,
	},

	-- ── Formatting / Linting ──────────────────────────────────────────────
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("romanov.plugins.lsp.null-ls")
		end,
	},

	-- ── Treesitter ────────────────────────────────────────────────────────
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag", -- auto-close HTML/JSX tags
		},
		config = function()
			require("romanov.plugins.treesitter")
		end,
	},

	-- ── Autopairs ─────────────────────────────────────────────────────────
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("romanov.plugins.autopairs")
		end,
	},

	-- ── Git ───────────────────────────────────────────────────────────────
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("romanov.plugins.gitsigns")
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- ── Xcodebuild ────────────────────────────────────────────────────────
	{
		"wojciech-kulik/xcodebuild.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
		},
		ft = { "swift", "objc", "objcpp" }, -- lazy-load: only for Apple-platform files
	},

	-- ── Copilot ───────────────────────────────────────────────────────────
	{
		"github/copilot.vim",
		event = "InsertEnter",
	},

	-- ── Markdown rendering ────────────────────────────────────────────────
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" }, -- lazy-load: only for markdown files
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("render-markdown").setup({
				render_modes = { "n", "v", "i", "c" },
			})
		end,
	},
}, {
	-- lazy.nvim options
	ui = {
		border = "rounded",
	},
	performance = {
		rtp = {
			-- Disable built-in plugins you don't use to shave startup time
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
