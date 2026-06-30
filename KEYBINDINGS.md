# Neovim Keybindings

**Leader key: `<Space>`**

Press `<leader>` and wait — **which-key** pops up with all available continuations grouped by prefix.  
Search all keymaps live: `<leader>fk` → Telescope keymaps picker.

---

## General / Editing

| Key | Mode | Action |
|-----|------|--------|
| `jk` | Insert | Exit insert mode |
| `<leader>nh` | Normal | Clear search highlights |
| `x` | Normal | Delete character (no yank) |
| `<leader>+` | Normal | Increment number under cursor |
| `<leader>-` | Normal | Decrement number under cursor |
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Quit |
| `<leader>Q` | Normal | Force quit all |
| `j` / `k` | Normal | Move by visual line (respects `wrap`) |
| `<C-d>` / `<C-u>` | Normal | Scroll down/up (cursor stays centred) |
| `n` / `N` | Normal | Next/prev search result (centred) |
| `<leader>tw` | Normal | Toggle line wrap |
| `<` / `>` | Visual | Dedent / indent selection (stays in visual) |
| `J` / `K` | Visual | Move selection down / up |
| `<leader>p` | Visual | Paste without overwriting yank register |
| `<leader>y` | Normal/Visual | Yank to system clipboard |
| `<leader>Y` | Normal | Yank line to system clipboard |

---

## Commenting

