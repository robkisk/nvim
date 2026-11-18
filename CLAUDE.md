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

File-reload autocmds (`checktime` on FocusGained etc.) live in `config/lazy`, not `autocmds.lua`. `config/lazy` also keeps Ghostty.app's bundled runtime dir on the rtp via `performance.rtp.paths`: Ghostty exposes it through `$XDG_DATA_DIRS`, which lazy's rtp reset drops, and it's what gives the Ghostty config its filetype, syntax, and `:compiler ghostty`.

**Load-order gotcha:** `require("config.lazy")` is line 1, and `lazy.setup()` synchronously runs `:colorscheme` from `colorscheme.lua`. So by the time `autocmds.lua` (line 3) registers a `ColorScheme` autocmd, the event has **already fired**. Anything reacting to `ColorScheme` must also be applied directly at load — register the autocmd for later theme switches _and_ call it once. Same trap applies to any startup-time event lazy triggers during setup.

## Plugin Conventions

- **One spec file per plugin** in `lua/plugins/`. File name matches plugin purpose (e.g., `lsp.lua`, `fzf.lua`, `git.lua`).
- Specs return a lazy.nvim module table: `return { "org/repo", opts = {}, config = function() ... end }`.
- Use event/cmd/ft-based lazy loading where possible.
- Plugin versions pinned in `lazy-lock.json` — do not manually edit.

### Treesitter (Neovim 0.12+)

`lua/plugins/treesitter.lua` uses the `main` branch (not `master`). The `master` branch is archived and incompatible with Neovim 0.12. Key differences:

- Highlighting via `vim.treesitter.start()` in a `FileType` autocmd, NOT `highlight = { enable = true }`. The autocmd starts it only when the language has a `highlights` query: `start()` turns regex syntax off, so starting on a parser with no queries leaves the buffer with no highlighting at all (this blanked terraform, gitcommit, make, and a dozen other filetypes while `master`-era parsers sat on the rtp)
- Indent via `vim.bo.indentexpr`, NOT `indent = { enable = true }`
- Parser install via `require("nvim-treesitter").install()`, NOT `ensure_installed` in opts
- Module is `nvim-treesitter` / `nvim-treesitter.config`, NOT `nvim-treesitter.configs` (plural)
- No zsh grammar exists: `init` calls `vim.treesitter.language.register("bash", "zsh")` so zsh buffers get bash highlighting, folds, and `=` reindent (without it `indentexpr()` finds no query and `=` no-ops)
- The `FileType` autocmd skips `indentexpr` for `yaml` — yamlls owns YAML indentation — and for any language without an `indents` query, so runtime `indent/*.vim` scripts (make, just) aren't clobbered by the `-1` fallback
- Installing/updating parsers needs the `tree-sitter` CLI ≥ 0.26.1 from Homebrew's `tree-sitter-cli` formula (`:checkhealth nvim-treesitter` reports the requirement). Upstream doesn't support npm's `tree-sitter-cli`, and Homebrew's `tree-sitter` formula is only the library Neovim links against
- Parsers install to `stdpath("data")/site/parser`; `site/queries/<lang>` are symlinks into the plugin, so queries change with every plugin update while parsers change only on `:TSUpdate`. A `parser/` or `parser-info/` dir inside the plugin checkout is a `master`-era leftover: it's on the rtp, shadows Neovim's bundled parsers, and has no queries, so delete it

### snacks.nvim

`lua/plugins/snacks.lua` loads eagerly (`lazy = false`, priority 1000); its health check warns otherwise. Only `gh`, `gitbrowse`, `lazygit`, `scratch`, `zen`, and `picker` (which `gh` needs) are enabled, with `picker.ui_select = false` so fzf-lua keeps `vim.ui.select`. Snacks _replaces_ list options instead of merging them, so `gitbrowse.remote_patterns` is snacks' full default list with a `github.com-emu` → `github.com` rewrite prepended for EMU remotes. Re-sync it if snacks changes its defaults.

### camouflage.nvim

- Loads on `BufReadPost`, not the `BufReadPre` its README suggests. Set up during `BufReadPre`, it builds the buffer's Tree-sitter parser before the file is read; the tree stays empty, and JSON/YAML/TOML values go unmasked.
- Policy is `default_action = "ignore"` plus first-match-wins mask rules: whole-file for `.env*` and `.databrickscfg`, secret-looking key names, and known token prefixes. The stock default masks every parsed value (all of `package.json`). Don't use its `jwt_like`/`token_like` shapes: they match `1.0.0` and most plain values.
- `:CamouflagePresent` locks reveals but keeps the policy, so the `<Leader>kp` demo mode also flips `policy.default_action` to `mask`.
- Buffers with masked values get nvim-cmp turned off. That's camouflage's design, not a bug.

### flash.nvim

- Loads on `VeryLazy`, not lazy `keys`: its char mode maps `f`/`F`/`t`/`T`/`;` during setup, so a keys-only trigger would leave those stock until the first `s`. The jump keymaps (`s`, `S`, `r`, `R`, cmdline `<C-s>`) live in `mappings.lua`.
- Char mode skips any key equal to `mapleader`, so `,` stays the leader. Don't add `,` to `modes.char.keys`.
- Headless runs never fire `VeryLazy` (no UI). Run `nvim_exec_autocmds("User", { pattern = "VeryLazy" })` before you check char-mode maps.

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

