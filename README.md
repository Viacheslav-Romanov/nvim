# Neovim Config Improvements

## Bug Fixes

### `init.lua` — plugin config loop errors

With lazy.nvim, each plugin's config file is invoked by lazy itself via its `config = function()` callback. The old `init.lua` also called `require("romanov.plugins.comment")` etc. explicitly, which ran those files before lazy had loaded the underlying plugins — causing the cascade of "loop or previous error" failures. Fixed by removing all explicit plugin requires from `init.lua`. It now only loads the three core modules + `plugins-setup` + colorscheme.

### `lsp/lspconfig.lua` — broken `require("ts_ls")` guard

`require("ts_ls")` doesn't exist as a standalone module. The `pcall` guard would silently fail at startup and return early, aborting the entire LSP setup. Fixed by configuring `ts_ls` via `lspconfig["ts_ls"].setup()` (and later via `vim.lsp.config`) like every other server.

### `lsp/lspconfig.lua` — broken `require("xcodebuild")` guard

`xcodebuild.nvim`'s setup was nested inside `lspconfig.lua` behind a pcall. Moved to `plugins-setup.lua` as a proper lazy plugin entry with `ft = { "swift", "objc", "objcpp" }`.

### `lsp/lspconfig.lua` — non-existent TypeScript commands

`:TypescriptRenameFile`, `:TypescriptOrganizeImports`, `:TypescriptRemoveUnused` belong to the `typescript.nvim` plugin, which is not in the plugin list. Replaced with the native LSP `_typescript.organizeImports` execute command.

### `core/options.lua` — `tabstop`/`shiftwidth` mismatch

`tabstop = 4` but `shiftwidth = 2` meant tab characters display at 4 spaces while indentation inserts 2. Both are now consistently `2`.

---

## API Migration

### `lsp/lspconfig.lua` — deprecated `require('lspconfig')` API

Migrated to `vim.lsp.config` / `vim.lsp.enable` (Neovim 0.11+). `nvim-lspconfig` v3 will remove the old `.setup()` wrapper. The new pattern:

```lua
vim.lsp.config("ts_ls", { capabilities = ..., on_attach = ... })
vim.lsp.enable("ts_ls")
```

`nvim-lspconfig` is still kept as a dependency for its default server definitions (root dir detection, filetypes, cmd paths).

---

## Plugin Manager — `packer.nvim` → `lazy.nvim`

`plugins-setup.lua` is fully rewritten to use **lazy.nvim**. `packer.nvim` has been archived and unmaintained since 2023.

Benefits:

- Automatic lazy-loading via `event`, `cmd`, and `ft` triggers — plugins load only when needed, reducing startup time
- `lazy-lock.json` lockfile for reproducible installs
- Better `:Lazy` UI with update/clean/profile commands
- Self-bootstrapping — no manual install step
- Active maintenance and wide community adoption

Lazy-load triggers added per plugin:
| Plugin | Trigger |
|---|---|
| Comment.nvim | `BufReadPre`, `BufNewFile` |
| lualine | `VeryLazy` |
| Telescope | `:Telescope` command |
| nvim-cmp | `InsertEnter` |
| Copilot | `InsertEnter` |
| nvim-lspconfig | `BufReadPre`, `BufNewFile` |
| none-ls | `BufReadPre`, `BufNewFile` |
| gitsigns | `BufReadPre`, `BufNewFile` |
| lazygit | `:LazyGit` command |
| xcodebuild | `swift`, `objc`, `objcpp` filetypes |
| render-markdown | `markdown` filetype |
| nvim-autopairs | `InsertEnter` |
| nvim-treesitter | `BufReadPre`, `BufNewFile` |

---

## New File — `core/autocommands.lua`

Centralises all autocommands. Previously autocommands were either missing or scattered inline via `vim.cmd([[...]])`.

| Autocommand                          | Effect                                                           |
| ------------------------------------ | ---------------------------------------------------------------- |
| `TextYankPost`                       | Briefly flashes the yanked region (yank highlight)               |
| `BufWritePre`                        | Trims trailing whitespace on save, restoring cursor position     |
| `BufReadPost`                        | Restores cursor to last known position when reopening a file     |
| `VimResized`                         | Re-equalises splits when the terminal window is resized          |
| `FileType` (help, man, qf, lspinfo…) | Closes auxiliary windows with `q`                                |
| `BufEnter`                           | Disables auto-comment continuation (`c`, `r`, `o` formatoptions) |

