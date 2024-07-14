return {
	{
		"numToStr/Comment.nvim",
		opts = {},
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("Comment").setup({
				pre_hook = function()
					return vim.bo.commentstring
				end,
			})
		end,
	},
	"JoosepAlviste/nvim-ts-context-commentstring",
}