**rust_analyzer exception:** rust_analyzer is also excluded from mason-lspconfig's `automatic_enable` (alongside yamlls). Its `root_dir` shells out to `rustc` to locate the sysroot and throws a "Press ENTER" prompt on every `.rs` buffer when no Rust toolchain is on PATH. `nvim-lspconfig`'s `config` enables it manually only when `vim.fn.executable("rustc") == 1`, so it auto-activates on the next launch once a toolchain is installed.

**lua_ls exception:** lua_ls is auto-enabled, but `nvim-lspconfig`'s `config` function additionally calls `vim.lsp.config("lua_ls", ...)` to declare the Neovim runtime (`runtime.version = "LuaJIT"`, `$VIMRUNTIME/lua` + `${3rd}/luv/library` on `workspace.library`, `diagnostics.globals = { "vim" }`). Without it lua_ls flags `vim` as an undefined global on essentially every line of this repo. `workspace.library` is deliberately scoped to the runtime rather than the whole `lazy` plugin dir — adding all ~38 plugins gives richer completion but slows indexing on every start.

**jsonls schemas:** `nvim-lspconfig`'s `config` gives jsonls a `before_init` that fills `settings.json.schemas` from SchemaStore.nvim (lazy; loaded on first `require`). Without it jsonls only validates files that declare `$schema`. yamlls gets the same catalog through its built-in `schemaStore.url` instead.

**html css settings:** `nvim-lspconfig`'s `config` sets `settings.css` for html. html-lsp requests the `css` settings section, Neovim answers `null` for sections that aren't set, and CSS validation in `<style>` blocks then throws `Cannot read properties of null (reading 'validProperties')` on every pass and reports nothing.

