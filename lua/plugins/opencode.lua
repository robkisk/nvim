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
	},
	init = function()
		vim.o.autoread = true
	end,
}
