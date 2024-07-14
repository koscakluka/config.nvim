return {
	-- Detect tabstop and shiftwidth automatically
	-- TODO: Check if this is needed, doesn't seem to be
	{ "tpope/vim-sleuth" },
	-- Add indentation guides even on blank lines
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	-- TODO: This should probably be in some other place, figure out later
	{ "wuelnerdotexe/vim-astro" },
	-- TODO: This should probably be in some other place, figure out later
	{
		"davidmh/mdx.nvim",
		config = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