Context-aware: `{/* */}` in JSX, `//` in JS/TS/Rust, `#` in PHP, `--` in Lua, `/* */` in C.

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc` | Visual | Toggle line comment on selection |
| `gb` | Visual | Toggle block comment on selection |
| `gcO` | Normal | Add comment line above |
| `gco` | Normal | Add comment line below |
| `gcA` | Normal | Add comment at end of line |

---

## Windows / Splits

| Key | Action |
|-----|--------|
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Equalise split sizes |
| `<leader>sx` | Close current split |
| `<leader>sm` | Toggle maximise current split |
| `<C-h/j/k/l>` | Navigate between splits (tmux-aware) |

---

## Tabs

| Key | Action |
|-----|--------|
| `<leader>to` | New tab |
| `<leader>tx` | Close tab |
| `<leader>tn` | Next tab |
| `<leader>tp` | Prev tab |

---

## Buffers

| Key | Action |
|-----|--------|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Prev buffer |
| `<leader>bd` | Delete buffer |

---

## File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file tree |
| `<leader>ef` | Reveal current file in tree |

**Inside nvim-tree:** `a` new · `d` delete · `r` rename · `c` copy · `p` paste · `R` refresh · `?` help

---

## Yazi (floating file manager)

| Key | Action |
|-----|--------|
| `<leader>yz` | Open Yazi at current file's directory |
| `<leader>yc` | Open Yazi at project CWD |
| `<leader>yf` | Resume last Yazi session |

**Inside Yazi:** `<C-v>` vertical split · `<C-s>` horizontal split · `<C-t>` new tab · `<C-g>` grep · `<C-q>` send to quickfix

---

## Harpoon (file bookmarks)

Mark up to 4 hot files per project. Git-root-aware — each repo has its own list.

| Key | Action |
|-----|--------|
| `<leader>a` | Add current file to harpoon list |
| `<leader>l` | Open harpoon quick-menu (reorder / remove) |
| `<M-1>` | Jump to slot 1 |
| `<M-2>` | Jump to slot 2 |
| `<M-3>` | Jump to slot 3 |
| `<M-4>` | Jump to slot 4 |
| `<M-p>` | Cycle to previous harpoon file |
| `<M-n>` | Cycle to next harpoon file |

---

## Telescope (fuzzy search)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fs` | Live grep (search file contents) |
| `<leader>fc` | Grep word under cursor |
| `<leader>fb` | List open buffers |
| `<leader>fo` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fk` | Search all keymaps |
| `<leader>fd` | Workspace diagnostics |
| `<leader>fr` | Resume last picker |
| `<leader>ft` | Search TODO / FIXME / NOTE / HACK comments |

**Inside Telescope:** `<C-k>`/`<C-j>` navigate · `<C-q>` send to quickfix · `<Esc>` close

---

## LSP (active in every language buffer)

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
| `<leader>rn` | Rename symbol (live preview — inc-rename) |
| `<leader>D` | Line diagnostics (float) |
| `<leader>d` | Cursor diagnostics (float) |
| `[d` / `]d` | Prev / next diagnostic |
| `<leader>o` | Toggle symbol outline |
| `<leader>rs` | Restart LSP |
| `<leader>oi` | Organise imports *(TypeScript only)* |

---

## Rename — inc-rename

`<leader>rn` pre-fills `:IncRename <word>` in the command line. Every occurrence in the buffer updates in real-time as you type the new name. Press `<Enter>` to confirm, `<Esc>` to cancel.

---

## Rust (rustaceanvim)

Active in `.rs` files only. Standard LSP keymaps (`gd`, `K`, etc.) also work.

| Key | Action |
|-----|--------|
| `<leader>rr` | Show runnables (binaries, examples, tests) |
| `<leader>rt` | Show testables |
| `<leader>rd` | Show debuggables → launch in DAP |
| `<leader>re` | Expand macro recursively |
| `<leader>rc` | Open Cargo.toml |
| `<leader>rp` | Go to parent module |
| `<leader>rk` | Move item up |
| `<leader>rj` | Move item down |
| `<leader>rh` | Hover actions |

---

## Cargo.toml — crates.nvim

Active only when `Cargo.toml` is open. Shows inline version indicators.

| Key | Action |
|-----|--------|
| `<leader>Ct` | Toggle version virtual text |
| `<leader>Cr` | Reload crate info |
| `<leader>Cv` | Browse all versions (popup) |
| `<leader>Cf` | Browse feature flags (popup) |
| `<leader>Cd` | Browse dependencies (popup) |
| `<leader>Cu` | Upgrade crate to latest |
| `<leader>CU` | Upgrade all crates to latest |
| `<leader>Ca` | Update crate (stay in semver range) |
| `<leader>CA` | Update all crates (semver range) |
| `<leader>Cx` | Expand plain crate to inline table |
| `<leader>Co` | Open crates.io in browser |
| `<leader>CH` | Open crate homepage |
| `<leader>CR` | Open crate repository |

---

## package.json — package-info.nvim

Active only when `package.json` is open. Shows inline npm version indicators.

| Key | Action |
|-----|--------|
| `<leader>Ns` | Show version info |
| `<leader>Nh` | Hide version info |
| `<leader>Nu` | Update package under cursor |
| `<leader>Nd` | Delete package under cursor |
| `<leader>Ni` | Install new package |
| `<leader>Np` | Change package version |

---

## Debugging (DAP)

Works for Rust, C/C++ (codelldb), JavaScript/TypeScript (js-debug-adapter), PHP (xdebug), Kotlin.

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

> **Rust:** use `<leader>rd` (debuggables picker) for first launch — rustaceanvim builds with debug symbols.  
> **PHP:** requires Xdebug extension. Set `XDEBUG_TRIGGER=1` or use a browser extension.

---

## Git — Gitsigns (hunk operations)

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
| `<leader>td` | Normal | Toggle show deleted lines |
| `ih` | Operator/Visual | Text object: inner hunk |

---

## Git — LazyGit + Telescope

| Key | Action |
|-----|--------|
| `<leader>gg` | Open LazyGit (full TUI) |
| `<leader>gc` | Browse git commits (Telescope) |
| `<leader>gfc` | Browse commits for current file (Telescope) |
| `<leader>gb` | Browse and checkout branches (Telescope) |
| `<leader>gs` | Git status picker (Telescope) |

---

## Git — Diffview

| Key | Action |
|-----|--------|
| `<leader>gd` | Open diffview (staged + unstaged changes) |
| `<leader>gH` | Full project commit history |
| `<leader>gh` | Current file commit history |
| `<leader>gM` | Diff against last commit (HEAD~1) |
| `<leader>gX` | Close diffview |

---

## Trouble (diagnostics panel)

| Key | Action |
|-----|--------|
| `<leader>Td` | Workspace diagnostics |
| `<leader>Tb` | Buffer diagnostics |
| `<leader>Ts` | Document symbols |
| `<leader>Tr` | LSP references |
| `<leader>Tq` | Quickfix list |
| `<leader>Tl` | Location list |
| `<leader>TE` | Errors only |
| `]t` / `[t` | Jump to next / prev trouble item |

---

## Formatting & Linting

Format-on-save is **on** by default.

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mp` | Normal/Visual | Format file or selection now |
| `<leader>tf` | Normal | Toggle format-on-save on/off |
| `<leader>ml` | Normal | Run linter manually |

| Language | Formatter | Linter |
|----------|-----------|--------|
| JS / TS / JSX / TSX | prettierd → prettier | eslint_d |
| HTML / CSS / JSON / YAML / Markdown | prettierd → prettier | — |
| PHP | php-cs-fixer | phpstan |
| Rust | rustfmt | — |
| C / C++ | clang-format | cppcheck |
| Kotlin | ktfmt | ktlint |
| Swift | swiftformat | — |
| Lua | stylua | — |
| Shell | shfmt | shellcheck |

---

## Doc Comments — Neogen

Generates idiomatic doc comment skeletons with cursor placed inside.  
Rust → `///`, JS/TS → JSDoc `/** */`, C/C++ → Doxygen, Kotlin → KDoc.

| Key | Action |
|-----|--------|
| `<leader>ng` | Generate doc comment (auto-detect type) |
| `<leader>nf` | Doc comment for function |
| `<leader>nc` | Doc comment for class / struct |
| `<leader>nt` | Doc comment for type alias |

---

## Treesitter Text Objects

Work across all supported languages.

### Select (enters visual mode)

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

## Undotree

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undo history tree |

Navigate the tree with `j`/`k`, press `<Enter>` to restore a state.

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

Active only in `.swift` / `.m` / `.mm` files.

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

## Linux Kernel / Remote Server Tips

```bash
# Generate compile_commands.json for clangd to understand the full kernel tree
make CC=clang LLVM=1 compile_commands.json          # kernel 5.15+
python3 scripts/clang-tools/gen_compile_commands.py  # older kernels

# SSH + tmux workflow (nvim runs ON the server — all plugins work)
ssh user@debian-server
tmux new -s work      # or: tmux attach -t work
nvim drivers/mydriver.c
```

---

## Mermaid Diagrams

Two complementary ways to view mermaid diagrams in markdown files — use whichever fits the session.

### Inline (terminal graphics — diagram.nvim)

Renders directly in the buffer as an image, no browser needed. Works in Kitty-protocol-capable
terminals (iTerm2, Kitty, WezTerm). Auto-renders on `InsertLeave` / `BufWinEnter` / `TextChanged`
while your cursor is inside a fenced ` ```mermaid ` block in a markdown file.

| Key | Action |
|-----|--------|
| `<leader>dgr` | Render diagram under cursor |
| `<leader>dgc` | Clear rendered images |
| `<leader>dgt` | Force re-render |

**Works over SSH?** In principle yes — it's terminal escape codes, not a GUI. If you're inside
tmux on the remote server, add `set -ga terminal-overrides ',*:Tc'` and
`set -g allow-passthrough on` to `.tmux.conf` first, or images render blank. iTerm2 supports the
Kitty graphics protocol natively, no local config needed.

### Browser preview (always works — markdown-preview.nvim)

Opens a real browser tab with full mermaid.js rendering. Use this when diagram.nvim doesn't
render (e.g. terminal doesn't support image protocols, or you're behind a tmux session without
passthrough configured).

| Key | Action |
|-----|--------|
| `<leader>mvo` | Open preview in browser |
| `<leader>mvr` | Force refresh |
| `<leader>mvc` | Close preview |

**On a remote Debian server:** the preview server binds to `localhost:8421` on the *remote*
machine. Forward the port to view it locally:
```bash
ssh -L 8421:localhost:8421 web
```
Then open `http://localhost:8421` in your local browser. Add `LocalForward 8421 localhost:8421`
under the relevant `Host` block in `~/.ssh/config` to make this automatic on every connection.

---

## Quick Reference Card

```
Navigation    gd peek · gD goto · gi impl · gr refs · gt type · gf finder
Diagnostics   [d / ]d jump · <leader>d cursor · <leader>D line · <leader>Td panel
Actions       <leader>ca code · <leader>rn rename · K hover · <C-s> signature
Files         <leader>ff find · <leader>fs grep · <leader>fo recent · <leader>fr resume
Harpoon       <leader>a add · <leader>l list · <M-1..4> jump · <M-p/n> cycle
Git           <leader>gg lazygit · <leader>gd diff · <leader>gh file history
Rust          <leader>rr run · <leader>rd debug · <leader>re macro · <leader>rh hover
Debug         <leader>dc start · <leader>db break · <leader>ds over · <leader>di into
Format        <leader>mp now · <leader>tf toggle · <leader>ml lint
Docs          <leader>ng generate · <leader>nf func · <leader>nc class
Trouble       <leader>Td workspace · <leader>Tb buffer · ]t / [t jump
Mermaid       <leader>dgr inline render · <leader>mvo browser preview
```

