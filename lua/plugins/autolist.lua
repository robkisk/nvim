local filetypes = { "markdown", "text", "gitcommit" }

return {
	"gaoDean/autolist.nvim",
	-- BufReadPre/BufNewFile, not ft. Loading a plugin on ft makes lazy replay every FileType
	-- autocmd, which re-runs the markdown ftplugin: its undo stops treesitter, and stopping it
	-- loads the regex markdown syntax (~40ms) only to drop it again. Loading before the first
	-- FileType still gives that buffer the maps below. Don't lazy-load anything on markdown.
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local autolist = require("autolist")
		autolist.setup({
			-- Only "- item:" lines open a nested list. With indent_raw, any line ending in ":" gets
			-- an indented bullet, which CommonMark reads as part of the paragraph above at 4 spaces
			colon = { indent_raw = false },
			-- autolist ships no gitcommit lists; reuse its markdown/text markers (- + *, 1., a), I.)
			lists = { gitcommit = { "[-+*]", "%d+[.)]", "%a[.)]", "%u+[.)]" } },
		})

		-- AutolistRecalculate leaves the cursor at end of line; renumber without moving it
		local function renumber()
			local cursor = vim.api.nvim_win_get_cursor(0)
			autolist.recalculate()
			vim.api.nvim_win_set_cursor(0, cursor)
		end

		-- Same list-item test autolist's own AutolistTab makes
		local function on_list_item()
			local lists = require("autolist.config").lists[vim.bo.filetype]
			return require("autolist.utils").is_list(vim.api.nvim_get_current_line(), lists)
		end

		-- Buffer-local, so <CR>, o, dd and friends stay stock everywhere else
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("UserAutolist", { clear = true }),
			pattern = filetypes,
			callback = function(ev)
				vim.api.nvim_buf_create_user_command(ev.buf, "AutolistRenumber", renumber, {
					desc = "Renumber the list under the cursor without moving it",
				})
				local function map(mode, lhs, rhs, desc, opts)
					opts = vim.tbl_extend("force", { buffer = ev.buf, silent = true, desc = desc }, opts or {})
					vim.keymap.set(mode, lhs, rhs, opts)
				end

				map("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>", "Newline, continue list")
				map("i", "<C-CR>", "<CR>", "Newline without bullet")
				map("n", "o", "o<cmd>AutolistNewBullet<cr>", "Open line below, continue list")
				map("n", "O", "O<cmd>AutolistNewBulletBefore<cr>", "Open line above, continue list")
				map("n", "<Leader>X", "<cmd>AutolistToggleCheckbox<cr>", "Toggle checkbox")
				map("n", "gN", renumber, "Renumber list")
				map("x", "gN", "<Esc><cmd>AutolistRenumber<cr>", "Renumber list")

				-- Indent, dedent, and delete, then renumber. Not on <CR>/o/O: renumbering trims
				-- the trailing space off a new "- [ ] " item, so typing lands against the "]"
				map("i", "<C-t>", "<C-t><cmd>AutolistRenumber<cr>", "Indent list item")
				map("i", "<C-d>", "<C-d><cmd>AutolistRenumber<cr>", "Dedent list item")
				-- Tab/S-Tab, the keys autolist's README maps, indent too; off a list item they stay stock
				map("i", "<Tab>", function()
					return on_list_item() and "<C-t><cmd>AutolistRenumber<cr>" or "<Tab>"
				end, "Indent list item", { expr = true })
				map("i", "<S-Tab>", function()
					return on_list_item() and "<C-d><cmd>AutolistRenumber<cr>" or "<S-Tab>"
				end, "Dedent list item", { expr = true })
				map("n", ">>", ">><cmd>AutolistRenumber<cr>", "Indent list item")
				map("n", "<<", "<<<cmd>AutolistRenumber<cr>", "Dedent list item")
				map("x", ">", "><cmd>AutolistRenumber<cr>", "Indent list items")
				map("x", "<", "<<cmd>AutolistRenumber<cr>", "Dedent list items")
				map("n", "dd", "dd<cmd>AutolistRenumber<cr>", "Delete line, renumber list")
				map("x", "d", "d<cmd>AutolistRenumber<cr>", "Delete, renumber list")
			end,
		})
	end,
}