---

## `core/options.lua`

| Option                | Change                                                               |
| --------------------- | -------------------------------------------------------------------- |
| `smartindent = true`  | Smarter auto-indentation for code blocks                             |
| `wrap = false`        | Off by default (toggleable with `<leader>tw`); was `true`            |
| `hlsearch = false`    | No persistent match highlighting; use `<leader>nh` to clear manually |
| `incsearch = true`    | Show matches incrementally as you type                               |
| `colorcolumn = "120"` | Visual ruler at 120 characters                                       |
| `scrolloff = 8`       | Keep 8 lines above/below cursor when scrolling                       |
| `sidescrolloff = 8`   | Keep 8 columns visible when scrolling horizontally                   |
| `updatetime = 250`    | Faster `CursorHold` / LSP hover (was 4000 ms)                        |
| `timeoutlen = 500`    | Faster keymap chord timeout                                          |
| `swapfile = false`    | No swap files cluttering project directories                         |
| `backup = false`      | No backup files                                                      |
| `undofile = true`     | Persistent undo history across sessions                              |
| `undodir`             | Undo files stored in `stdpath("data")/undodir`, not the project      |
| `foldlevelstart = 99` | All folds start open                                                 |

---

## `core/keymaps.lua`

All mappings now have a `desc` field (visible in `:map` and which-key).

### New / changed general mappings

| Key                       | Mode | Action                                                            |
| ------------------------- | ---- | ----------------------------------------------------------------- |
| `j` / `k`                 | n    | Move through visual/wrapped lines (`gj`/`gk`) when no count given |
| `<leader>tw`              | n    | Toggle line wrap                                                  |
| `<` / `>`                 | v    | Indent/dedent and stay in visual mode                             |
| `J` / `K`                 | v    | Move selected lines down/up                                       |
| `<C-d>` / `<C-u>`         | n    | Scroll and keep cursor centred                                    |
| `n` / `N`                 | n    | Search results stay centred                                       |
| `<leader>p`               | x    | Paste over selection without overwriting the yank register        |
| `<leader>y` / `<leader>Y` | n/v  | Yank to system clipboard explicitly                               |
| `<leader>w`               | n    | Save file                                                         |
| `<leader>q` / `<leader>Q` | n    | Quit / force-quit all                                             |
| `<Tab>` / `<S-Tab>`       | n    | Next / previous buffer                                            |
| `<leader>bd`              | n    | Delete buffer                                                     |

### Tab keymaps (changed)

`<C-t>o/x/n/p` chords replaced with `<leader>to/tx/tn/tp` (more ergonomic). `<C-Tab>` / `<C-S-Tab>` also added for terminal users.

### New plugin mappings

| Key             | Action                           |
| --------------- | -------------------------------- |
| `<leader>ef`    | Reveal current file in nvim-tree |
| `<leader>fo`    | Telescope recent files           |
| `<leader>fk`    | Telescope search keymaps         |
| `<leader>cn/cp` | Quickfix next / prev             |
| `<leader>co/cc` | Open / close quickfix list       |

---

## `plugins/gitsigns.lua`

The original called `gitsigns.setup()` with no arguments — leaving all keymaps unbound and wasting most of the plugin's value. Added a full `on_attach`:

| Key                         | Action                                                      |
| --------------------------- | ----------------------------------------------------------- |
| `]h` / `[h`                 | Jump to next / previous hunk                                |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk (also works on visual selection)         |
| `<leader>hS` / `<leader>hR` | Stage / reset entire buffer                                 |
| `<leader>hu`                | Undo last stage                                             |
| `<leader>hp`                | Preview hunk inline                                         |
| `<leader>hb`                | Full blame for current line                                 |
| `<leader>hd` / `<leader>hD` | Diff file / diff against last commit                        |
| `<leader>tb` / `<leader>td` | Toggle line blame / toggle deleted lines                    |
| `ih`                        | Text object: inner hunk (works in operator and visual mode) |

Also added custom sign characters and `current_line_blame_opts.delay = 800`.

---

## `plugins/lualine.lua`

