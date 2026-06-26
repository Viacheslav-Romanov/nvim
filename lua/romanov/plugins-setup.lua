-- plugins-setup.lua
-- Added: conform.nvim, nvim-lint, nvim-dap, rustaceanvim, yazi.nvim,
--        which-key.nvim, indent-blankline v3, nvim-treesitter-textobjects,
--        ts-context-commentstring, telescope-ui-select, todo-comments.
-- Removed: none-ls/null-ls (replaced by conform + nvim-lint).

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  { "nvim-lua/plenary.nvim",         lazy = true },
  { "nvim-tree/nvim-web-devicons",   lazy = true },
  { "bluz71/vim-nightfly-guicolors", priority = 1000, lazy = false },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function() require("romanov.plugins.which-key") end,
  },

  "christoomey/vim-tmux-navigator",
  "szw/vim-maximizer",
  "tpope/vim-surround",
  "inkarkat/vim-ReplaceWithRegister",

  -- Commenting (with JSX/PHP-aware comment strings)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function() require("romanov.plugins.comment") end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("romanov.plugins.nvim-tree") end,
  },

  -- Yazi floating file manager
  -- macOS: brew install yazi
  -- Debian: download pre-built binary from github.com/sxyazi/yazi/releases
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("romanov.plugins.yazi") end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function() require("romanov.plugins.lualine") end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("romanov.plugins.indent-blankline") end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond  = function() return vim.fn.executable("make") == 1 end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd = "Telescope",
    config = function() require("romanov.plugins.telescope") end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets", "onsails/lspkind.nvim",
    },
    config = function() require("romanov.plugins.nvim-cmp") end,
  },

  -- Mason: LSP + DAP installer
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function() require("romanov.plugins.lsp.mason") end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      {
        "glepnir/lspsaga.nvim",
        branch = "main",
        dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
      },
    },
    config = function()
      require("romanov.plugins.lsp.lspsaga")
      require("romanov.plugins.lsp.lspconfig")
    end,
  },

  -- Rust: rustaceanvim (manages rust-analyzer itself)
  -- init = sets vim.g.rustaceanvim BEFORE the plugin loads (required)
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft      = { "rust" },
    init    = function()
      vim.g.rustaceanvim = require("romanov.plugins.lsp.rust")
    end,
  },

  -- Format on save (replaces none-ls)
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("romanov.plugins.conform") end,
  },

  -- Async linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("romanov.plugins.lint") end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event  = { "BufReadPre", "BufNewFile" },
    build  = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function() require("romanov.plugins.treesitter") end,
  },

  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = function() require("romanov.plugins.autopairs") end,
  },

  -- Git
  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufReadPre", "BufNewFile" },
    config = function() require("romanov.plugins.gitsigns") end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd          = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    config       = function() require("romanov.plugins.lazygit") end,
  },

  -- Debugging (DAP)
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function() require("romanov.plugins.dap.dap") end,
  },

  -- Xcodebuild (Swift/macOS only)
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "MunifTanjim/nui.nvim" },
    ft     = { "swift", "objc", "objcpp" },
    config = function() require("romanov.plugins.xcodebuild") end,
  },

  { "github/copilot.vim", event = "InsertEnter" },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft           = { "markdown" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config       = function()
      require("render-markdown").setup({ render_modes = { "n", "v", "i", "c" } })
    end,
  },

  {
    "folke/todo-comments.nvim",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config       = function() require("todo-comments").setup() end,
  },

  -- ── Startup dashboard ────────────────────────────────────────────────────
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("romanov.plugins.alpha") end,
  },


}, {
  ui = { border = "rounded" },
  performance = {
    rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
})
