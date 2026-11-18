# My Personal Development Setup

Personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim) with LSP, Treesitter, fuzzy finding, and AI-assisted development via [Claude Code](https://github.com/coder/claudecode.nvim).

## Structure

```text
init.lua                # Loads the config modules below, in this order
lua/
├── config/
│   ├── lazy.lua        # lazy.nvim bootstrap, leader key, reload of files changed on disk
│   ├── options.lua     # Editor settings & filetype associations
│   ├── autocmds.lua    # Autocommands (highlights, yank flash, markdown spell and folds)
│   ├── utils.lua       # Utility functions (P() debug print)
│   └── mappings.lua    # Keybindings
└── plugins/            # Plugin specs (one per file)
schemas/                # Databricks bundle JSON schema for yamlls
snippets/               # Custom LuaSnip snippets (VS Code format)
styles/                 # Stylesheet for markdown-preview
lazy-lock.json          # Pinned plugin versions
.stylua.toml            # stylua settings (tab indent)
```

**Leader key:** `,`

## Plugins

| Category          | Plugins                                                                                                                                                                                                                                                                                                                                                                                                    |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Colorscheme**   | [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) (wave)                                                                                                                                                                                                                                                                                                                                           |
| **Statusline**    | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) with buffer tabs                                                                                                                                                                                                                                                                                                                              |
| **File Explorer** | [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)                                                                                                                                                                                                                                                                                                                                                |
| **Fuzzy Finder**  | [fzf-lua](https://github.com/ibhagwan/fzf-lua)                                                                                                                                                                                                                                                                                                                                                             |
| **Motion**        | [flash.nvim](https://github.com/folke/flash.nvim) (label jumps, enhanced `f`/`t`, Treesitter selection)                                                                                                                                                                                                                                                                                                    |
| **Find/Replace**  | [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) (project-wide search & replace)                                                                                                                                                                                                                                                                                                                |
| **LSP**           | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/mason-org/mason.nvim) + [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) + [SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim) (JSON schema catalog)                                                                                                                         |
| **Completion**    | [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) with [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp), [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip), [cmp-buffer](https://github.com/hrsh7th/cmp-buffer), and [cmp-path](https://github.com/hrsh7th/cmp-path) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) + [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) |
| **Formatting**    | [conform.nvim](https://github.com/stevearc/conform.nvim) (format on save)                                                                                                                                                                                                                                                                                                                                  |
| **Treesitter**    | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main` branch) + [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)                                                                                                                                                                                                                                                       |
| **Git**           | [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim), [vim-fugitive](https://github.com/tpope/vim-fugitive), [unified.nvim](https://github.com/axkirillov/unified.nvim), [diffview.nvim](https://github.com/sindrets/diffview.nvim), [snacks.nvim](https://github.com/folke/snacks.nvim) (gh, gitbrowse, lazygit)                                                                                   |
| **AI**            | [claudecode.nvim](https://github.com/coder/claudecode.nvim) (terminal split, diff review)                                                                                                                                                                                                                                                                                                                  |
| **Markdown**      | [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim), [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim), [autolist.nvim](https://github.com/gaoDean/autolist.nvim), [live-preview.nvim](https://github.com/brianhuster/live-preview.nvim) (browser preview: md/html/adoc/svg)                                                                       |
| **Diagrams**      | [d2-vim](https://github.com/terrastruct/d2-vim), [tree-sitter-d2](https://github.com/ravsii/tree-sitter-d2)                                                                                                                                                                                                                                                                                                |
| **Secrets**       | [camouflage.nvim](https://github.com/zeybek/camouflage.nvim) (masks tokens and keys on screen; demo mode)                                                                                                                                                                                                                                                                                                  |
| **UI**            | [which-key.nvim](https://github.com/folke/which-key.nvim), [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim), [mini.icons](https://github.com/nvim-mini/mini.icons), [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)                                                                                                                                     |
| **Misc**          | [emoji.nvim](https://github.com/allaman/emoji.nvim), [yaml-companion.nvim](https://github.com/mosheavni/yaml-companion.nvim), [vim-just](https://github.com/NoahTheDuke/vim-just) (Justfile syntax), [snacks.nvim](https://github.com/folke/snacks.nvim) (zen, scratch), [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (library)                                                                |

## Language Servers

Managed via mason-lspconfig with automatic installation:

| Server          | Language                                                                                     |
| --------------- | -------------------------------------------------------------------------------------------- |
| `bashls`        | Bash / Shell                                                                                 |
| `gopls`         | Go                                                                                           |
| `harper_ls`     | Grammar in Markdown and git commit messages (spelling stays with vim spell)                  |
| `html`          | HTML                                                                                         |
| `jsonls`        | JSON (SchemaStore catalog: Claude/Codex plugin manifests, package.json, tsconfig, ...)       |
| `lua_ls`        | Lua                                                                                          |
| `marksman`      | Markdown                                                                                     |
| `rust_analyzer` | Rust (only enabled when a Rust toolchain is on PATH)                                         |
| `taplo`         | TOML                                                                                         |
| `terraformls`   | Terraform                                                                                    |
| `ty`            | Python (pinned to 0.0.32)                                                                    |
| `yamlls`        | YAML (SchemaStore, plus the Databricks bundle schema on `databricks.yml` and `resources/**`) |

## Formatters

Configured via conform.nvim — all run on save with LSP fallback:

| Formatter                               | Filetypes                                                                   |
| --------------------------------------- | --------------------------------------------------------------------------- |
| `stylua`                                | Lua                                                                         |
| `ruff_format` + `ruff_organize_imports` | Python                                                                      |
| `goimports`                             | Go (optional; without it, gopls formats Go through the LSP fallback)        |
| `prettier`                              | JS, TS, JSX, TSX, JSON, YAML, HTML, CSS, Markdown                           |
| `shfmt`                                 | Bash / Shell                                                                |
| `sqlfluff`                              | SQL (Databricks dialect); skips Metric View files, which are YAML in `.sql` |

Mason installs only the language servers. The formatters come from your PATH; see [Requirements](#requirements). There's no zsh formatter: shfmt and beautysh both mangle real zsh, so reindent it with Treesitter's `=` (`gg=G`). `<Leader>cf` formats on demand.

This repo's own Lua is tab-indented, pinned by `.stylua.toml`.

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

### Jump (flash)

| Key             | Mode           | Action                                                                                   |
| --------------- | -------------- | ---------------------------------------------------------------------------------------- |
| `s`             | n, x, o        | Jump: type a few chars, then the label (`<CR>` takes the nearest match)                  |
| `S`             | n, x, o        | Select a Treesitter node by label; `;` / `,` grow or shrink it                           |
| `r`             | o              | Remote: `yr` + label + motion yanks there and returns                                    |
| `R`             | x, o           | Treesitter search: `yR` + pattern + label acts on the node around a match                |
| `<C-s>`         | `/` `?` prompt | Toggle flash labels in regular search                                                    |
| `f` `F` `t` `T` | n, x, o        | Multi-line char motions; repeat with the same key or `;`, go back with the opposite case |

`s` and `S` replace the built-ins; use `cl` and `cc`. `,` stays the leader key, so it isn't a flash repeat key.

### Search (fzf-lua)

| Key          | Action              |
| ------------ | ------------------- |
| `<Leader>f`  | Find files          |
| `<Leader>g`  | Live grep           |
| `<Leader>G`  | Grep current buffer |
| `<Leader>b`  | Buffers             |
| `<Leader>h`  | Help tags           |
| `<Leader>H`  | Search keymaps      |
| `<Leader>v`  | Browse nvim config  |
| `<Leader>R`  | Recent files        |
| `<Leader>cd` | `cd` via zoxide     |

### Search & Replace (grug-far)

| Key          | Action                                                                                                                |
| ------------ | --------------------------------------------------------------------------------------------------------------------- |
| `<Leader>sr` | Search & replace across the project; files filter starts as `*.<this file's ext>`, visual mode prefills the selection |

### LSP

| Key                   | Action                                                           |
| --------------------- | ---------------------------------------------------------------- |
| `gd` / `gD`           | Go to definition / declaration                                   |
| `gri` / `grr` / `grt` | Implementation / references / type definition (Neovim built-ins) |
| `K`                   | Hover docs                                                       |
| `<C-k>`               | Signature help                                                   |
| `<Leader>rn`          | Rename symbol                                                    |
| `<Leader>ca`          | Code action                                                      |
| `[d` / `]d`           | Previous / next diagnostic                                       |
| `<Leader>d`           | Show diagnostic float                                            |
| `<Leader>cf`          | Format buffer                                                    |

### Completion & Snippets (nvim-cmp, LuaSnip)

Insert mode. `<CR>` accepts only a selected item (one you moved to, or one the language server preselects); otherwise it's a plain newline.

| Key                          | Action                                                                         |
| ---------------------------- | ------------------------------------------------------------------------------ |
| `<C-Space>`                  | Open the completion menu                                                       |
| `<C-n>` or `<C-j>` / `<C-p>` | Next / previous item                                                           |
| `<CR>` or `<C-y>`            | Accept the selected item                                                       |
| `<C-e>`                      | Close the menu                                                                 |
| `<C-d>` / `<C-u>`            | Scroll the docs window                                                         |
| `<C-l>` / `<C-h>`            | Snippet: expand or jump to the next field / jump back (insert and select mode) |

Sources: LSP and snippets first, then words from the buffer and file paths. Snippets come from friendly-snippets plus `snippets/`.

### Git

| Key          | Action                         |
| ------------ | ------------------------------ |
| `<Leader>ud` | Unified: diff against HEAD     |
| `<Leader>ur` | Unified: close diff            |
| `<Leader>dv` | Diffview: open                 |
| `<Leader>dc` | Diffview: close                |
| `<Leader>dh` | Diffview: repo file history    |
| `<Leader>df` | Diffview: current file history |

### GitHub & Lazygit (snacks)

| Key                         | Action                                            |
| --------------------------- | ------------------------------------------------- |
| `<Leader>op` / `<Leader>oP` | GitHub PRs (open / all), via `gh`                 |
| `<Leader>oi` / `<Leader>oI` | GitHub issues (open / all)                        |
| `<Leader>ob`                | Open file or selection on GitHub                  |
| `<Leader>ol`                | Copy a GitHub permalink for the line or selection |
| `<Leader>og`                | Lazygit                                           |

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
| `<Leader>mp` | Toggle browser preview (markdown-preview)     |
| `<Leader>ml` | Start live browser preview (md/html/adoc/svg) |
| `<Leader>mL` | Stop live preview server                      |
| `<Leader>md` | Read in mdd in a floating Rex pane (mddog)    |
| `<Leader>mt` | Document symbols / TOC                        |
| `<Leader>mc` | Insert markdown callout                       |

### Lists (autolist)

Buffer-local in markdown, text, and git commit buffers; everywhere else these keys are stock.

| Key                 | Action                                                                             |
| ------------------- | ---------------------------------------------------------------------------------- |
| `<CR>`              | New line that continues the list; on an empty item, ends the list (insert)         |
| `<C-CR>`            | New line without a bullet (insert)                                                 |
| `o` / `O`           | Open a line below / above that continues the list                                  |
| `<Tab>` / `<S-Tab>` | On a list item, indent / dedent it, then renumber; elsewhere a normal Tab (insert) |
| `<C-t>` / `<C-d>`   | Same, on any line (insert)                                                         |
| `>>` / `<<`         | Indent / dedent the item, then renumber                                            |
| `>` / `<`           | Indent / dedent the selected items, then renumber (visual)                         |
| `dd` / `d`          | Delete the line / selection, then renumber                                         |
| `gN`                | Renumber the list under the cursor (normal or visual)                              |
| `<Leader>X`         | Toggle checkbox                                                                    |

### Writing (snacks)

| Key         | Action                |
| ----------- | --------------------- |
| `<Leader>z` | Zen mode              |
| `<Leader>.` | Toggle scratch buffer |
| `<Leader>S` | Select scratch buffer |

### Secrets (camouflage)

Secrets are masked automatically: every value in `.env*` and `~/.databrickscfg`, and elsewhere only secret-looking keys (`*token`, `secret`, `password`, `api_key`, ...) and known token prefixes (`dapi`, `sk-`, `ghp_`, ...). Buffers with masked values have completion turned off.

| Key          | Action                                            |
| ------------ | ------------------------------------------------- |
| `<Leader>kt` | Toggle masking                                    |
| `<Leader>kr` | Reveal the current line                           |
| `<Leader>kp` | Demo mode on: mask every value and refuse reveals |
| `<Leader>kP` | Demo mode off                                     |

### File Path

| Key          | Action                  |
| ------------ | ----------------------- |
| `<Leader>cp` | Copy absolute file path |
| `<Leader>cP` | Copy relative file path |
| `<Leader>cn` | Copy filename only      |

### Clipboard

Plain `y` and `p` already use the system clipboard (`clipboard=unnamedplus`); these are the explicit `"+` forms.

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

- 2-space indent with spaces, relative line numbers, smart-case search
- No swap files, persistent undo, splits open right/below
- Sign column always shown (no text shift when git/diagnostic signs appear)
- Global statusline, hidden command line (`cmdheight=0`), cursor line highlight
- Yank and paste use the system clipboard (`clipboard=unnamedplus`)
- New lines don't continue a comment (`formatoptions` drops `c`, `r`, and `o`)
- Search highlighting only active while searching
- Yank highlighting (200ms flash)
- Files changed on disk reload on their own (checked on focus, buffer switches, and idle), unless the buffer has unsaved changes
- Markdown: spell check, and Treesitter folding by section (opens unfolded)
- Custom float border color (`#b4befe`)
- Filetypes: `.env`, `.env.*`, and `.databrickscfg` as shell; `.gitmessage` as a git commit; any `*.gitconfig*` file as gitconfig; `*.tfstate` as JSON

## Install

```sh
git clone https://github.com/robkisk/nvim ~/.config/nvim
nvim
```

On first launch, lazy.nvim installs the plugins, mason-lspconfig installs the language servers, and nvim-treesitter compiles its parsers. Install the formatters and other tools under Requirements yourself.

## Requirements

- Neovim >= 0.12 (nvim-treesitter `main` branch requires it)
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) >= 0.26.1 via `brew install tree-sitter-cli` (nvim-treesitter `main` compiles parsers with it; npm's `tree-sitter-cli` is unsupported, and Homebrew's `tree-sitter` formula is only the library)
- Xcode Command Line Tools (`make` and a C compiler, for the parsers and LuaSnip's `jsregexp` build)
- [fzf](https://github.com/junegunn/fzf)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (fzf-lua grep, grug-far)
- [gh](https://cli.github.com/), authenticated (snacks GitHub PR/issue pickers)
- Formatters on your PATH: `brew install stylua prettier shfmt`, then `uv tool install ruff` and `uv tool install sqlfluff`. Optional: `go install golang.org/x/tools/cmd/goimports@latest`
- Node.js (Mason's html, json, yaml, and bash servers; prettier; markdown-preview's build)
- Go (Mason builds gopls with it)
- Python 3 (Mason installs ty into a virtualenv) and [uv](https://github.com/astral-sh/uv) (for ruff and sqlfluff)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- [zoxide](https://github.com/ajeetdsouza/zoxide) and [lazygit](https://github.com/jesseduffield/lazygit) (optional: `<Leader>cd`, `<Leader>og`)
- [mddog](https://mddog.pages.dev)'s `mdd` (`brew install qu8n/tap/mddog`), with Neovim running in a [Rex](https://www.superlogical.com/rex/docs) pane (optional: `<Leader>md`)
- Rust toolchain (optional — enables `rust_analyzer`)
- [Databricks CLI](https://github.com/databricks/cli) (optional: after upgrading it, regenerate the bundle schema with `databricks bundle schema > schemas/databricks_bundle.json`)
