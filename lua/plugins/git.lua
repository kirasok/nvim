local configs = require("configs.git")
local mappings = require("mappings.git")
---@type NvPluginSpec[]
local plugins = {

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewFileHistory", "DiffviewOpen" },
		keys = mappings.diffview,
		opts = configs.diffview,
	},

	{
		"NeogitOrg/neogit",
		cmd = { "Neogit" },
		keys = mappings.neogit,
		opts = configs.neogit,
		dependencies = {
			"nvim-lua/plenary.nvim",      -- required
			"sindrets/diffview.nvim",     -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},

	{
		"FabijanZulj/blame.nvim",
		opts = configs.blame,
		keys = mappings.blame,
		config = true,
	},

	{
		"lewis6991/gitsigns.nvim",
		---@type Gitsigns.Config
		opts = {
			on_attach = function() end,
			signs = {
				delete = { text = "󰍵" },
				changedelete = { text = "󱕖" },
				untracked = { text = "┃" },
			},
			attach_to_untracked = true,
		},
		---@param _ LazyPlugin
		---@param opts Gitsigns.Config
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "git")
			require("gitsigns").setup(opts)
		end,
	},
}
return plugins
