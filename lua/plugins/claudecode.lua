return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	event = "VeryLazy",
	opts = {
		terminal = {
			split_side = "right",
			split_width_percentage = 0.40,
		},
	},
}
