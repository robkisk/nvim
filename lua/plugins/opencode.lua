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
				-- Find the opencode terminal window
				local oc_win = nil
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].buftype == "terminal" then
						local name = vim.api.nvim_buf_get_name(buf)
						if name:find("opencode") then
							oc_win = win
							break
						end
					end
				end

				if vim.fn.mode() == "t" then
					-- In terminal mode: go back to previous editor window
					vim.cmd([[stopinsert]])
					vim.cmd([[wincmd p]])
				elseif oc_win and vim.api.nvim_win_is_valid(oc_win) then
					if vim.api.nvim_get_current_win() == oc_win then
						-- In the terminal window but normal mode: enter terminal mode
						vim.cmd("startinsert")
					else
						-- Terminal visible but unfocused: focus it and enter terminal mode
						vim.api.nvim_set_current_win(oc_win)
						vim.cmd("startinsert")
					end
				else
					-- Terminal not visible: toggle it open
					require("opencode").toggle()
				end
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
		{
			"<leader>af",
			function()
				require("opencode").prompt("fix")
			end,
			mode = { "n", "x" },
			desc = "Fix diagnostics",
		},
		{
			"<leader>ae",
			function()
				require("opencode").prompt("explain")
			end,
			mode = { "n", "x" },
			desc = "Explain code",
		},
		{
			"<leader>at",
			function()
				require("opencode").prompt("test")
			end,
			mode = { "n", "x" },
			desc = "Generate tests",
		},
		{
			"<leader>ar",
			function()
				require("opencode").prompt("review")
			end,
			mode = { "n", "x" },
			desc = "Review code",
		},
		{
			"<leader>ad",
			function()
				require("opencode").prompt("document")
			end,
			mode = { "n", "x" },
			desc = "Document code",
		},
		{
			"<leader>an",
			function()
				require("opencode").command("session.new")
			end,
			desc = "New session",
		},
	},
	init = function()
		vim.o.autoread = true
		vim.api.nvim_create_autocmd("User", {
			pattern = "OpencodeEvent:session.idle",
			callback = function()
				vim.notify("OpenCode finished", vim.log.levels.INFO)
			end,
		})
	end,
}
