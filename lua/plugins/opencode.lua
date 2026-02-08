return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		{
			"folke/snacks.nvim",
			opts = { input = {}, picker = {}, terminal = {} },
		},
	},
	keys = {
		{
			"<C-a>",
			function()
				local oc = require("opencode")
				oc.start()
				oc.ask("@this: ", { submit = true })
			end,
			mode = { "n", "x" },
			desc = "Ask opencode",
		},
		{
			"<C-x>",
			function()
				require("opencode").select()
			end,
			mode = { "n", "x" },
			desc = "Execute opencode action",
		},
		{
			"<C-.>",
			function()
				require("opencode").toggle()
			end,
			mode = { "n", "t" },
			desc = "Toggle opencode",
		},
		{
			"go",
			function()
				return require("opencode").operator("@this ")
			end,
			mode = { "n", "x" },
			desc = "Add range to opencode",
			expr = true,
		},
		{
			"<leader>af",
			function()
				require("opencode").prompt("fix")
			end,
			mode = { "n", "x" },
			desc = "Fix diagnostics",
		},
		{
			"<leader>ae",
			function()
				require("opencode").prompt("explain")
			end,
			mode = { "n", "x" },
			desc = "Explain code",
		},
		{
			"<leader>at",
			function()
				require("opencode").prompt("test")
			end,
			mode = { "n", "x" },
			desc = "Generate tests",
		},
		{
			"<leader>ar",
			function()
				require("opencode").prompt("review")
			end,
			mode = { "n", "x" },
			desc = "Review code",
		},
		{
			"<leader>ad",
			function()
				require("opencode").prompt("document")
			end,
			mode = { "n", "x" },
			desc = "Document code",
		},
	},
	init = function()
		vim.o.autoread = true
		vim.api.nvim_create_autocmd("User", {
			pattern = "OpencodeEvent:session.idle",
			callback = function()
				vim.notify("OpenCode finished", vim.log.levels.INFO)
			end,
		})
	end,
}
