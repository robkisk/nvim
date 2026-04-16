# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal Neovim configuration built on lazy.nvim. Leader key is `,`.

## Architecture

Bootstrap sequence in `init.lua` loads five modules in order:

1. `config/lazy` — lazy.nvim plugin manager (auto-installs on first launch)
2. `config/options` — editor settings, filetype associations
3. `config/autocmds` — autocommands (highlights, borders, spell, file reload)
4. `config/utils` — utility functions (`P()` for debug printing)
5. `config/mappings` — **all** keybindings live here (except LSP-attach and plugin-internal ones)

## Plugin Conventions

- **One spec file per plugin** in `lua/plugins/`. File name matches plugin purpose (e.g., `lsp.lua`, `fzf.lua`, `git.lua`).
- Specs return a lazy.nvim module table: `return { "org/repo", opts = {}, config = function() ... end }`.
- Use event/cmd/ft-based lazy loading where possible.
- Plugin versions pinned in `lazy-lock.json` — do not manually edit.

### Adding a New Plugin

1. Create `lua/plugins/<name>.lua` returning a lazy.nvim spec table
2. Add keymaps to `lua/config/mappings.lua` (not inside the plugin spec) unless the mapping requires plugin-local state
3. If the plugin needs a treesitter parser, add it to the `ensure_installed` list in `lua/plugins/treesitter.lua`

## LSP Architecture (Three-Tier)

`lua/plugins/lsp.lua` contains all three layers:

1. **mason.nvim** — installs LSP binaries
2. **mason-lspconfig.nvim** — bridges mason → lspconfig, `ensure_installed` list defines auto-installed servers
3. **nvim-lspconfig** — configures each server; LSP keybindings attached via `LspAttach` autocommand in the same file

**yamlls exception:** yamlls is excluded from mason-lspconfig's automatic enable because it's configured manually through yaml-companion.nvim with a custom Databricks bundle schema at `schemas/databricks_bundle.json`.

## Formatting

conform.nvim (`lua/plugins/conform.lua`) runs format-on-save with 500ms timeout and LSP fallback. Formatters: stylua (Lua), ruff (Python), prettier (JS/TS/JSON/YAML/HTML/CSS/MD), shfmt (Bash).

## Keybinding Pattern

`lua/config/mappings.lua` uses a local `map()` wrapper that sets `noremap = true`, `silent = true`, and a `desc` string (for which-key discovery). All non-LSP, non-plugin-internal keymaps go here.

## Filetype Associations

Defined in `lua/config/options.lua`:
- `.databrickscfg` → shell
- `.env` / `.env.*` → shell
- `.tfstate` → json (via autocommand in `autocmds.lua`)

## MCP Servers

`.mcp.json` configures documentation servers for this project. Use these instead of web searches when modifying LSP or Mason config:
- `lsp-config` MCP — nvim-lspconfig docs and source
- `mason` MCP — mason.nvim docs and source
