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
		config = function()
			-- [[ Configure LSP ]]
			--  This function gets run when an LSP connects to a particular buffer.
			local on_attach = function(_, bufnr)
				-- NOTE: Remember that lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself
				-- many times.
				--

				vim.keymap.set(
					"n",
					"<leader>vrn",
					vim.lsp.buf.rename,
					{ buffer = bufnr, desc = "[V}ariable [R]e[n]ame" }
				)
				vim.keymap.set(
					"n",
					"<leader>vca",
					vim.lsp.buf.code_action,
					{ buffer = bufnr, desc = "[V}ariable [C]ode [A]ction" }
				)

				vim.keymap.set(
					"n",
					"gd",
					require("telescope.builtin").lsp_definitions,
					{ buffer = bufnr, desc = "[G]oto [D]efinition" }
				)
				vim.keymap.set(
					"n",
					"gr",
					require("telescope.builtin").lsp_references,
					{ buffer = bufnr, desc = "[G]oto [R]eferences" }
				)
				vim.keymap.set(
					"n",
					"gI",
					require("telescope.builtin").lsp_implementations,
					{ buffer = bufnr, desc = "[G]oto [I]mplementation" }
				)
				vim.keymap.set(
					"n",
					"<leader>D",
					require("telescope.builtin").lsp_type_definitions,
					{ buffer = bufnr, desc = "Type [D]efinition" }
				)
				vim.keymap.set(
					"n",
					"<leader>ds",
					require("telescope.builtin").lsp_document_symbols,
					{ buffer = bufnr, desc = "[D]ocument [S]ymbols" }
				)
				vim.keymap.set(
					"n",
					"<leader>ws",
					require("telescope.builtin").lsp_dynamic_workspace_symbols,
					{ buffer = bufnr, desc = "[W]orkspace [S]ymbols" }
				)

				-- See `:help K` for why this keymap
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
				vim.keymap.set(
					"n",
					"<leader>k",
					vim.lsp.buf.signature_help,
					{ buffer = bufnr, desc = "Signature Documentation" }
				)

				-- Lesser used LSP functionality
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[G]oto [D]eclaration" })
				vim.keymap.set(
					"n",
					"<leader>wa",
					vim.lsp.buf.add_workspace_folder,
					{ buffer = bufnr, desc = "[W]orkspace [A]dd Folder" }
				)
				vim.keymap.set(
					"n",
					"<leader>wr",
					vim.lsp.buf.remove_workspace_folder,
					{ buffer = bufnr, desc = "[W]orkspace [R]emove Folder" }
				)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, { buffer = bufnr, desc = "[W]orkspace [L]ist Folders" })

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
					vim.lsp.buf.format()
				end, { desc = "Format current buffer with LSP" })
			end

			-- document existing key chains
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
				["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
				["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
				["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			})
			-- register which-key VISUAL mode
			-- required for visual <leader>hs (hunk stage) to work
			require("which-key").register({
				["<leader>"] = { name = "VISUAL <leader>" },
				["<leader>h"] = { "Git [H]unk" },
			}, { mode = "v" })

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
				},
			})

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. They will be passed to
			--  the `settings` field of the server config. You must look up that documentation yourself.
			--
			--  If you want to override the default filetypes that your language server will attach to you can
			--  define the property 'filetypes' to the map in question.
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- rust_analyzer = {},
				pyright = {
					python = {
						analysis = {
							typeCheckingMode = "off", -- basic
						},
					},
				},
				tsserver = {},
				html = { filetypes = { "html", "twig", "hbs" } },
				tailwindcss = { files = { excluded = ".local" } },

				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			}

			-- Setup neovim lua configuration
			require("neodev").setup()

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Ensure the servers above are installed
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
					})
				end,
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
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					svelte = { "prettierd" },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					graphql = { "prettierd" },
					lua = { "stylua" },
					python = { "isort", "black" },
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
			end, { desc = "Format file" })
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
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
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
}
