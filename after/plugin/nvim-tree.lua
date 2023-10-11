require('nvim-tree').setup ({
    actions={
        open_file = {
            resize_window = true
        }
    },
    view = {
        adaptive_size=true,
        centralize_selection=true,
        relativenumber=true,
    }
})
vim.keymap.set("n", "<leader>ft", ":NvimTreeFindFileToggle<CR>")
local function open_nvim_tree(data)
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
    if no_name then
        require("nvim-tree.api").tree.open()
    end
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

