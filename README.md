# nvim

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

| Category | Plugins |
|---|---|
| **Colorscheme** | [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) (wave) |
| **Statusline** | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) with buffer tabs |
| **File Explorer** | [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) |
| **Fuzzy Finder** | [fzf-lua](https://github.com/ibhagwan/fzf-lua) |
| **LSP** | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim) |
| **Completion** | [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) |
| **Formatting** | [conform.nvim](https://github.com/stevearc/conform.nvim) (format on save) |
| **Treesitter** | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) + [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) |
| **Git** | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim), [vim-fugitive](https://github.com/tpope/vim-fugitive), [unified.nvim](https://github.com/4e554c4c/unified.nvim) |
| **AI** | [claudecode.nvim](https://github.com/coder/claudecode.nvim) (terminal split, diff review) |
| **Markdown** | [markview.nvim](https://github.com/OXY2DEV/markview.nvim), [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim), [bullets.vim](https://github.com/dkarter/bullets.vim) |
| **Diagrams** | [d2-vim](https://github.com/terrastruct/d2-vim), [tree-sitter-d2](https://github.com/pleshevskiy/tree-sitter-d2) |
| **UI** | [which-key.nvim](https://github.com/folke/which-key.nvim), [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) |
| **Misc** | [emoji.nvim](https://github.com/allaman/emoji.nvim), [mini.icons](https://github.com/echasnovski/mini.icons), [yaml-companion.nvim](https://github.com/mosheavni/yaml-companion.nvim), [snacks.nvim](https://github.com/folke/snacks.nvim) (claudecode dep) |

## Language Servers

Managed via mason-lspconfig with automatic installation:

| Server | Language |
|---|---|
| `bashls` | Bash / Shell |
| `gopls` | Go |
| `html` | HTML |
| `jsonls` | JSON (with schema support) |
| `lua_ls` | Lua |
| `marksman` | Markdown |
| `terraformls` | Terraform |
| `ty` | Python |
| `yamlls` | YAML (with custom Databricks bundle schema) |

## Formatters

Configured via conform.nvim — all run on save with LSP fallback:

| Formatter | Filetypes |
|---|---|
| `stylua` | Lua |
| `ruff_format` + `ruff_organize_imports` | Python |
| `prettier` | JS, TS, JSON, YAML, HTML, CSS, Markdown |
| `shfmt` | Bash / Shell |

## Key Mappings

### General

| Key | Action |
|---|---|
| `<Leader>w` | Write buffer |
| `<Leader>s` | Source current file |

### Navigation & Buffers

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<Leader>x` | Close buffer |
| `<Leader>t` | Toggle file tree |
| `<Leader>e` | Focus file tree |
| `j` / `k` | Wrap-aware up/down movement |

### Search (fzf-lua)

| Key | Action |
|---|---|
| `<Leader>f` | Find files |
| `<Leader>g` | Live grep |
| `<Leader>G` | Grep current buffer |
| `<Leader>b` | Buffers |
| `<Leader>h` | Help tags |
| `<Leader>v` | Browse nvim config |
| `<Leader>R` | Recent files |

### LSP

| Key | Action |
|---|---|
| `gd` / `gD` | Go to definition / declaration |
| `gi` / `gr` / `gt` | Implementation / references / type definition |
| `K` | Hover docs |
| `<C-k>` | Signature help |
| `<Leader>rn` | Rename symbol |
| `<Leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |
| `<Leader>d` | Show diagnostic float |
| `<Leader>cf` | Format buffer |

### Git

| Key | Action |
|---|---|
| `<Leader>ud` | Diff against HEAD |
| `<Leader>ur` | Close diff |

### AI (Claude Code)

| Key | Action |
|---|---|
| `<Leader>ac` | Toggle Claude terminal |
| `<Leader>af` | Focus Claude terminal |
| `<Leader>ar` | Resume Claude session |
| `<Leader>aC` | Continue Claude session |
| `<Leader>am` | Select Claude model |
| `<Leader>ab` | Add current buffer to Claude |
| `<Leader>as` | Send selection to Claude (visual) |
| `<Leader>aa` | Accept Claude diff |
| `<Leader>ad` | Deny Claude diff |

### Markdown

| Key | Action |
|---|---|
| `<Leader>mr` | Toggle markdown rendering |
| `<Leader>mp` | Toggle browser markdown preview |

### Clipboard

| Key | Action |
|---|---|
| `<Leader>y` / `<Leader>Y` | Yank selection / line to system clipboard |
| `<Leader>p` / `<Leader>P` | Paste from system clipboard (after / before) |

### Terminal

| Key | Action |
|---|---|
| `<C-w>h/j/k/l` | Navigate between windows from terminal mode |

## Editor Defaults

- 2-space tabs, relative line numbers, smart case search
- No swap files, splits open right/below
- Spell check enabled for markdown
- Search highlighting only active while searching
- Yank highlighting (200ms flash)
- Custom float border color (`#b4befe`)

## Install

```sh
git clone https://github.com/robkisk/dotfiles ~/.config/nvim
nvim
```

Plugins install automatically on first launch via lazy.nvim. Mason will prompt to install configured language servers.

## Requirements

- Neovim >= 0.10
- [fzf](https://github.com/junegunn/fzf)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- Node.js (for prettier, html/json LSP)
- Go (for gopls)
- Python + [uv](https://github.com/astral-sh/uv) (for ruff, ty)
