return {
	"ravsii/tree-sitter-d2",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	version = "*",
	build = "make nvim-install",
	-- The plugin starts treesitter in its own FileType autocmd without a pcall, so every .d2
	-- buffer errors until the parser exists. Install it here, not in treesitter.lua's
	-- ensure_installed: that runs before this plugin's plugin/ file registers the TSUpdate hook
	-- that makes "d2" installable, and lazy runs this config after the plugin/ file.
	config = function()
		if not vim.list_contains(require("nvim-treesitter.config").get_installed(), "d2") then
			require("nvim-treesitter").install({ "d2" })
		end
	end,
}
