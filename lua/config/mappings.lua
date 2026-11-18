local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = opts.noremap == nil and true or opts.noremap
	opts.silent = opts.silent == nil and true or opts.silent
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- Better up/down (handle wrapped lines)
vim.keymap.set({ "n", "x" }, "j", function()
	return vim.v.count > 0 and "j" or "gj"
end, { expr = true, desc = "Move down (wrap-aware)" })

vim.keymap.set({ "n", "x" }, "k", function()
	return vim.v.count > 0 and "k" or "gk"
end, { expr = true, desc = "Move up (wrap-aware)" })

-- Leader commands
map("n", "<Leader>w", ":write<CR>", { desc = "Write buffer" })
map("n", "<Leader>s", ":source %<CR>", { desc = "Source current file" })

-- System clipboard
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<Leader>Y", '"+y$', { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<Leader>P", '"+P', { desc = "Paste before from clipboard" })

-- Copy current file path to clipboard
map("n", "<Leader>cp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy absolute file path" })

map("n", "<Leader>cP", function()
	local path = vim.fn.expand("%:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path" })

map("n", "<Leader>cn", function()
	local name = vim.fn.expand("%:t")
	vim.fn.setreg("+", name)
	vim.notify("Copied: " .. name)
end, { desc = "Copy filename only" })

