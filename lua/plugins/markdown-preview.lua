return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- Not ft = "markdown" (see autolist.lua). Its commands are buffer-local and defined on
	-- FileType, so it has to load before the first markdown buffer's FileType fires.
	event = { "BufReadPre", "BufNewFile" },
	build = "cd app && npm install && git checkout -- yarn.lock",
	init = function()
		vim.g.mkdp_theme = "light"
		vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/styles/databricks-markdown.css")
	end,
}