**harper_ls exception:** harper_ls is auto-enabled, but `vim.lsp.config("harper_ls", ...)` narrows `filetypes` to `markdown` and `gitcommit` (lspconfig's default list has 28, mostly to lint code comments). It also turns off harper's `SpellCheck` linter, because the markdown `FileType` autocmd already sets `spell` and two spellcheckers double-flag every product name. `vim.lsp.config` replaces lists rather than merging them, so `filetypes` there is the complete list.

**marksman diagnostic filter:** `nvim-lspconfig`'s `config` wraps the `textDocument/publishDiagnostics` handler to drop marksman's "Ambiguous link to document" warnings — marksman matches one on-disk file via path + basename + frontmatter title and reports ambiguity even when only one file exists. Preserve this filter if you refactor the diagnostics handler.

**ty version pin:** `ty@0.0.32` is pinned in mason-lspconfig's `ensure_installed` (Python type checker). Do not unpin without testing — newer ty releases have shipped breaking changes.

## Formatting

conform.nvim (`lua/plugins/conform.lua`) runs format-on-save with 500ms timeout (2000ms for SQL) and LSP fallback. Formatters: stylua (Lua), `ruff_organize_imports` + `ruff_format` (Python, two-step, both run with `--no-respect-gitignore`), prettier (JS/TS/JSON/YAML/HTML/CSS/MD, run with `--ignore-path /dev/null` to bypass `.gitignore` and `.prettierignore` — Prettier 3 removed `--no-ignore`), shfmt (Bash/sh), goimports (Go), sqlfluff (SQL, `--dialect databricks`).

**No zsh formatter (deliberate):** zsh is intentionally absent from `formatters_by_ft`. Neither shfmt (no zsh grammar — chokes on `${${@[(r)...]}}`) nor beautysh (naive brace counter — desyncs on `awk '{...}'` in fzf `--preview` blocks) can format real zsh. Use Treesitter `=` (`gg=G` or visual `=`) to reindent zsh instead.

**goimports is configured but not installed** — `conform` reports `available=false`, so Go files silently fall back to LSP formatting. Mason installs none of the formatters: stylua, prettier, and shfmt come from Homebrew, and ruff and sqlfluff from `uv tool`, so any one missing from PATH fails the same quiet way. Either `go install golang.org/x/tools/cmd/goimports@latest` or drop the `go` entry; don't assume Go files are being formatted.

**Lua is tab-indented everywhere**, pinned by `.stylua.toml` (`indent_type = "Tabs"`, 120-col default). Edit with tabs so format-on-save is a no-op; `stylua --check init.lua lua` should exit 0 before committing.

**SQL Metric View gotcha:** `.sql` files starting with `source:`, `measures:`, `dimensions:`, or `joins:` skip auto-format entirely — these are YAML-in-.sql Databricks Metric View definitions and sqlfluff can't parse them.

## Keybinding Pattern

`lua/config/mappings.lua` uses a local `map()` wrapper that sets `noremap = true`, `silent = true`, and a `desc` string (for which-key discovery). All non-LSP, non-plugin-internal keymaps go here.

**Exception:** the wrap-aware `j`/`k` mappings use raw `vim.keymap.set` with `expr = true` — the `map()` wrapper doesn't forward `expr`.

**Keymaps actually live in five places** — grep all five before assuming a key is free:

1. `lua/config/mappings.lua` — the bulk, via the `map()` wrapper
2. `LspAttach` in `lua/plugins/lsp.lua` — buffer-local, only on attached buffers
3. lazy `keys =` specs — `conform.lua` (`<Leader>cf`), `emoji.lua` (`<Leader>se`, `<Leader>sk`), `which-key.lua` (`<Leader>?`). These must stay in the spec, since lazy uses them as load triggers.
4. `FileType` autocmd in `lua/config/autocmds.lua` — buffer-local `<Leader>as` (`ClaudeCodeTreeAdd`), tree-explorer buffers only
5. `FileType` autocmd in `lua/plugins/autolist.lua` — buffer-local list editing (`<CR>`, `o`, `O`, `>>`, `<<`, `dd`, `gN`, `<Leader>X`, insert `<Tab>`/`<S-Tab>`/`<C-t>`/`<C-d>`, visual `>`/`<`/`d`), markdown/text/gitcommit buffers only. Insert `<Tab>`/`<S-Tab>` (the keys autolist's README maps) indent only on a list item and stay stock elsewhere. They live in the spec, not `mappings.lua`, because they call autolist's commands and must exist only once it has loaded.

**Prefix collisions cost latency, not correctness.** A standalone mapping that is also the prefix of a longer one waits out `timeoutlen` (300ms here) before firing; the longer mapping still works. Measured: a non-shadowed key like `<Leader>w` fires in ~0ms, a prefix-shadowed key takes ~400ms. Current shadowed keys: `<Leader>s` (always, by `,se`/`,sk`/`,sr`) and `<Leader>d` (only on LSP-attached buffers — bare `<Leader>d` is the `LspAttach` "show diagnostic" map, shadowed by the global `,dv`/`,dc`/`,dh`/`,df` Diffview maps).

## Filetype Associations

Defined in `lua/config/options.lua`:

- `.databrickscfg` → shell
- `.env` / `.env.*` → shell
- `.gitmessage` → gitcommit
- `*.gitconfig*` (the includes `.gitconfig` pulls in, like `themes.gitconfig`) → gitconfig; Neovim only detects the exact name `.gitconfig`

Also registered via `vim.filetype.add` in `lua/config/autocmds.lua`:

- `.tfstate` → json

## MCP Servers

`.mcp.json` configures the MCP servers visible from this directory. The list changes frequently (~30 servers across Databricks tooling, browser automation, and code search) — read `.mcp.json` directly when you need the current set rather than relying on a list here.

For Neovim/Lua-specific lookups (lsp config, mason, plugin source), the `serena` MCP is the primary code-search tool. For web docs that aren't covered, fall back to `WebFetch`.

## Supporting Directories

- `schemas/databricks_bundle.json` — JSON schema consumed by yaml-companion.nvim to validate Declarative Automation Bundle YAML (wired in `lua/plugins/lsp.lua`). Regenerate with `databricks bundle schema > schemas/databricks_bundle.json` after CLI upgrades
- `styles/databricks-markdown.css` — stylesheet for markdown-preview.nvim
- `snippets/` — custom LuaSnip snippets in VS Code format (`package.json` + `markdown.json`), loaded after friendly-snippets in `lua/plugins/cmp.lua`

See `README.md` for the exhaustive plugin inventory and keymap tables — do not duplicate those here.

## Testing Changes

Verify plugin/config changes headless before reporting done:

```bash
# Runtime errors on load
nvim --headless -c "edit <file>" -c "sleep 3" -c "qa" 2>&1

# Isolate: plugins vs Neovim runtime
nvim --clean --headless -c "edit <file>" -c "sleep 3" -c "qa" 2>&1

# Sync plugins after branch/spec changes
nvim --headless "+Lazy! sync" -c "sleep 20" -c "qa" 2>&1

# Assert on state — read the value, don't eyeball the buffer
nvim --headless -c 'lua io.write(vim.inspect(vim.api.nvim_get_hl(0,{name="FloatBorder"})).."\n")' -c qa 2>&1
```

**LSP assertions need ~12s, not 3s.** Servers must spawn, index, and publish before `vim.diagnostic.get()` is meaningful. At `sleep 3` it returns `0` diagnostics — identical to a clean pass, so a broken server reads as verified. Use `vim.defer_fn(..., 12000)` with `-c "sleep 14"`:

```bash
nvim --headless <file> -c 'lua vim.defer_fn(function()
  io.write("clients: "..#vim.lsp.get_clients({bufnr=0}).."\n")
  io.write("diagnostics: "..#vim.diagnostic.get(0).."\n")
end, 12000)' -c "sleep 14" -c qa 2>&1
```

Always print the count/value you're asserting on. A silent run proves the process exited, not that the change works.

Interactive troubleshooting (inside nvim): `:Lazy` (plugin state), `:Mason` (LSP binary state), `:LspInfo` (attached servers), `:checkhealth` (global).
