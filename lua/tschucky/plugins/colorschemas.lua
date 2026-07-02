return {
	-- {
	-- 	-- Theme inspired by Atom
	-- 	"navarasu/onedark.nvim",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("onedark")
	-- 		require("onedark").setup({
	-- 			transparent = true,
	-- 		})
	--
	-- 		require("onedark").load()
	-- 	end,
	-- },
	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		flavour = "mocha",
	-- 		transparent_background = true,
	-- 		integrations = {
	-- 			harpoon = true,
	-- 			notify = true,
	-- 			treesitter_context = true,
	-- 		},
	-- 		custom_highlights = function(colors)
	-- 			return {
	-- 				Comment = { fg = colors.subtext1 },
	-- 				LineNr = { fg = colors.text },
	-- 				LineNrAbove = { fg = colors.overlay2 },
	-- 				LineNrBelow = { fg = colors.overlay2 },
	-- 			}
	-- 		end,
	-- 	},
	-- },
	-- {
	-- 	"olivercederborg/poimandres.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("poimandres").setup({
	-- 			-- leave this setup function empty for default config
	-- 			-- or refer to the configuration section
	-- 			-- for configuration options
	-- 			-- bold_vert_split = false, -- use bold vertical separators
	-- 			-- dim_nc_background = false, -- dim 'non-current' window backgrounds
	-- 			disable_background = true, -- disable background
	-- 			-- disable_float_background = false, -- disable background for floats
	-- 			-- disable_italics = false, -- disable italics
	-- 		})
	-- 	end,
	--
	-- 	-- optionally set the colorscheme within lazy config
	-- 	init = function()
	-- 		vim.cmd("colorscheme poimandres")
	-- 	end,
	-- },
	-- {
	--     "folke/tokyonight.nvim",
	--     lazy = false,
	--     priority = 1000,
	--     opts = {
	--         transparent = true
	--     },
	-- },
	--
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				-- variant = "moon",
				styles = { italic = false, transparency = true},
				highlight_groups = { Visual = { bg = "text", inherit = false, blend = 35 } },
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
}
