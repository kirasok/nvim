local M = {}

M.linters = {
	javascript = { "deno" },
	javascriptreact = { "deno" },
	typescript = { "deno" },
	typescriptreact = { "deno" },
	zsh = { "zsh" },
	json = { "jsonlint" },
}

M.formatters = {
	toml = { "taplo" },
	yaml = { "yamlfmt" },
	sh = { "shfmt" },
	zsh = { "shfmt" },
	nix = { "nixfmt" },
	markdown = { 'markdownlint-cli2' },
	typescript = { "deno_fmt" },
	javascript = { "deno_fmt" },
	json = { "deno_fmt" }
}

M.servers = {
	rust_analyzer = {},
	bashls = {},
	taplo = {},
	yamlls = {},
	hls = {},
	clangd = {},
	html = {},
	jsonls = {},
	cssls = {},
	ts_ls = {},
	nil_ls = {},
	lemminx = {},
	pylsp = {
		settings = {
			pylsp = {
				plugins = {
					pylsp_mypy = {
						enabled = true,
						live_mode = true,
						strict = false,
					},
					pyflakes = { enabled = false },
					mccabe = { enabled = true },
					rope_autoimport = { enabled = true },
					pydocstyle = { enabled = false, },
					pycodestyle = { enabled = false, },
					autopep8 = { enabled = false },
					yapf = { enabled = false },
					flake8 = { enabled = false },
					pylint = { enabled = false },
					jedi_completion = { enabled = false },
					rope_completion = { enabled = true },
					isort = { enabled = true },
					rope = { enabled = true },
					pylsp_rope = { enabled = true },
					ruff = { enabled = true },
				},
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
				gofumpt = true,
				semanticTokens = true,
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	},
	texlab = {
		settings = {
			texlab = {
				build = {
					executable = "latexmk",
					args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
					onSave = true,
					forwardSearchAfter = true,
				},
				forwardSearch = {
					executable = "zathura",
					args = { "--synctex-forward", "%l:1:%f", "%p" },
				},
				chktex = {
					onOpenAndSave = true,
				},
				formatterLineLength = 0,
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				format = {
					enable = true,
				},
				hint = {
					enable = true,
				},
				completion = {
					callSnippet = "Replace",
					showWord = false,
				},
			},
		},
	},
}

vim.api.nvim_create_user_command("LspCapabilities", function()
	local curBuf = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = curBuf })
	for _, client in pairs(clients) do
		if client.name ~= "null-ls" then
			local capAsList = {}
			for key, value in pairs(client.server_capabilities) do
				if value then
					table.insert(capAsList, "- " .. key)
				end
			end

			table.sort(capAsList) -- sorts alphabetically
			local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
			vim.notify(msg, "trace", {
				on_open = function(win)
					local buf = vim.api.nvim_win_get_buf(win)
					vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				end,
				timeout = 14000,
			})
		end
	end
end, {})

function M.on_init(client, _)
	if client.supports_method "textDocument/semanticTokens" then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

function M.on_attach(client, bufnr)
	require("mappings.lspconfig").setup(client.server_capabilities)
	client.server_capabilities.documentFormattingProvider = true
	client.server_capabilities.documentRangeFormattingProvider = true
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

M.action_preview = function(_, _)
	require("actions-preview").setup({
		highlight_command = {
			require("actions-preview.highlight").delta(),
		},
		backend = { "telescope" },
		telescope = {
			sorting_strategy = "ascending",
			layout_strategy = "vertical",
			layout_config = {
				width = 0.8,
				height = 0.9,
				prompt_position = "top",
				preview_cutoff = 20,
				preview_height = function(_, _, max_lines)
					return max_lines - 15
				end,
			},
		},
	})
end

