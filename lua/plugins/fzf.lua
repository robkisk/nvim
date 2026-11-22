return {
	"ibhagwan/fzf-lua",
	-- Not at startup: mappings.lua requires it on first use, and :FzfLua loads it too
	cmd = "FzfLua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	init = function()
		-- Hand vim.ui.select to fzf-lua on first use, so startup doesn't load fzf-lua just to
		-- register it. silent: a caller holding this shim would otherwise hit "already registered"
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.select = function(...)
			require("fzf-lua").register_ui_select(nil, true)
			return vim.ui.select(...)
		end
	end,
}
