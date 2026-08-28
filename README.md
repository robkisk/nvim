# My Personal Development Setup

Personal Neovim configuration built on **lazy.nvim** with LSP, treesitter, fuzzy finding, and AI-assisted development via [Claude Code](https://github.com/coder/claudecode.nvim).

## Structure

```
lua/
├── config/
│   ├── lazy.lua        # Plugin manager bootstrap
│   ├── options.lua     # Editor settings & filetype associations
│   ├── autocmds.lua    # Autocommands (highlights, borders, spell)
│   ├── mappings.lua    # Custom keybindings
│   └── utils.lua       # Utility functions
└── plugins/            # Plugin specs (one per file)
```

**Leader key:** `,`

## Plugins

| Category          | Plugins                                                                                                                                                                                                                                                                                                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Colorscheme**   | [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) (wave)                                                                                                                                                                                                                                                                                                                            |
| **Statusline**    | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) with buffer tabs                                                                                                                                                                                                                                                                                                               |
| **File Explorer** | [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)                                                                                                                                                                                                                                                                                                                                 |
| **Fuzzy Finder**  | [fzf-lua](https://github.com/ibhagwan/fzf-lua)                                                                                                                                                                                                                                                                                                                                              |
| **LSP**           | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim)                                                                                                                                                                                                                                                                       |
| **Completion**    | [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip)                                                                                                                                                                                                                                                                                            |
| **Formatting**    | [conform.nvim](https://github.com/stevearc/conform.nvim) (format on save)                                                                                                                                                                                                                                                                                                                   |
| **Treesitter**    | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch) + [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)                                                                                                                                                                                                                                        |
| **Git**           | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim), [vim-fugitive](https://github.com/tpope/vim-fugitive), [unified.nvim](https://github.com/4e554c4c/unified.nvim), [diffview.nvim](https://github.com/sindrets/diffview.nvim)                                                                                                                                                    |
| **AI**            | [claudecode.nvim](https://github.com/coder/claudecode.nvim) (terminal split, diff review)                                                                                                                                                                                                                                                                                                   |
| **Markdown**      | [markview.nvim](https://github.com/OXY2DEV/markview.nvim), [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim), [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim), [bullets.vim](https://github.com/dkarter/bullets.vim), [live-preview.nvim](https://github.com/brianhuster/live-preview.nvim) (browser preview: md/html/adoc/svg) |
| **Diagrams**      | [d2-vim](https://github.com/terrastruct/d2-vim), [tree-sitter-d2](https://github.com/pleshevskiy/tree-sitter-d2)                                                                                                                                                                                                                                                                            |
| **UI**            | [which-key.nvim](https://github.com/folke/which-key.nvim), [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)                                                                                                                                                                                                                                                  |
| **Misc**          | [emoji.nvim](https://github.com/allaman/emoji.nvim), [mini.icons](https://github.com/echasnovski/mini.icons), [yaml-companion.nvim](https://github.com/mosheavni/yaml-companion.nvim), [vim-just](https://github.com/NoahTheDuke/vim-just) (Justfile syntax), [snacks.nvim](https://github.com/folke/snacks.nvim) (claudecode dep)                                                          |

## Language Servers

Managed via mason-lspconfig with automatic installation:

| Server          | Language                                             |
| --------------- | ---------------------------------------------------- |
| `bashls`        | Bash / Shell                                         |
| `gopls`         | Go                                                   |
| `html`          | HTML                                                 |
| `jsonls`        | JSON (with schema support)                           |
| `lua_ls`        | Lua                                                  |
| `marksman`      | Markdown                                             |
| `rust_analyzer` | Rust (only enabled when a Rust toolchain is on PATH) |
| `taplo`         | TOML                                                 |
| `terraformls`   | Terraform                                            |
| `ty`            | Python                                               |
| `yamlls`        | YAML (with custom Databricks bundle schema)          |

## Formatters

Configured via conform.nvim — all run on save with LSP fallback:

| Formatter                               | Filetypes                                         |
| --------------------------------------- | ------------------------------------------------- |
| `stylua`                                | Lua                                               |
| `ruff_format` + `ruff_organize_imports` | Python                                            |
| `goimports`                             | Go                                                |
| `prettier`                              | JS, TS, JSX, TSX, JSON, YAML, HTML, CSS, Markdown |
| `shfmt`                                 | Bash / Shell                                      |
| `sqlfluff`                              | SQL (Databricks dialect)                          |

## Key Mappings

### General

| Key         | Action              |
| ----------- | ------------------- |
| `<Leader>w` | Write buffer        |
| `<Leader>s` | Source current file |

### Navigation & Buffers

| Key                 | Action                          |
| ------------------- | ------------------------------- |
| `<Tab>` / `<S-Tab>` | Next / previous buffer          |
| `<Leader>x`         | Close buffer (warns if unsaved) |
| `<Leader>t`         | Toggle file tree                |
| `<Leader>e`         | Focus file tree                 |
| `j` / `k`           | Wrap-aware up/down movement     |

### Search (fzf-lua)

| Key         | Action              |
| ----------- | ------------------- |
| `<Leader>f` | Find files          |
| `<Leader>g` | Live grep           |
| `<Leader>G` | Grep current buffer |
| `<Leader>b` | Buffers             |
| `<Leader>h` | Help tags           |
| `<Leader>v` | Browse nvim config  |
| `<Leader>R` | Recent files        |

### LSP

| Key                | Action                                        |
| ------------------ | --------------------------------------------- |
| `gd` / `gD`        | Go to definition / declaration                |
| `gi` / `gr` / `gt` | Implementation / references / type definition |
| `K`                | Hover docs                                    |
| `<C-k>`            | Signature help                                |
| `<Leader>rn`       | Rename symbol                                 |
| `<Leader>ca`       | Code action                                   |
| `[d` / `]d`        | Previous / next diagnostic                    |
| `<Leader>d`        | Show diagnostic float                         |
| `<Leader>cf`       | Format buffer                                 |

### Git

| Key          | Action                         |
| ------------ | ------------------------------ |
| `<Leader>ud` | Unified: diff against HEAD     |
| `<Leader>ur` | Unified: close diff            |
| `<Leader>dv` | Diffview: open                 |
| `<Leader>dc` | Diffview: close                |
| `<Leader>dh` | Diffview: repo file history    |
| `<Leader>df` | Diffview: current file history |

### AI (Claude Code)

| Key          | Action                                              |
| ------------ | --------------------------------------------------- |
| `<Leader>ac` | Toggle Claude terminal                              |
| `<Leader>af` | Focus Claude terminal                               |
| `<Leader>ar` | Resume Claude session                               |
| `<Leader>aC` | Continue Claude session                             |
| `<Leader>am` | Select Claude model                                 |
| `<Leader>ab` | Add current buffer to Claude                        |
| `<Leader>as` | Send selection to Claude (visual)                   |
| `<Leader>as` | Add file under cursor to Claude (file-tree buffers) |
| `<Leader>aa` | Accept Claude diff                                  |
| `<Leader>ad` | Deny Claude diff                                    |

### Markdown

| Key          | Action                                        |
| ------------ | --------------------------------------------- |
| `<Leader>mr` | Toggle in-buffer rendering (render-markdown)  |
| `<Leader>mv` | Toggle in-buffer preview (Markview)           |
| `<Leader>mp` | Toggle browser preview (markdown-preview)     |
| `<Leader>ml` | Start live browser preview (md/html/adoc/svg) |
| `<Leader>mL` | Stop live preview server                      |
| `<Leader>mt` | Document symbols / TOC                        |
| `<Leader>mc` | Insert markdown callout                       |

### File Path

| Key          | Action                  |
| ------------ | ----------------------- |
| `<Leader>cp` | Copy absolute file path |
| `<Leader>cP` | Copy relative file path |
| `<Leader>cn` | Copy filename only      |

### Clipboard

| Key                       | Action                                       |
| ------------------------- | -------------------------------------------- |
| `<Leader>y` / `<Leader>Y` | Yank selection / line to system clipboard    |
| `<Leader>p` / `<Leader>P` | Paste from system clipboard (after / before) |

### Emoji & Which-Key

| Key          | Action                    |
| ------------ | ------------------------- |
| `<Leader>se` | Search emoji              |
| `<Leader>sk` | Search kaomoji            |
| `<Leader>?`  | Show buffer-local keymaps |

### Terminal

| Key            | Action                                      |
| -------------- | ------------------------------------------- |
| `<C-w>h/j/k/l` | Navigate between windows from terminal mode |

## Editor Defaults

- 2-space tabs, relative line numbers, smart case search
- No swap files, splits open right/below
- Spell check enabled for markdown
- Search highlighting only active while searching
- Yank highlighting (200ms flash)
- Custom float border color (`#b4befe`)

## Ghostty (Terminal)

Terminal config — [`ghostty/config`](ghostty/config) (symlink into `~/.config/ghostty/`).

- **Shell:** `/bin/zsh`
- **Font:** OperatorMonoSSmLig Nerd Font @ 16pt (book/bold/italic variants)
- **Theme:** `kanagawabones` — pairs with the kanagawa Neovim colorscheme
- **Background:** Databricks logo (contain, 0.2 opacity) over a 0.7-opacity window
- **macOS:** tabbed titlebar, hidden proxy icon, `option`→`alt`, maximized on launch

| Keybind | Action |
| --- | --- |
| Ctrl+backtick (global) | Toggle quick / dropdown terminal |
| Shift+Enter | Send `ESC`+`CR` — distinct multiline key in TUIs (e.g. Claude Code) |
| Ctrl+Shift+D | Send `ESC D` (Meta/Alt+D) |

## Install

```sh
git clone https://github.com/robkisk/dotfiles ~/.config/nvim
nvim
```

Plugins install automatically on first launch via lazy.nvim. Mason will prompt to install configured language servers.

## Requirements

- Neovim >= 0.12 (nvim-treesitter `main` branch requires it)
- [fzf](https://github.com/junegunn/fzf)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- Node.js (for prettier, html/json LSP)
- Go (for gopls, goimports)
- Python + [uv](https://github.com/astral-sh/uv) (for ruff, ty)
- [sqlfluff](https://github.com/sqlfluff/sqlfluff) (for SQL formatting)
- Rust toolchain (optional — enables `rust_analyzer`)
