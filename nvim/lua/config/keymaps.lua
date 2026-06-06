local map = vim.keymap.set

-- Better escape
map("i", "jk", "<ESC>")
map("i", "kj", "<ESC>")

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered while navigating
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize splits
map("n", "<C-Up>",    "<cmd>resize +2<cr>")
map("n", "<C-Down>",  "<cmd>resize -2<cr>")
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>")
map("n", "<S-l>", "<cmd>bnext<cr>")
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Better paste (don't yank on visual paste)
map("x", "<leader>p", [["_dP]])

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Quickfix
map("n", "<leader>xq", "<cmd>copen<cr>",  { desc = "Quickfix list" })
map("n", "[q",         "<cmd>cprev<cr>")
map("n", "]q",         "<cmd>cnext<cr>")
