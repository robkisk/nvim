return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	event = "VeryLazy",
	opts = {
		-- Claude startup (MCP servers + SessionStart hooks) outlasts the 5s/10s defaults,
		-- so mentions queued by <Leader>ab before the IDE handshake were silently dropped
		connection_timeout = 30000,
		queue_timeout = 30000,
		terminal = {
			split_side = "right",
			split_width_percentage = 0.40,
			cwd_provider = function(ctx)
				local start = ctx.file_dir or ctx.cwd
				local mcp = vim.fs.find(".mcp.json", { upward = true, path = start, type = "file" })[1]
				if mcp then
					return vim.fn.fnamemodify(mcp, ":h")
				end
				local git = vim.fs.find(".git", { upward = true, path = start })[1]
				if git then
					return vim.fn.fnamemodify(git, ":h")
				end
				return ctx.cwd
			end,
		},
	},
}
