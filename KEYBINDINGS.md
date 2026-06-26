# Neovim Keybindings

**Leader key: `Space`**  
Press `<leader>` (Space) and wait — **which-key** will show a popup with all available continuations.

---

## General

| Key | Mode | Action |
|-----|------|--------|
| `jk` | Insert | Exit insert mode |
| `<leader>nh` | Normal | Clear search highlights |
| `x` | Normal | Delete character (without yanking) |
| `<leader>+` | Normal | Increment number under cursor |
| `<leader>-` | Normal | Decrement number under cursor |
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Quit |
| `<leader>Q` | Normal | Force quit all |

---

## Editing

| Key | Mode | Action |
|-----|------|--------|
| `<` | Visual | Dedent selection (stays in visual) |
| `>` | Visual | Indent selection (stays in visual) |
| `J` | Visual | Move selection down |
| `K` | Visual | Move selection up |
| `<leader>p` | Visual | Paste without overwriting yank register |
| `<leader>y` | Normal/Visual | Yank to system clipboard |
| `<leader>Y` | Normal | Yank line to system clipboard |
| `<C-d>` | Normal | Scroll down (cursor stays centred) |
| `<C-u>` | Normal | Scroll up (cursor stays centred) |
| `n` / `N` | Normal | Next/prev search result (cursor centred) |

---

## Commenting

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc` | Visual | Toggle line comment on selection |
| `gb` | Visual | Toggle block comment on selection |
| `gcO` | Normal | Add comment above current line |
| `gco` | Normal | Add comment below current line |
| `gcA` | Normal | Add comment at end of line |

> Context-aware: `gcc` uses `{/* */}` inside JSX, `//` inside JS, `#` in PHP, etc.

---

## Windows / Splits

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sv` | Normal | Split vertical |
| `<leader>sh` | Normal | Split horizontal |
| `<leader>se` | Normal | Equalise split sizes |
| `<leader>sx` | Normal | Close current split |
| `<leader>sm` | Normal | Toggle maximise current split |
| `<C-h/j/k/l>` | Normal | Navigate between splits (vim-tmux-navigator) |

---

## Tabs

| Key | Mode | Action |
|-----|------|--------|
| `<leader>to` | Normal | New tab |
| `<leader>tx` | Normal | Close tab |
| `<leader>tn` | Normal | Next tab |
| `<leader>tp` | Normal | Prev tab |

---

## Buffers

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | Normal | Next buffer |
| `<S-Tab>` | Normal | Prev buffer |
| `<leader>bd` | Normal | Delete buffer |

---

## File Explorer (nvim-tree)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | Normal | Toggle file explorer |
| `<leader>ef` | Normal | Reveal current file in tree |

Inside nvim-tree: `a` new file · `d` delete · `r` rename · `c` copy · `p` paste · `R` refresh · `?` help

---

## Yazi (floating file manager)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>yz` | Normal | Open Yazi at current file's directory |
| `<leader>yc` | Normal | Open Yazi at project root (CWD) |
| `<leader>yf` | Normal | Resume last Yazi session |

Inside Yazi: `<C-v>` open in vertical split · `<C-s>` horizontal split · `<C-t>` new tab · `<C-g>` grep · `<C-q>` send to quickfix

---

## Fuzzy Search (Telescope)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fs` | Live grep (search file contents) |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | List open buffers |
| `<leader>fo` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fk` | Search keymaps |
| `<leader>fd` | Workspace diagnostics |
| `<leader>fr` | Resume last picker |
| `<leader>ft` | Search TODO / FIXME / NOTE comments |

Inside Telescope: `<C-k>/<C-j>` navigate · `<C-q>` send to quickfix · `<esc>` close

---

## LSP

These activate when an LSP attaches to a buffer (all languages).

| Key | Action |
|-----|--------|
| `gd` | Peek definition (float) |
| `gD` | Go to definition |
| `gi` | Go to implementation |
| `gr` | List references |
| `gt` | Go to type definition |
| `gf` | Find references (Lspsaga finder) |
| `K` | Hover documentation |
| `<C-s>` *(insert)* | Signature help |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>D` | Line diagnostics (float) |
| `<leader>d` | Cursor diagnostics (float) |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>o` | Toggle symbol outline |
| `<leader>rs` | Restart LSP |
| `<leader>oi` | Organise imports *(TypeScript only)* |

---

## Rust (rustaceanvim)

Active in `.rs` files only.

| Key | Action |
|-----|--------|
| `<leader>rr` | Show runnables (binaries, examples, tests) |
| `<leader>rt` | Show testables |
| `<leader>rd` | Show debuggables (launch in DAP) |
| `<leader>re` | Expand macro recursively |
| `<leader>rc` | Open Cargo.toml |
| `<leader>rp` | Go to parent module |
| `<leader>rk` | Move item up |
| `<leader>rj` | Move item down |
| `<leader>rh` | Hover actions |

---

## Debugging (DAP)

Works for Rust, C/C++, JavaScript/TypeScript, PHP, Kotlin.

| Key | Action |
|-----|--------|
| `<leader>dc` | **Start / Continue** |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint (prompts for expression) |
| `<leader>dl` | Log point (prints message, no pause) |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dq` | Terminate session |
| `<leader>dL` | Re-run last debug session |
| `<leader>du` | Toggle DAP UI panels |
| `<leader>de` | Evaluate expression under cursor |
| `<leader>dw` | Hover variable value |
| `<leader>dr` | Open REPL |
| `<leader>dx` | Clear all breakpoints |

