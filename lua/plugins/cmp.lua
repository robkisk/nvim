return {
	-- Snippet engine
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		lazy = true, -- loaded by nvim-cmp on InsertEnter; was ~15ms of startup
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = { vim.fn.stdpath("config") .. "/snippets" },
			})
		end,
	},

	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				-- cmp's own defaults, plus no completion in buffers where camouflage masked a value
				-- (the buffer source would offer the hidden text). This replaces camouflage's cmp
				-- integration, which required cmp on every file read and so loaded nvim-cmp and
				-- LuaSnip at startup instead of on InsertEnter.
				enabled = function()
					if vim.bo.buftype == "prompt" or vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= "" then
						return false
					end
					local camouflage = package.loaded["camouflage.state"]
					return not (camouflage and camouflage.is_buffer_masked())
				end,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{
						name = "path",
						option = {
							get_cwd = function(params)
								local buf_dir = vim.fn.expand(("#%d:p:h"):format(params.context.bufnr))
								if buf_dir:match("^/private/tmp") or buf_dir:match("^/tmp") then
									return vim.env.PWD or buf_dir
								end
								return buf_dir
							end,
						},
					},
				}),
			})

			-- Snippet navigation keymaps (insert and select mode)
			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { desc = "Snippet jump forward", silent = true })

			-- expr, so <C-h> stays a backspace (and Ctrl-Backspace, which often sends it, keeps
			-- working) when there's no snippet to jump back to
			vim.keymap.set({ "i", "s" }, "<C-h>", function()
				return luasnip.jumpable(-1) and "<cmd>lua require('luasnip').jump(-1)<cr>" or "<C-h>"
			end, { expr = true, desc = "Snippet jump backward", silent = true })
		end,
	},

	-- Register cmp-nvim-lsp capabilities for all LSP servers
	{
		"hrsh7th/cmp-nvim-lsp",
		config = function()
			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
		end,
	},
}
