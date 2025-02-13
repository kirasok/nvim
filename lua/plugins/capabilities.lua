local configs = require("configs.capabilities")
local mappings = require("mappings.capabilities")
---@type NvPluginSpec[]
return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufEnter",
		config = function(_, _)
			require("ufo").setup(configs.ufo())
		end,
	},

	{
		"utilyre/sentiment.nvim",
		version = "*",
		event = "VeryLazy", -- keep for lazy loading
		config = true,
		init = function()
			-- `matchparen.vim` needs to be disabled manually in case of lazy loading
			vim.g.loaded_matchparen = 1
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},

	{
		"tzachar/highlight-undo.nvim",
		event = "BufRead",
	},

	{
		"gbprod/yanky.nvim",
		event = "BufRead",
		opts = configs.yanky,
	},

	{
		"m4xshen/smartcolumn.nvim",
		event = "BufRead",
		config = true,
	},

	{
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		event = "BufRead",
	},

	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged",
		commit = "979aea2ab9c62508c086e4d91a5c821df54168a8",
	},

	{
		"hrsh7th/cmp-cmdline",
		dependencies = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-buffer" },
		event = "CmdlineEnter",
		config = configs.cmdline,
	},

	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		opts = configs.zen,
		keys = mappings.zen,
	},

	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = mappings.undotree,
	},

	{
		"3rd/image.nvim",
		enabled = os.getenv("TERM") == "xterm-kitty",
		opts = configs.image,
	},

	{
		"godlygeek/tabular",
		cmd = "Tabularize",
	},

	{
		"kirasok/gx.nvim",
		keys = mappings.gx,
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		submodules = false, -- not needed, submodules are required only for tests
		config = configs.gx,
	},

	{
		"danymat/neogen",
		cmd = "Neogen",
		config = configs.neogen,
		keys = mappings.neogen,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true,
	},

	{
		"okuuva/auto-save.nvim",
		commit = "29f793a",
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		opts = configs.autosave,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "User FilePost",
		opts = {
			indent = { char = "│", highlight = "IblIndent" },
			scope = { char = "│", highlight = "IblScope" },
		},
		config = function(_, opts)
			local hooks = require "ibl.hooks"
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			require("ibl").setup(opts)
		end,
	},

	{
		"nvim-tree/nvim-web-devicons",
	},

	{
		"folke/which-key.nvim",
		lazy = false,
		keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
		opts = function()
			return {}
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		opts = {
			compile = true, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = true },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			background = {      -- map the value of 'background' option to a theme
				dark = "dragon",  -- try "dragon" !
				light = "lotus"
			},
		},
		config = function(_, opts)
			require("kanagawa").setup(opts)
			vim.cmd [[set background=dark]]
			vim.cmd([[colorscheme kanagawa]])
		end,
	}

}