> **PHP**: requires Xdebug extension. Set `XDEBUG_TRIGGER=1` or use browser extension.  
> **Rust**: use `<leader>rd` (debuggables) instead of `<leader>dc` for the first launch.

---

## Git — Gitsigns (per-buffer hunk operations)

| Key | Mode | Action |
|-----|------|--------|
| `]h` | Normal | Next hunk |
| `[h` | Normal | Prev hunk |
| `<leader>hs` | Normal/Visual | Stage hunk / selected lines |
| `<leader>hr` | Normal/Visual | Reset hunk / selected lines |
| `<leader>hS` | Normal | Stage entire buffer |
| `<leader>hR` | Normal | Reset entire buffer |
| `<leader>hu` | Normal | Undo last stage |
| `<leader>hp` | Normal | Preview hunk (floating diff) |
| `<leader>hb` | Normal | Blame line (full commit info) |
| `<leader>hd` | Normal | Diff this file |
| `<leader>hD` | Normal | Diff against last commit |
| `<leader>tb` | Normal | Toggle inline blame |
| `<leader>td` | Normal | Toggle deleted lines |
| `ih` | Operator/Visual | Text object: inner hunk |

## Git — Telescope + LazyGit

| Key | Action |
|-----|--------|
| `<leader>gg` | Open LazyGit (full TUI) |
| `<leader>gc` | Browse git commits |
| `<leader>gfc` | Browse commits for current file |
| `<leader>gb` | Browse and checkout branches |
| `<leader>gs` | Git status picker |

---

## Formatting & Linting (conform / nvim-lint)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mp` | Normal/Visual | Format file or selection |
| `<leader>tf` | Normal | Toggle format-on-save on/off |
| `<leader>ml` | Normal | Run linter manually |

Format-on-save is **on** by default. Formatters used per language:

| Language | Formatter | Linter |
|----------|-----------|--------|
| JS / TS / JSX | prettierd → prettier | eslint_d |
| PHP | php-cs-fixer | phpstan |
| Rust | rustfmt | — |
| C / C++ | clang-format | cppcheck |
| Kotlin | ktfmt | ktlint |
| Swift | swiftformat | — |
| Lua | stylua | — |
| Shell | shfmt | shellcheck |

---

## Treesitter Text Objects

These work across all supported languages (functions, classes, arguments…).

### Select (visual mode)

| Key | Selects |
|-----|---------|
| `af` / `if` | Around / inside **function** |
| `ac` / `ic` | Around / inside **class** |
| `aa` / `ia` | Around / inside **argument** |
| `al` / `il` | Around / inside **loop** |
| `ai` / `ii` | Around / inside **conditional** |

### Navigate

| Key | Goes to |
|-----|---------|
| `]f` / `[f` | Next / prev function start |
| `]F` / `[F` | Next / prev function end |
| `]c` / `[c` | Next / prev class start |
| `]a` / `[a` | Next / prev argument |

### Swap

| Key | Action |
|-----|--------|
| `<leader>na` | Swap argument with next |
| `<leader>pa` | Swap argument with prev |

---

## Quickfix

| Key | Action |
|-----|--------|
| `<leader>co` | Open quickfix list |
| `<leader>cc` | Close quickfix list |
| `<leader>cn` | Next item |
| `<leader>cp` | Prev item |

---

## Xcode / Swift *(macOS only)*

Active in `.swift` / `.m` / `.mm` files.

| Key | Action |
|-----|--------|
| `<leader>X` | Open all Xcode actions picker |
| `<leader>xb` | Build |
| `<leader>xr` | Build and run |
| `<leader>xt` | Run tests |
| `<leader>xT` | Run tests for current class |
| `<leader>xl` | Toggle build logs |
| `<leader>xd` | Select target device |
| `<leader>xp` | Select test plan |
| `<leader>xc` | Toggle code coverage |

---

## Tips

- **Forgot a keymap?** Press `<leader>` and wait — which-key shows all options grouped by prefix.
- **Search all keymaps**: `<leader>fk` opens the Telescope keymaps picker.
- **Search TODOs**: `<leader>ft` finds all `TODO`, `FIXME`, `NOTE`, `HACK` comments in the project.
- **Remote servers**: yazi, LazyGit, and all LSP/DAP tools work over SSH. Only `sourcekit` (Swift) and `xcodebuild` are macOS-only — they simply don't load on Debian.
