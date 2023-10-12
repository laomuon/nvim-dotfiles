local telescope = {
    'nvim-telescope/telescope.nvim',
    dependencies = {{'nvim-lua/plenary.nvim'} },
    cmd = {'Telescope'},
}

telescope.init = function()
    vim.keymap.set("n", "<leader>pw", function()
        require('telescope.builtin').grep_string{ search = vim.fn.input("Grep For > ")}
    end)
    vim.keymap.set("n", "<Leader>ff", function()
        require('telescope.builtin').find_files()
    end)

    vim.keymap.set("n", "<leader>fs", function()
        require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
    end)
    vim.keymap.set("n", "<leader>pb", function()
        require('telescope.builtin').buffers()
    end)
    vim.keymap.set("n", "<leader>vh", function()
        require('telescope.builtin').help_tags()
    end)
    vim.keymap.set("n", "gr", function()
        require('telescope.builtin').lsp_references()
    end)
    vim.keymap.set("n", "gd", function()
        require('telescope.builtin').lsp_definitions()
    end)
    vim.keymap.set("n", "<leader>sd", function()
        require('telescope.builtin').diagnostics({bufnr=0})
    end)
end

telescope.config = function()
    require("telescope").setup({
        defaults = {
            wrap_results = true,
            mappings = {
                i = {
                    ["<Esc>"] = require("telescope.actions").close,
                    ["<C-j>"] = require("telescope.actions").move_selection_next,
                    ["<C-k>"] = require("telescope.actions").move_selection_previous,
                },
            },
        },
    })
    return telescope
end
return telescope
