local nvim_tree = {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    version = "nightly",-- optional, updated every week. (see issue #1193)
    cmd = "NvimTreeFindFileToggle",
}

local function open_nvim_tree(data)
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
    if no_name then
        require("nvim-tree.api").tree.open()
    end
end

nvim_tree.init = function()
    vim.keymap.set("n", "<leader>ft", ":NvimTreeFindFileToggle<CR>")
    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
end

nvim_tree.opts = {
    actions={
        open_file = {
            resize_window = true
        }
    },
    view = {
        adaptive_size=true,
        centralize_selection=true,
        relativenumber=true
    }
}

return nvim_tree
