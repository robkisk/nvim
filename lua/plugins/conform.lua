return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<Leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format" },
			go = { "goimports" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			markdown = { "prettier" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			sql = { "sqlfluff" },
		},
		format_on_save = function(bufnr)
			local ft = vim.bo[bufnr].filetype
			-- Skip mixed-content SQL files (Databricks Metric View YAML in .sql,
			-- Genie demo pattern) — sqlfluff can't parse YAML and always errors.
			if ft == "sql" then
				for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 500, false)) do
					if
						line:match("^source:")
						or line:match("^measures:")
						or line:match("^dimensions:")
						or line:match("^joins:")
					then
						return false
					end
				end
			end
			local slow_filetypes = { sql = 2000 }
			return {
				timeout_ms = slow_filetypes[ft] or 500,
				lsp_format = "fallback",
			}
		end,
		formatters = {
			prettier = {
				prepend_args = { "--ignore-path", "/dev/null" },
			},
			ruff_format = {
				prepend_args = { "--no-respect-gitignore" },
			},
			ruff_organize_imports = {
				prepend_args = { "--no-respect-gitignore" },
			},
			sqlfluff = {
				args = { "fix", "--dialect", "databricks", "-" },
				require_cwd = false,
			},
		},
	},
}
