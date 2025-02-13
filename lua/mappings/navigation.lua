local map = vim.keymap.set

map("n", "j", "gj", { desc = "move 1 line down" })
map("n", "k", "gk", { desc = "move 1 line up" })

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<tab>", function()
	require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
	require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
	require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

local M = {}

---@type LazyKeymaps[]
M.nvim_spider = {
	{
		"e",
		"<cmd>lua require('spider').motion('e')<CR>",
		mode = { "n", "o", "x" },
		desc = "Spider-e",
	},
	{
		"w",
		"<cmd>lua require('spider').motion('w')<CR>",
		mode = { "n", "o", "x" },
		desc = "Spider-w",
	},
	{
		"b",
		"<cmd>lua require('spider').motion('b')<CR>",
		mode = { "n", "o", "x" },
		desc = "Spider-b",
	},
}

---@type LazyKeymaps[]
M.flash = {
	{
		"s",
		mode = { "n", "x", "o" },
		function()
			require("flash").jump()
		end,
		desc = "Flash",
	},
	{
		"S",
		mode = { "n", "x", "o" },
		function()
			require("flash").treesitter()
		end,
		desc = "Flash Treesitter",
	},
	{
		"r",
		mode = "o",
		function()
			require("flash").remote()
		end,
		desc = "Remote Flash",
	},
	{
		"R",
		mode = { "o", "x" },
		function()
			require("flash").treesitter_search()
		end,
		desc = "Treesitter Search",
	},
	{
		"<c-s>",
		mode = { "c" },
		function()
			require("flash").toggle()
		end,
		desc = "Toggle Flash Search",
	},
}

---@type LazyKeymaps[]
M.yazi = {
	{
		-- Open in the current working directory
		"<leader>e",
		function()
			require("yazi").yazi()
		end,
		desc = "yazi open",
	},
	{
		-- Open in the current working directory
		"<leader>E",
		function()
			require("yazi").yazi(nil, vim.fn.getcwd())
		end,
		desc = "yazi cwd",
	},
}

require("which-key").add({
	{ "<leader>q", group = "quickfix" },
})
---@type LazyKeymaps[]
M.trouble = {
	{
		"<leader>qq",
		"<cmd>Trouble diagnostics toggle focus=true<cr>",
		desc = "Diagnostics",
	},
	{
		"<leader>qQ",
		"<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
		desc = "Buffer Diagnostics",
	},
	{
		"<leader>qt",
		"<cmd>Trouble todo toggle focus=true<cr>",
		desc = "Todos",
	},
}

---@type LazyKeymaps[]
M.projcetions = {
	{
		"<leader>fs",
		function()
			vim.cmd("Telescope projections")
		end,
		desc = "projects",
	},
}

return M