| Change                | Detail                                                      |
| --------------------- | ----------------------------------------------------------- |
| `globalstatus = true` | Single statusline across all splits (requires Neovim ≥ 0.7) |
| Git branch            | Added to `lualine_b` with `` icon                           |
| Git diff              | Added added/modified/removed counts                         |
| Diagnostics           | Added error/warn/info/hint counts from `nvim_diagnostic`    |
| Filename              | Shows relative path instead of bare filename                |
| Encoding              | Added to `lualine_x`                                        |
| Section separators    | Powerline-style `/`                                         |

---

## `plugins/nvim-cmp.lua`

| Change               | Detail                                                                                       |
| -------------------- | -------------------------------------------------------------------------------------------- |
| `completeopt`        | Added `noselect` — no item auto-selected                                                     |
| Bordered windows     | `completion` and `documentation` windows use rounded borders                                 |
| `<Tab>` / `<S-Tab>`  | Cycles completions in insert mode; jumps snippet placeholders in both insert and select mode |
| Source priority      | `nvim_lsp` 1000 → `luasnip` 750 → `buffer` 500 → `path` 250                                  |
| `lspkind` mode       | Changed from `symbol` to `symbol_text` — shows icon and text                                 |
| Source labels        | `[LSP]`, `[Snippet]`, `[Buffer]`, `[Path]` shown in menu                                     |
| Disabled in comments | Completion popup suppressed inside comment nodes                                             |

---

## `plugins/telescope.lua`

| Change                 | Detail                                                                         |
| ---------------------- | ------------------------------------------------------------------------------ |
| Prompt position        | Moved to top with `sorting_strategy = "ascending"`                             |
| Prompt prefix          | ` ` / ` ` icons                                                                |
| `file_ignore_patterns` | Ignores `node_modules`, `.git/`, `dist/`, `build/`, lockfiles, and image files |
| `<esc>` in insert mode | Closes telescope immediately (default requires two presses)                    |
| `<C-u>` / `<C-d>`      | Scroll the preview window                                                      |
| `q` in normal mode     | Closes telescope                                                               |
| `find_files`           | `hidden = true` — shows dotfiles                                               |

---

## `plugins/treesitter.lua`

| Change             | Detail                                                      |
| ------------------ | ----------------------------------------------------------- |
| Large file guard   | Disables highlighting for files > 500 KB to avoid slowdowns |
| `vimdoc` parser    | Replaces the old (renamed) `help` parser                    |
| `python` parser    | Added to match `pylsp` in lspconfig                         |
| `regex` parser     | Syntax-aware regex editing                                  |
| `query` parser     | For editing treesitter queries                              |
| Treesitter folding | `foldmethod = "expr"` with `nvim_treesitter#foldexpr()`     |

---

## `plugins/nvim-tree.lua`

| Change                                     | Detail                                                                    |
| ------------------------------------------ | ------------------------------------------------------------------------- |
| `highlight_git = true`                     | File names coloured by git status                                         |
| `indent_markers.enable = true`             | Indent guide lines in the tree                                            |
| `git.enable = true` / `git.ignore = false` | Git-ignored files shown (dimmed)                                          |
| `filters.custom = { "^.git$" }`            | Hides the `.git` directory itself                                         |
| `view.width = 35`                          | Slightly wider default                                                    |
| Removed `VimEnter` auto-open               | Tree no longer opens automatically on bare `nvim` launch; use `<leader>e` |

---

## `plugins/lsp/mason.lua`

| Change            | Detail                                             |
| ----------------- | -------------------------------------------------- |
| `pylsp` added     | Matches the `pylsp` server configured in lspconfig |
| Rounded UI border | `mason.setup({ ui = { border = "rounded" } })`     |
| Status icons      | ✓ installed · ➜ pending · ✗ uninstalled            |

---

## `plugins/lsp/lspsaga.lua`

| Change                     | Detail                                              |
| -------------------------- | --------------------------------------------------- |
| `ui.border = "rounded"`    | Consistent rounded borders                          |
| `lightbulb.enable = false` | Disables the floating lightbulb icon (can be noisy) |

---

## `plugins/lsp/null-ls.lua`

| Change                   | Detail                                                                                                                                                                   |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Broader eslint detection | Condition now checks for `.eslintrc.json`, `.eslintrc.cjs`, `eslint.config.js`, `.eslintrc.yaml`, `eslint.config.cjs`, `eslint.config.mjs` in addition to `.eslintrc.js` |
| `timeout_ms = 3000`      | Gives the formatter more time before giving up on save                                                                                                                   |
