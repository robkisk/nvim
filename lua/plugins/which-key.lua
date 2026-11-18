return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- Groups go in which-key's own spec; lazy's `keys` ignores `group`.
		-- Every multi-key <Leader> prefix needs a name here, or the popup shows "+N keymaps".
		spec = {
			{ "<leader>a", group = "AI (Claude Code)" },
			{ "<leader>c", group = "Code / copy path / cd" },
			{ "<leader>d", group = "Diffview / diagnostic" },
			{ "<leader>k", group = "Secrets (camouflage)" },
			{ "<leader>m", group = "Markdown preview" },
			{ "<leader>o", group = "Git / GitHub" },
			{ "<leader>s", group = "Source file / replace / emoji" },
			{ "<leader>u", group = "Unified diff" },
		},
	},
	keys = {
		{
			"<Leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps",
		},
	},
}
