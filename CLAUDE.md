# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal Neovim configuration built on lazy.nvim. Leader key is `,`.

## Architecture

Bootstrap sequence in `init.lua` loads five modules in order:

1. `config/lazy` — lazy.nvim plugin manager (auto-installs on first launch)
2. `config/options` — editor settings, filetype associations
3. `config/autocmds` — autocommands (highlights, hlsearch toggle, yank flash, spell for markdown, comment-continuation opt-out, `<Leader>as` in tree buffers, `.tfstate` filetype reg)
4. `config/utils` — utility functions (`P()` for debug printing)
5. `config/mappings` — **all** keybindings live here (except LSP-attach and plugin-internal ones)

File-reload autocmds (`checktime` on FocusGained etc.) live in `config/lazy`, not `autocmds.lua`.

## Plugin Conventions

- **One spec file per plugin** in `lua/plugins/`. File name matches plugin purpose (e.g., `lsp.lua`, `fzf.lua`, `git.lua`).
- Specs return a lazy.nvim module table: `return { "org/repo", opts = {}, config = function() ... end }`.
- Use event/cmd/ft-based lazy loading where possible.
- Plugin versions pinned in `lazy-lock.json` — do not manually edit.

### Treesitter (Neovim 0.12+)

`lua/plugins/treesitter.lua` uses the `main` branch (not `master`). The `master` branch is archived and incompatible with Neovim 0.12. Key differences:
- Highlighting via `vim.treesitter.start()` in a `FileType` autocmd, NOT `highlight = { enable = true }`
- Indent via `vim.bo.indentexpr`, NOT `indent = { enable = true }`
- Parser install via `require("nvim-treesitter").install()`, NOT `ensure_installed` in opts
- Module is `nvim-treesitter` / `nvim-treesitter.config`, NOT `nvim-treesitter.configs` (plural)

### Adding a New Plugin

1. Create `lua/plugins/<name>.lua` returning a lazy.nvim spec table
2. Add keymaps to `lua/config/mappings.lua` (not inside the plugin spec) unless the mapping requires plugin-local state
3. If the plugin needs a treesitter parser, add it to the `ensure_installed` table in the `config` function of `lua/plugins/treesitter.lua`

## LSP Architecture (Three-Tier)

`lua/plugins/lsp.lua` contains all three layers:

1. **mason.nvim** — installs LSP binaries
2. **mason-lspconfig.nvim** — bridges mason → lspconfig, `ensure_installed` list defines auto-installed servers
3. **nvim-lspconfig** — configures each server; LSP keybindings attached via `LspAttach` autocommand in the same file

**yamlls exception:** yamlls is excluded from mason-lspconfig's automatic enable because it's configured manually through yaml-companion.nvim with a custom Databricks bundle schema at `schemas/databricks_bundle.json`.

## Formatting

conform.nvim (`lua/plugins/conform.lua`) runs format-on-save with 500ms timeout and LSP fallback. Formatters: stylua (Lua), `ruff_organize_imports` + `ruff_format` (Python, two-step), prettier (JS/TS/JSON/YAML/HTML/CSS/MD, run with `--no-ignore`), shfmt (Bash/sh).

## Keybinding Pattern

`lua/config/mappings.lua` uses a local `map()` wrapper that sets `noremap = true`, `silent = true`, and a `desc` string (for which-key discovery). All non-LSP, non-plugin-internal keymaps go here.

**Exception:** the wrap-aware `j`/`k` mappings use raw `vim.keymap.set` with `expr = true` — the `map()` wrapper doesn't forward `expr`.

## Filetype Associations

Defined in `lua/config/options.lua`:
- `.databrickscfg` → shell
- `.env` / `.env.*` → shell

Also registered via `vim.filetype.add` in `lua/config/autocmds.lua`:
- `.tfstate` → json

## MCP Servers

`.mcp.json` configures MCP servers for this project:
- `fetch` — general URL fetching
- `lsp-config` MCP — nvim-lspconfig docs and source
- `mason` MCP — mason.nvim docs and source
- `Claude Code Skills` MCP — Anthropic skills documentation
- `Hobson Agents` MCP — Hobson agents documentation

Use lsp-config/mason MCPs instead of web searches when modifying LSP or Mason config.

## Supporting Directories

- `schemas/databricks_bundle.json` — JSON schema consumed by yaml-companion.nvim to validate Databricks Asset Bundle YAML (wired in `lua/plugins/lsp.lua`)
- `styles/databricks-markdown.css` — stylesheet for markdown-preview.nvim
- `nvim-code-map.html` — generated code map (not source)

See `README.md` for the exhaustive plugin inventory and keymap tables — do not duplicate those here.

## Testing Changes

Verify plugin/config changes headless before reporting done:
- `nvim --headless -c "edit <file>" -c "sleep 3" -c "qa" 2>&1` — check for runtime errors
- `nvim --headless "+Lazy! sync" -c "sleep 20" -c "qa" 2>&1` — sync plugins after branch/spec changes
- `nvim --clean --headless -c "edit <file>" -c "sleep 3" -c "qa" 2>&1` — isolate: plugins vs Neovim runtime

Interactive troubleshooting (inside nvim): `:Lazy` (plugin state), `:Mason` (LSP binary state), `:LspInfo` (attached servers), `:checkhealth` (global).
