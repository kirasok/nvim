---@type NvPluginSpec[]
return {
		-- load luasnips + cmp related in insert mode only
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- snippet plugin
				"L3MON4D3/LuaSnip",
			},

			-- autopairing of (){}[] etc
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
				config = function(_, opts)
					require("nvim-autopairs").setup(opts)

					-- setup cmp for autopairs
					local cmp_autopairs = require "nvim-autopairs.completion.cmp"
					require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},

			-- cmp sources plugins
			{
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
			},
		},
		opts = require("configs.cmp"),
	},

}
