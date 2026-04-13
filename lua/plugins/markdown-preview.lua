return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = "cd app && npm install && git checkout -- yarn.lock",
	init = function()
		vim.g.mkdp_theme = "light"
		vim.g.mkdp_markdown_css = vim.fn.expand("~/.config/nvim/styles/databricks-markdown.css")
	end,
}
