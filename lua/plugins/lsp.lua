return {
	-- Mason: Package manager for LSP servers
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	-- Mason-LSPConfig: Bridge between mason and lspconfig
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"bashls",
				"gopls",
				"harper_ls",
				"html",
				"jsonls",
				"lua_ls",
				"marksman",
				"rust_analyzer",
				"taplo",
				"terraformls",
				"ty@0.0.32",
				"yamlls",
			},
			automatic_enable = {
				-- rust_analyzer is enabled conditionally in nvim-lspconfig's config
				-- (only when a Rust toolchain is on PATH) to avoid a hard error.
				exclude = { "yamlls", "rust_analyzer" },
			},
		},
	},

	-- yaml-companion: Schema management for YAML LSP
	{
		"mosheavni/yaml-companion.nvim",
		ft = { "yaml" },
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			schemas = {
				{
					name = "Databricks Bundle",
					uri = "file://" .. vim.fn.expand("~/.config/nvim/schemas/databricks_bundle.json"),
				},
			},
			lspconfig = {
				settings = {
					yaml = {
						validate = true,
						-- SchemaStore covers GitHub workflows, compose, k8s, etc. The DAB schema
						-- is scoped to bundle files; for includes elsewhere, pick it manually
						-- with require("yaml-companion").open_ui_select().
						schemaStore = {
							enable = true,
							url = "https://www.schemastore.org/api/json/catalog.json",
						},
						schemas = {
							["file://" .. vim.fn.expand("~/.config/nvim/schemas/databricks_bundle.json")] = {
								"databricks.yml",
								"databricks.yaml",
								"**/resources/**/*.yml",
								"**/resources/**/*.yaml",
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local cfg = require("yaml-companion").setup(opts)
			vim.lsp.config("yamlls", cfg)
			vim.lsp.enable("yamlls")
		end,
	},

	-- SchemaStore: JSON schema catalog for jsonls, loaded on first require (yamlls
	-- fetches the same catalog itself via schemaStore.url above)
	{ "b0o/SchemaStore.nvim", lazy = true, version = false },

	-- LSPConfig: LSP server configurations
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- lua_ls: teach it the Neovim runtime. Without this it flags `vim` as an
			-- undefined global on every line of this config. Library is scoped to
			-- $VIMRUNTIME + luv (not the whole lazy plugin dir) to keep indexing fast.
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME .. "/lua",
								"${3rd}/luv/library",
							},
						},
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			-- jsonls: attach the SchemaStore catalog (Claude/Codex plugin manifests,
			-- package.json, tsconfig, ...). Without it jsonls only validates files that
			-- declare their own $schema. before_init defers loading the catalog until a
			-- JSON buffer actually starts the server.
			vim.lsp.config("jsonls", {
				before_init = function(_, config)
					config.settings.json.schemas = require("schemastore").json.schemas()
				end,
				settings = {
					json = { validate = { enable = true } },
				},
			})

			-- html: the server requests the `css` settings section and Neovim answers
			-- null for sections that aren't set, so CSS validation in <style> blocks
			-- throws ("reading 'validProperties'") on every pass and reports nothing.
			vim.lsp.config("html", {
				settings = {
					css = { validate = true },
				},
			})

			-- harper_ls: grammar checking for prose. Its lspconfig default covers 28
			-- filetypes, mostly code comments; keep it to docs and commit messages.
			-- SpellCheck is off because the markdown FileType autocmd enables vim spell,
			-- and two spellcheckers would double-flag every product name.
			-- userDictPath is a tracked word list, so SplitWords stops flagging names
			-- like "databricks" (→ "data bricks"); harper's "add to dictionary" code
			-- action appends to the same file.
			vim.lsp.config("harper_ls", {
				filetypes = { "markdown", "gitcommit" },
				settings = {
					["harper-ls"] = {
						userDictPath = vim.fn.stdpath("config") .. "/spell/harper-dict.txt",
						linters = { SpellCheck = false },
					},
				},
			})

			-- rust_analyzer's root_dir shells out to `rustc` to locate the sysroot and
			-- throws if no Rust toolchain is on PATH, forcing a "Press ENTER" error
			-- prompt on every .rs buffer. It's excluded from mason-lspconfig's
			-- automatic_enable above; enable it only when a toolchain is present, so it
			-- auto-activates on the next launch once rustc is installed.
			if vim.fn.executable("rustc") == 1 then
				vim.lsp.enable("rust_analyzer")
			end

			-- LSP keybindings (attached when LSP connects)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(ev)
					local opts = { buffer = ev.buf }

					-- Navigation. References / implementation / type definition use Neovim's
					-- built-in grr / gri / grt, so builtin gi (last insert) and gt (next tab) survive.
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("force", opts, { desc = "Go to definition" })
					)
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", opts, { desc = "Go to declaration" })
					)

					-- Documentation
					vim.keymap.set(
						"n",
						"K",
						vim.lsp.buf.hover,
						vim.tbl_extend("force", opts, { desc = "Hover documentation" })
					)
					vim.keymap.set(
						"n",
						"<C-k>",
						vim.lsp.buf.signature_help,
						vim.tbl_extend("force", opts, { desc = "Signature help" })
					)

					-- Actions
					vim.keymap.set(
						"n",
						"<Leader>rn",
						vim.lsp.buf.rename,
						vim.tbl_extend("force", opts, { desc = "Rename symbol" })
					)
					vim.keymap.set(
						{ "n", "v" },
						"<Leader>ca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "Code action" })
					)

					-- Diagnostics
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
					vim.keymap.set(
						"n",
						"<Leader>d",
						vim.diagnostic.open_float,
						vim.tbl_extend("force", opts, { desc = "Show diagnostic" })
					)
				end,
			})

			-- Diagnostic display configuration
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
				},
			})

			-- Filter marksman's noisy "Ambiguous link to document" warnings.
			-- Marksman's resolver matches the same on-disk file via multiple
			-- strategies (path + basename + frontmatter title) and reports
			-- ambiguity even when only one file exists. Harmless false positive.
			local orig_publish = vim.lsp.handlers["textDocument/publishDiagnostics"]
			vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
				if result and result.diagnostics and ctx and ctx.client_id then
					local client = vim.lsp.get_client_by_id(ctx.client_id)
					if client and client.name == "marksman" then
						result.diagnostics = vim.tbl_filter(function(d)
							return not (d.message and d.message:match("^Ambiguous link to document"))
						end, result.diagnostics)
					end
				end
				return orig_publish(err, result, ctx, config)
			end
		end,
	},
}