---@type conform.setupOpts
M.confrom = {
	formatters_by_ft = M.formatters,
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

---@type nvim-lightbulb.Config
M.lightbulb = {
	autocmd = { enabled = true },
	sign = { enabled = false },
	virtual_text = { enabled = true, text = " ", lens_text = "󰍉 " },
	ignore = {
		ft = { "dart" },
	},
}

M.outline = {
	outline_window = {
		show_cursorline = true,
		hide_cursor = true,
	},
	guides = {
		enabled = false,
	},
	preview_window = {
		auto_preview = true,
	},
	symbols = {
		icons = {
			File = { icon = "󰈔 ", hl = "Identifier" },
			Module = { icon = "󰆧 ", hl = "Include" },
			Namespace = { icon = "󰅪 ", hl = "Include" },
			Package = { icon = "󰏗 ", hl = "Include" },
			Class = { icon = " ", hl = "Type" },
			Method = { icon = "ƒ", hl = "Function" },
			Property = { icon = " ", hl = "Identifier" },
			Field = { icon = "󰆨 ", hl = "Identifier" },
			Constructor = { icon = " ", hl = "Special" },
			Enum = { icon = " ", hl = "Type" },
			Interface = { icon = "󰜰 ", hl = "Type" },
			Function = { icon = "", hl = "Function" },
			Variable = { icon = " ", hl = "Constant" },
			Constant = { icon = " ", hl = "Constant" },
			String = { icon = " ", hl = "String" },
			Number = { icon = "#", hl = "Number" },
			Boolean = { icon = "⊨", hl = "Boolean" },
			Array = { icon = "󰅪 ", hl = "Constant" },
			Object = { icon = " ", hl = "Type" },
			Key = { icon = " ", hl = "Type" },
			Null = { icon = "NULL", hl = "Type" },
			EnumMember = { icon = " ", hl = "Identifier" },
			Struct = { icon = " ", hl = "Structure" },
			Event = { icon = "", hl = "Type" },
			Operator = { icon = "+", hl = "Identifier" },
			TypeParameter = { icon = " ", hl = "Identifier" },
			Component = { icon = "󰅴 ", hl = "Function" },
			Fragment = { icon = "󰅴 ", hl = "Constant" },
			TypeAlias = { icon = " ", hl = "Type" },
			Parameter = { icon = " ", hl = "Identifier" },
			StaticMethod = { icon = " ", hl = "Function" },
			Macro = { icon = " ", hl = "Function" },
		},
	},
}

M.symbols = function(_, _)
	local function h(name)
		return vim.api.nvim_get_hl(0, { name = name })
	end

	-- hl-groups can have any name
	vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("Visual").bg, italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("Visual").bg, fg = h("Visual").fg, italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("@function").fg, bg = h("Visual").bg, italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("@type").fg, bg = h("Visual").bg, italic = true })
	vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("Visual").bg, italic = true })

	local function text_format(symbol)
		local res = {}

		local round_start = { "", "SymbolUsageRounding" }
		local round_end = { "", "SymbolUsageRounding" }

		-- Indicator that shows if there are any other symbols in the same line
		local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

		if symbol.references then
			local usage = symbol.references <= 1 and "usage" or "usages"
			local num = symbol.references == 0 and "no" or symbol.references
			table.insert(res, round_start)
			table.insert(res, { "󰌹 ", "SymbolUsageRef" })
			table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
			table.insert(res, round_end)
		end

		if symbol.definition then
			if #res > 0 then
				table.insert(res, { " ", "NonText" })
			end
			table.insert(res, round_start)
			table.insert(res, { "󰳽 ", "SymbolUsageDef" })
			table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
			table.insert(res, round_end)
		end

		if symbol.implementation then
			if #res > 0 then
				table.insert(res, { " ", "NonText" })
			end
			table.insert(res, round_start)
			table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
			table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
			table.insert(res, round_end)
		end

		if stacked_functions_content ~= "" then
			if #res > 0 then
				table.insert(res, { " ", "NonText" })
			end
			table.insert(res, round_start)
			table.insert(res, { " ", "SymbolUsageImpl" })
			table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
			table.insert(res, round_end)
		end

		return res
	end

	require("symbol-usage").setup({
		text_format = text_format,
	})
end

M.tiny_diagnostics = {
	preset = "powerline",
	options = {
		-- Use icons defined in the diagnostic configuration
		use_icons_from_diagnostic = false,
		-- Add messages to diagnostics when multiline diagnostics are enabled
		-- If set to false, only signs will be displayed
		add_messages = true,
		-- Time (in milliseconds) to throttle updates while moving the cursor
		-- Increase this value for better performance if your computer is slow
		-- or set to 0 for immediate updates and better visual
		throttle = 20,
		-- Minimum message length before wrapping to a new line
		softwrap = 30,
		-- Show all diagnostics under the cursor if multiple diagnostics exist on the same line
		-- If set to false, only the diagnostics under the cursor will be displayed
		multiple_diag_under_cursor = true,
		multilines = {
			-- Enable multiline diagnostic messages
			enabled = true,
			-- Always show messages on all lines for multiline diagnostics
			always_show = true,
		},
		-- Display all diagnostic messages on the cursor line
		show_all_diags_on_cursorline = true,
		-- Enable diagnostics in Insert mode
		-- If enabled, it is better to set the `throttle` option to 0 to avoid visual artifacts
		enable_on_insert = false,
		-- Enable diagnostics in Select mode (e.g when auto inserting with Blink)
		enable_on_select = false,
		overflow = {
			-- Manage how diagnostic messages handle overflow
			-- Options:
			-- "wrap" - Split long messages into multiple lines
			-- "none" - Do not truncate messages
			-- "oneline" - Keep the message on a single line, even if it's long
			mode = "wrap",
		},
	},
	disabled_ft = { "markdown" }, -- List of filetypes to disable the plugin
}

return M
