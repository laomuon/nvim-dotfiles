require('nvim-tree').setup ({
    actions={
        open_file = {
            resize_window = true
        }
    },
    view = {
        float = {
            enable = true,
            open_win_config = {
                width = 60,
                height = 40,
            }
        }
    }
})
vim.keymap.set("n", "<leader>ft", ":NvimTreeFindFileToggle<CR>")
