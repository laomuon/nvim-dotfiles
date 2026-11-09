vim.g.mapleader = " "
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-w>v", "<C-w>v<C-w>l")
vim.keymap.set("n", "<C-w>s", "<C-w>s<C-w>j")
vim.keymap.set("n", "<leader>fp", ":echo @%<CR>")
vim.keymap.set("n", "<Esc>", ":noh<CR>")
-- Forgive a held shift when saving
for name, cmd in pairs({ W = "write", Wq = "wq", Wa = "wall" }) do
    vim.api.nvim_create_user_command(name, cmd .. "<bang> <args>", { bang = true, nargs = "?", complete = "file" })
end