-- File explorer (nvim-tree)
map("n", "<Leader>t", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<Leader>e", ":NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- Fuzzy finder (fzf-lua)
map("n", "<Leader>f", function()
	require("fzf-lua").files({ fd_opts = "--color=never --type f --hidden --no-ignore --exclude .git" })
end, { desc = "Find files" })

map("n", "<Leader>g", function()
	require("fzf-lua").live_grep()
end, { desc = "Live grep" })

map("n", "<Leader>G", function()
	require("fzf-lua").grep_curbuf()
end, { desc = "Grep Current Buff" })

map("n", "<Leader>h", function()
	require("fzf-lua").help_tags()
end, { desc = "Search help tags" })

map("n", "<Leader>H", function()
	require("fzf-lua").keymaps()
end, { desc = "Search keymaps" })

map("n", "<Leader>v", function()
	require("fzf-lua").files({ cwd = "~/.config/nvim" })
end, { desc = "Find nvim config files" })

map("n", "<Leader>b", function()
	require("fzf-lua").buffers()
end, { desc = "Find buffers" })

map("n", "<Leader>R", function()
	require("fzf-lua").oldfiles()
end, { desc = "Recent files" })

map("n", "<Leader>cd", function()
	require("fzf-lua").zoxide()
end, { desc = "Change directory (zoxide)" })

-- Search and replace (grug-far). From visual mode grug-far prefills the search with the
-- selection; the files filter starts as this file's extension (e.g. *.md for doc sweeps)
map({ "n", "x" }, "<Leader>sr", function()
	local ext = vim.bo.buftype == "" and vim.fn.expand("%:e") or ""
	require("grug-far").open({ transient = true, prefills = { filesFilter = ext ~= "" and "*." .. ext or nil } })
end, { desc = "Search and replace (project)" })

-- Jump (flash.nvim). Overrides built-in s/S (use cl/cc instead)
map({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Flash jump" })
map({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Treesitter select" })
map("o", "r", function()
	require("flash").remote()
end, { desc = "Flash remote" })
map({ "o", "x" }, "R", function()
	require("flash").treesitter_search()
end, { desc = "Flash Treesitter search" })
map("c", "<C-s>", function()
	require("flash").toggle()
end, { desc = "Toggle Flash in / search" })

-- Markdown
map("n", "<Leader>mr", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown rendering" })
map("n", "<Leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle browser markdown preview" })
map("n", "<Leader>ml", function()
	-- Serve from cwd when the file is under it (keeps ../ links working); otherwise
	-- root at the file's dir, or the plugin builds a URL of /nil.
	local cfg = require("livepreview.config").config
	local file = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
	local cwd = vim.fs.normalize(vim.uv.cwd() or "") .. "/"
	cfg.dynamic_root = file:sub(1, #cwd) ~= cwd
	vim.cmd("LivePreview start")
end, { desc = "Live preview (browser, md/html/adoc/svg)" })
map("n", "<Leader>mL", "<cmd>LivePreview close<cr>", { desc = "Live preview: stop server" })
-- Read this file in mdd (mddog) in a floating Rex pane; q quits mdd and closes the pane.
-- Rex's CLI only tiles, so this calls the session.new_layer API, with the bounds that
-- ~/.config/rex/zellij.lua gives new floats. Saves first: mdd reads the file from disk
map("n", "<Leader>md", function()
	local file = vim.api.nvim_buf_get_name(0)
	local session, block = vim.env.REX_SESSION, vim.env.REX_BLOCK
	if vim.fn.filereadable(file) == 0 then
		vim.notify("Buffer is not a file on disk", vim.log.levels.WARN)
		return
	elseif not (session and block and vim.fn.executable("rex") == 1) then
		vim.notify("Not in a Rex pane, so there's nowhere to float mdd", vim.log.levels.WARN)
		return
	end
	vim.cmd("silent update")
	local function rex(args, on_ok)
		vim.system(
			vim.list_extend({ "rex" }, args),
			{ text = true },
			vim.schedule_wrap(function(res)
				if res.code ~= 0 then
					vim.notify("mdd float: " .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
				elseif on_ok then
					on_ok(res.stdout)
				end
			end)
		)
	end
	-- Float over the tab holding this pane, which may not be the session's active tab
	rex({ "block", "inspect", "-s", session, block, "--json" }, function(out)
		-- A new Rex block reads as 80x24 cells of 8x16 px until the app sizes it, and mdd up to 1.0.5
		-- counts its font zoom from the first size it reads, so the page drew 2.5x too big. sh holds mdd
		-- back until the size is real, or about 2 s pass. Upstream fix: qu8n/mddog e8d8f8fc (unreleased
		-- as of 2026-11-17); drop the wait once a release has it
		local wait = 'i=0; while [ "$(stty size)" = "24 80" ] && [ $i -lt 100 ]; do sleep 0.02; i=$((i + 1)); done'
		local layer = {
			window_id = vim.json.decode(out).block.window_id,
			bounds = { 0.1, 0.1, 0.8, 0.8 },
			focus = true,
			layout = {
				block = {
					flavor = "com.superlogical.terminal.shell",
					label = "mdd",
					options = {
						command = { "sh", "-c", wait .. '; exec mdd "$1"', "mdd", file },
						cwd = vim.fs.dirname(file),
					},
				},
			},
		}
		rex({ "api", "call", "-s", session, "session.new_layer", vim.json.encode(layer) })
	end)
end, { desc = "Read in mdd (floating Rex pane)" })
map("n", "<Leader>mt", function()
	require("fzf-lua").lsp_document_symbols()
end, { desc = "Document symbols / TOC" })
map("n", "<Leader>mc", function()
	local callouts = {
		"NOTE",
		"TIP",
		"IMPORTANT",
		"WARNING",
		"CAUTION",
		"info",
		"success",
		"question",
		"failure",
		"danger",
		"bug",
		"example",
		"quote",
		"abstract",
	}
	vim.ui.select(callouts, { prompt = "Callout type:" }, function(choice)
		if not choice then
			return
		end
		vim.api.nvim_put({ "> [!" .. choice .. "]", "> " }, "l", true, true)
		vim.cmd("startinsert!")
	end)
end, { desc = "Insert markdown callout" })

-- Writing (snacks.nvim)
map("n", "<Leader>z", function()
	require("snacks").zen()
end, { desc = "Zen mode" })
map("n", "<Leader>.", function()
	require("snacks").scratch()
end, { desc = "Toggle scratch buffer" })
map("n", "<Leader>S", function()
	require("snacks").scratch.select()
end, { desc = "Select scratch buffer" })

-- Secrets (camouflage.nvim). Everyday policy masks secrets only; demo mode masks every
-- parsed value and locks reveals, since :CamouflagePresent alone keeps the policy
map("n", "<Leader>kt", "<cmd>CamouflageToggle<cr>", { desc = "Toggle secret masking" })
map("n", "<Leader>kr", "<cmd>CamouflageReveal<cr>", { desc = "Reveal secrets on this line" })
map("n", "<Leader>kp", function()
	require("camouflage.config").set("policy.default_action", "mask")
	vim.cmd("CamouflagePresent")
end, { desc = "Demo mode on (mask all values)" })
map("n", "<Leader>kP", function()
	require("camouflage.config").set("policy.default_action", "ignore")
	vim.cmd("CamouflagePresent!")
end, { desc = "Demo mode off" })

-- Unified diff
map("n", "<Leader>ud", "<cmd>Unified<cr>", { desc = "Diff against HEAD" })
map("n", "<Leader>ur", "<cmd>Unified reset<cr>", { desc = "Close diff view" })

-- Diffview
map("n", "<Leader>dv", "<cmd>DiffviewOpen<cr>", { desc = "Diffview: open" })
map("n", "<Leader>dc", "<cmd>DiffviewClose<cr>", { desc = "Diffview: close" })
map("n", "<Leader>dh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview: repo file history" })
map("n", "<Leader>df", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview: current file history" })

-- Git / GitHub (snacks.nvim)
map("n", "<Leader>op", function()
	require("snacks").picker.gh_pr()
end, { desc = "GitHub PRs (open)" })
map("n", "<Leader>oP", function()
	require("snacks").picker.gh_pr({ state = "all" })
end, { desc = "GitHub PRs (all)" })
map("n", "<Leader>oi", function()
	require("snacks").picker.gh_issue()
end, { desc = "GitHub issues (open)" })
map("n", "<Leader>oI", function()
	require("snacks").picker.gh_issue({ state = "all" })
end, { desc = "GitHub issues (all)" })
map({ "n", "x" }, "<Leader>ob", function()
	require("snacks").gitbrowse()
end, { desc = "Open file/selection on GitHub" })
map({ "n", "x" }, "<Leader>ol", function()
	-- Permalink pins the URL to the last commit that touched this file: it resolves once
	-- that commit is pushed, and line numbers follow the committed version of the file
	require("snacks").gitbrowse({
		what = "permalink",
		notify = false,
		open = function(url)
			vim.fn.setreg("+", url)
			vim.notify("Copied: " .. url)
		end,
	})
end, { desc = "Copy GitHub permalink" })
map("n", "<Leader>og", function()
	require("snacks").lazygit()
end, { desc = "Lazygit" })

-- Buffer navigation
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<Leader>x", function()
	if vim.bo.modified then
		vim.notify("Buffer has unsaved changes. Save or use :bdelete!", vim.log.levels.WARN)
	else
		vim.cmd("bdelete")
	end
end, { desc = "Close buffer" })

-- Claude Code
map("n", "<Leader>ac", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude" })
map("n", "<Leader>af", "<cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude" })
map("n", "<Leader>ar", "<cmd>ClaudeCode --resume<CR>", { desc = "Resume Claude" })
map("n", "<Leader>aC", "<cmd>ClaudeCode --continue<CR>", { desc = "Continue Claude" })
map("n", "<Leader>am", "<cmd>ClaudeCodeSelectModel<CR>", { desc = "Select Claude model" })
-- Lua API instead of `ClaudeCodeAdd %`: the command splits its args on whitespace,
-- so paths with spaces fail with "Too many arguments" (coder/claudecode.nvim#314)
map("n", "<Leader>ab", function()
	local path = vim.api.nvim_buf_get_name(0)
	if vim.fn.filereadable(path) == 0 then
		vim.notify("Buffer is not a file on disk", vim.log.levels.WARN)
		return
	end
	require("claudecode").send_at_mention(path, nil, nil, "ClaudeCodeAdd")
end, { desc = "Add buffer to Claude" })
map("v", "<Leader>as", "<cmd>ClaudeCodeSend<CR>", { desc = "Send selection to Claude" })
map("n", "<Leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept Claude diff" })
map("n", "<Leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny Claude diff" })

-- Terminal window navigation (escape terminal mode + move)
map("t", "<C-w>h", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
map("t", "<C-w>j", "<C-\\><C-n><C-w>j", { desc = "Move to below window" })
map("t", "<C-w>k", "<C-\\><C-n><C-w>k", { desc = "Move to above window" })
map("t", "<C-w>l", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })
