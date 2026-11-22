return {
	"MeanderingProgrammer/render-markdown.nvim",
	-- cmd, not ft: rendering starts off (<Leader>mr runs :RenderMarkdown toggle), and the
	-- plugin attaches to the current buffer when it loads. On ft it also loaded nvim-cmp (it
	-- registers a cmp source this config doesn't use) and hit the FileType replay in autolist.lua
	cmd = "RenderMarkdown",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-mini/mini.icons",
	},
	opts = {
		enabled = false,
	},
}
