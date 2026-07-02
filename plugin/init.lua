vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Precheck dependencies
		local ok_gw, gw = pcall(require, "git-worktree")
		local ok_oil, oil = pcall(require, "oil")

		if not ok_gw or not ok_oil then
			vim.notify("Skipped bare repo auto‑open: missing plugins (git-worktree, oil)", vim.log.levels.INFO)
			return
		end
		-- TODO: This is a bit buggy, since it won't set the worktree correctly
		-- if the file is opened directly, but that's not a problem often
		if not vim.api.nvim_buf_get_name(0):match("^oil://") then
			vim.notify("Skipped bare repo auto‑open: not an oil buffer", vim.log.levels.INFO)
			return
		end

		-- Confirm we’re inside a bare repo
		local is_bare = vim.fn.systemlist("git rev-parse --is-bare-repository")[1]
		if is_bare ~= "true" then
			-- Not a bare repo → do nothing
			return
		end

		-- Get the HEAD symbolic reference (default branch of bare repo)
		local main_branch = vim.fn.systemlist("git symbolic-ref --short HEAD")[1]
		if not main_branch or main_branch == "" then
			vim.notify("Could not determine main branch", vim.log.levels.WARN)
			return
		end

		-- Gather all known worktrees
		local lines = vim.fn.systemlist("git worktree list --porcelain")
		if #lines == 0 then
			vim.notify("No worktrees found", vim.log.levels.WARN)
			return
		end

		local worktrees = {}
		local current = {}

		for _, line in ipairs(lines) do
			if vim.startswith(line, "worktree ") then
				-- starting a new block
				if current.path then
					table.insert(worktrees, current)
				end
				current = { path = line:match("^worktree%s+(.+)$") }
			elseif vim.startswith(line, "branch ") then
				current.branch = line:match("^branch%s+refs/heads/(.+)$") or line:match("^branch%s+(.+)$")
			end
		end
		if current.path then
			table.insert(worktrees, current)
		end

		-- Find matching worktree based on the detected branch name
		local main_wt
		for _, wt in ipairs(worktrees) do
			if wt.branch == main_branch then
				main_wt = wt
				break
			end
		end

		if not main_wt then
			vim.notify("No worktree found for branch '" .. main_branch .. "'", vim.log.levels.WARN)
			return
		end

		-- Switch to the discovered main worktree
		gw.switch_worktree(main_wt.path)
	end,
})
