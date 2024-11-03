-- TODO: Check if this is really needed anymore, I might want to remove it
return {
	-- Useful plugin to show you pending keybinds.
	{
		"folke/which-key.nvim",
		opts = {},
		config = function()
			local which_key = require("which-key")
			which_key.add({
				{ "<leader>c", "[C]ode", group = "[C]ode", desc = "[C]ode" },
				{ "<leader>d", "[D]ocument", group = "[D]ocument", desc = "[D]ocument" },
				{ "<leader>g", "[G]it", group = "[G]it", desc = "[G]it" },
				{ "<leader>h", "Git [H]unk", group = "Git [H]unk", desc = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>s", "[S]earch", group = "[S]earch", desc = "[S]earch" },
				{ "<leader>t", "[T]oggle", group = "[T]oggle", desc = "[T]oggle" },
				{ "<leader>w", "[W]orkspace", group = "[W]orkspace", desc = "[W]orkspace" },
			})
			which_key.add({}, { mode = "v" })
		end,
	},
}
