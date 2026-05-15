return {
	"brianhuster/live-preview.nvim",
	cmd = "LivePreview",
	config = function()
		require("livepreview.config").set({
			port = 5500,
			browser = "default",
			dynamic_root = false,
			sync_scroll = true,
			picker = "fzf-lua",
		})
	end,
}
