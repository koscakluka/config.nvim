return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", function()
				for winnr = 1, vim.fn.winnr("$") do
					if vim.fn.getwinvar(winnr, "fugitive_status") ~= "" then
						vim.cmd(winnr .. "close")
						return
					end
				end
				vim.cmd("keepalt vert Git | vertical resize 65")
				-- vim.cmd("tab Git")
			end)
			vim.keymap.set("n", "<leader>gm", "<CMD>Git rebase main<CR>")
		end,
	},
	{
		"polarmutex/git-worktree.nvim",
		-- HACK: This is here until the hotfix gets versioned
		branch = "main",
		-- version = "^2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local Path = require("plenary.path")
			local Hooks = require("git-worktree.hooks")
			Hooks.register(Hooks.type.SWITCH, function(_, prev_path)
				local config = require("git-worktree.config")
				local update_cmd = function()
					vim.cmd(config.update_on_change_command)
				end
				if prev_path == nil then
					update_cmd()
					return
				end

				local cwd = vim.loop.cwd()
				local current_buf_name = vim.api.nvim_buf_get_name(0)
				if not current_buf_name or current_buf_name == "" then
					update_cmd()
					return
				end

				local is_oil = false
				if current_buf_name:match("^oil://") then
					is_oil = true
					current_buf_name = current_buf_name:sub(7)
				end

				-- check if current buffer is already in the current directory
				local name = Path:new(current_buf_name):absolute()
				local start1, _ = string.find(name, cwd .. Path.path.sep, 1, true)
				if start1 ~= nil then
					return
				end

				-- check if the buffer is part of the current git worktree or
				-- if we went above the root
				local start, fin = string.find(name, prev_path, 1, true)
				if start == nil then
					update_cmd()
					return
				end

				local local_name = name:sub(fin + 2)

				local final_path = Path:new({ cwd, local_name }):absolute()

				if not Path:new(final_path):exists() then
					-- TODO: Open the closest parent maybe?
					update_cmd()
					return
				end

				if is_oil then
					vim.cmd("Oil " .. final_path)
					return
				end

				local bufnr = vim.fn.bufnr(final_path, true)
				vim.api.nvim_set_current_buf(bufnr)
			end)

			require("telescope").load_extension("git_worktree")
			vim.keymap.set(
				"n",
				"<leader>gw",
				"<CMD> lua require('telescope').extensions.git_worktree.git_worktree()<CR>"
			)
			vim.keymap.set(
				"n",
				"<leader>gn",
				"<CMD> lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>"
			)
		end,
	},

	-- NOTE: I am not using GitHub at all from the cmd, but I soon will, so then this
	--       will be uncommented
	-- "tpope/vim-rhubarb",

	-- Adds git related signs to the gutter, as well as utilities for managing changes
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Jump to next hunk" })

				map({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Jump to previous hunk" })

				-- Actions
				-- visual mode
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "stage git hunk" })
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "reset git hunk" })
				-- normal mode
				map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
				map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "git Reset buffer" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })
				map("n", "<leader>hb", function()
					gs.blame_line({ full = false, ignore_whitespace = true })
				end, { desc = "git blame line" })
				map("n", "<leader>hd", gs.diffthis, { desc = "git diff against index" })
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, { desc = "git diff against last commit" })

				-- Toggles
				map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
				map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
			end,
		},
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	{
	  "pwntester/octo.nvim",
	  cmd = "Octo",
	  opts = {
		-- or "fzf-lua" or "snacks" or "default"
		picker = "telescope",
		-- bare Octo command opens picker of commands
		enable_builtin = true,
	  },
	  keys = {
		{
		  "<leader>oi",
		  "<CMD>Octo issue list<CR>",
		  desc = "List GitHub Issues",
		},
		{
		  "<leader>op",
		  "<CMD>Octo pr list<CR>",
		  desc = "List GitHub PullRequests",
		},
		{
		  "<leader>od",
		  "<CMD>Octo discussion list<CR>",
		  desc = "List GitHub Discussions",
		},
		{
		  "<leader>on",
		  "<CMD>Octo notification list<CR>",
		  desc = "List GitHub Notifications",
		},
		{
		  "<leader>os",
		  function()
			require("octo.utils").create_base_search_command { include_current_repo = true }
		  end,
		  desc = "Search GitHub",
		},
	  },
	  dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		-- OR "ibhagwan/fzf-lua",
		-- OR "folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons",
	  },
	},
}
