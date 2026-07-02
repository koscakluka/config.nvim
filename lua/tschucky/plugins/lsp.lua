return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP
			{ "j-hui/fidget.nvim", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",
		},
		keys = {
			{
				"<leader>cr",
				function()
					vim.lsp.buf.rename()
				end,
				desc = "[V}ariable [R]e[n]ame",
			},
			{
				"<leader>ca",
				function()
					vim.lsp.buf.code_action()
				end,
				desc = "[V}ariable [C]ode [A]ction",
			},
			{ "gd", require("telescope.builtin").lsp_definitions, desc = "[G]oto [D]efinition" },
			{ "gr", require("telescope.builtin").lsp_references, desc = "[G]oto [R]eferences" },
			{ "gI", require("telescope.builtin").lsp_implementations, desc = "[G]oto [I]mplementation" },
			{ "<leader>gt", require("telescope.builtin").lsp_type_definitions, desc = "Type [D]efinition" },
			{ "<leader>ds", require("telescope.builtin").lsp_document_symbols, desc = "[D]ocument [S]ymbols" },
			{
				"<leader>ws",
				require("telescope.builtin").lsp_dynamic_workspace_symbols,
				desc = "[W]orkspace [S]ymbols",
			},
			{ "K", vim.lsp.buf.hover, desc = "Hover Documentation" },
			{ "<leader>k", vim.lsp.buf.signature_help, desc = "Signature Documentation" },
			{ "<leader>gD", vim.lsp.buf.declaration, desc = "[G]oto [D]eclaration" },
			{ "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "[W]orkspace [A]dd Folder" },
			{ "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "[W]orkspace [R]emove Folder" },
			{
				"<leader>wl",
				function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end,
				desc = "[W]orkspace [L]ist Folders",
			},
		},
		config = function()
			-- [[ Configure LSP ]]
			--  This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(_, bufnr)
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>cr",
				-- 	vim.lsp.buf.rename,
				-- 	{ buffer = bufnr, desc = "[V}ariable [R]e[n]ame" }
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>ca",
				-- 	vim.lsp.buf.code_action,
				-- 	{ buffer = bufnr, desc = "[V}ariable [C]ode [A]ction" }
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"gd",
				-- 	require("telescope.builtin").lsp_definitions,
				-- 	{ buffer = bufnr, desc = "[G]oto [D]efinition" }
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"gr",
				-- 	require("telescope.builtin").lsp_references,
				-- 	{ buffer = bufnr, desc = "[G]oto [R]eferences" }
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"gI",
				-- 	require("telescope.builtin").lsp_implementations,
				-- 	{ buffer = bufnr, desc = "[G]oto [I]mplementation" }
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>gt",
				-- 	require("telescope.builtin").lsp_type_definitions,
				-- 	{ buffer = bufnr, desc = "Type [D]efinition" }
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>ds",
				-- 	require("telescope.builtin").lsp_document_symbols,
				-- 	{ buffer = bufnr, desc = "[D]ocument [S]ymbols" }
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>ws",
				-- 	require("telescope.builtin").lsp_dynamic_workspace_symbols,
				-- 	{ buffer = bufnr, desc = "[W]orkspace [S]ymbols" }
				-- )
				--
				-- -- See `:help K` for why this keymap
				-- vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>k",
				-- 	vim.lsp.buf.signature_help,
				-- 	{ buffer = bufnr, desc = "Signature Documentation" }
				-- )
				--
				-- -- Lesser used LSP functionality
				-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[G]oto [D]eclaration" })
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>wa",
				-- 	vim.lsp.buf.add_workspace_folder,
				-- 	{ buffer = bufnr, desc = "[W]orkspace [A]dd Folder" }
				-- )
				-- vim.keymap.set(
				-- 	"n",
				-- 	"<leader>wr",
				-- 	vim.lsp.buf.remove_workspace_folder,
				-- 	{ buffer = bufnr, desc = "[W]orkspace [R]emove Folder" }
				-- )
				-- vim.keymap.set("n", "<leader>wl", function()
				-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				-- end, { buffer = bufnr, desc = "[W]orkspace [L]ist Folders" })

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					-- vim.api.nvim_command("EslintFixAll")
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })

				-- vim.api.nvim_create_autocmd("BufWritePre", {
				-- 	buffer = bufnr,
				-- 	command = "EslintFixAll",
				-- })
			end

			-- mason-lspconfig requires that these setup functions are called in this order
			-- before setting up the servers.
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettierd",
					"stylua",
					"isort",
					"black",
					"flake8",
					"eslint_d",
					"templ",
					"zls",
				},
			})

			-- local lspconfig = require("lspconfig")

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. They will be passed to
			--  the `settings` field of the server config. You must look up that documentation yourself.
			--
			--  If you want to override the default filetypes that your language server will attach to you can
			--  define the property 'filetypes' to the map in question.
			local function find_python_path(root_dir)
				for _, candidate in ipairs({
					".venv/bin/python",
					"venv/bin/python",
					".venv/Scripts/python.exe",
					"venv/Scripts/python.exe",
				}) do
					local python_path = vim.fs.joinpath(root_dir, candidate)
					if vim.uv.fs_stat(python_path) then
						return python_path
					end
				end
			end

			local pyright_root_markers = {
				"pyrightconfig.json",
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				".git",
			}

			local servers = {
				-- clangd = {},
				gopls = {
					gopls = {
						buildFlags = { "-tags=integration,ai,external" },
					},
				},
				-- rust_analyzer = {},
				pyright = {
					root_dir = function(bufnr, on_dir)
						local root_dir = vim.fs.root(bufnr, pyright_root_markers)
						if root_dir then
							on_dir(root_dir)
						end
					end,
					before_init = function(_, config)
						local python_path = find_python_path(config.root_dir)
						if not python_path then
							return
						end

						config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
							pythonPath = python_path,
						})
					end,
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic", -- basic
						},
					},
				},
				ts_ls = {
					filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				},
				astro = {
					filetypes = { "astro" },
					typescript = {},
				},
				eslint = {
					settings = {
						-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
						workingDirectory = { mode = "auto" },
					},
				},
				html = { filetypes = { "html", "twig", "hbs", "templ" } },
				tailwindcss = {
					filetypes = { "templ", "astro", "javascript", "typescript", "javascriptreact", "typescriptreact" },
					-- settings = {
					-- 	tailwindCSS = {
					-- 		includeLanguages = {
					-- 			templ = "html",
					-- 		},
					-- 	},
					-- },
				},
				templ = { "templ" },

				lua_ls = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = {
								"vim",
								"require",
							},
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
					-- Lua = {
					-- 	diagnostics = {
					-- 		globals = { "vim" }, -- tell the LSP that 'vim' is a valid global
					-- 	},
					-- 	workspace = {
					-- 		library = vim.api.nvim_get_runtime_file("", true), -- load Neovim runtime
					-- 		checkThirdParty = false,
					-- 	},
					-- 	telemetry = { enable = false },
					-- 	-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- 	-- diagnostics = { disable = { 'missing-fields' } },
					-- },
				},
				zls = {
					cmd = { "zls" },
					filetypes = { "zig", "zir" },
					-- root_dir = lspconfig.util.root_pattern("build.zig", ".git") or vim.loop.cwd,
					single_file_support = true,
				},
			}

			-- Setup neovim lua configuration
			require("neodev").setup()

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			local lsp_config_keys = {
				before_init = true,
				capabilities = true,
				cmd = true,
				cmd_env = true,
				filetypes = true,
				flags = true,
				handlers = true,
				init_options = true,
				on_attach = true,
				on_init = true,
				root_dir = true,
				root_markers = true,
				settings = true,
				single_file_support = true,
			}

			local function build_server_config(server)
				local config = {
					capabilities = capabilities,
					on_attach = on_attach,
				}
				local settings = {}

				for key, value in pairs(server or {}) do
					if lsp_config_keys[key] then
						config[key] = value
					else
						settings[key] = value
					end
				end

				if next(settings) ~= nil then
					config.settings = vim.tbl_deep_extend("force", config.settings or {}, settings)
				end

				return config
			end

			for server_name, server in pairs(servers) do
				vim.lsp.config(server_name, build_server_config(server))
			end

			-- Ensure the servers above are installed
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			-- vim: ts=2 sts=2 sw=2 et
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					svelte = { "prettier" },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					graphql = { "prettierd" },
					lua = { "stylua" },
					python = { "isort", "black" },
					templ = { "templ" },
				},
				formatters = {
					black = {
						postpend_args = {
							"--line-length=120",
						},
					},
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 5000,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 5000,
				})
			end, { desc = "[F]ormat file" })
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "flake8" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", {
				clear = true,
			})
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"OlegGulevskyy/better-ts-errors.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = {
			keymaps = {
				toggle = "<leader>dt", -- default '<leader>dd'
				go_to_definition = "<leader>dx", -- default '<leader>dx'
			},
		},
	},
	-- {
	-- 	"jmbuhr/otter.nvim",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	opts = {},
	-- 	config = function()
	-- 		local otter = require("otter")
	-- 		otter.setup({
	-- 			diagnostic_update_events = { "BufWritePost" },
	-- 		})
	-- 		vim.keymap.set("n", "<leader>do", function()
	-- 			otter.activate()
	-- 		end)
	-- 	end,
	-- },
}
