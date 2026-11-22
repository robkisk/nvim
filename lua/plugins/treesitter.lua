return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		init = function()
			-- No zsh grammar exists in nvim-treesitter; map zsh buffers to the
			-- bash parser so highlighting, folds, AND `=` indent queries resolve.
			-- Without this, indentexpr() finds no query for `zsh` and `=` no-ops.
			vim.treesitter.language.register("bash", "zsh")
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				callback = function(ev)
					local ft = vim.bo[ev.buf].filetype
					local lang = vim.treesitter.language.get_lang(ft)
					if not lang then
						return
					end
					-- pcall: query.get asserts the parser loads (queries without a parser)
					local function has_query(name)
						local ok, query = pcall(vim.treesitter.query.get, lang, name)
						return ok and query ~= nil
					end
					-- Start only when the language ships a highlights query. start()
					-- turns regex syntax off, so starting on a parser that has no
					-- queries leaves the buffer with no highlighting at all.
					if has_query("highlights") then
						pcall(vim.treesitter.start, ev.buf, lang)
					end
					-- Only take over indent when the language ships an indents query.
					-- Otherwise indentexpr() returns -1 and clobbers runtime indent
					-- scripts (make, just) with plain autoindent.
					if ft ~= "yaml" and has_query("indents") then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
		config = function()
			local ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"python",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"xml",
				"toml",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"sql",
				"rust",
				"terraform",
				"hcl",
				"gitcommit",
				"git_config",
				"git_rebase",
				"diff",
				"make",
				"ssh_config",
				"ini",
				"regex",
			}
			local installed = require("nvim-treesitter.config").get_installed()
			local to_install = vim.iter(ensure_installed)
				:filter(function(parser)
					return not vim.tbl_contains(installed, parser)
				end)
				:totable()
			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end
		end,
	},

	-- Its own spec, not a dependency of nvim-treesitter: on the main branch its plugin/ file
	-- only hooks the removed module system, so autotag does nothing until setup() runs
	-- (opts makes lazy call it). Loads before the first FileType, so that buffer gets it too.
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- Off in markdown, which autotag treats as HTML: typing `<Leader>x` or `<CR>` in prose,
			-- even inside a code span, got a closing `</Leader>` appended
			per_filetype = { markdown = { enable_close = false, enable_rename = false } },
		},
	},
}
