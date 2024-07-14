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
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			transparent_background = true,
			integrations = {
				harpoon = true,
				notify = true,
				treesitter_context = true,
			},
		},
	},
	-- {
	--     "folke/tokyonight.nvim",
	--     lazy = false,
	--     priority = 1000,
	--     opts = {
	--         transparent = true
	--     },
	-- },
}
