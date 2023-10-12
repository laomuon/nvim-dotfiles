local ts =  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {{"nvim-treesitter/nvim-treesitter-context"}},
    build = ":TSUpdate",
    event = 'VeryLazy',
}
ts.config = function()
    require'nvim-treesitter.configs'.setup( {
        ensure_installed = {"c", "bash", "lua", "python", "vim", "query", "cpp", "markdown"},
        sync_install = false,
        indent = {
            enable = true,
        },

        highlight = {
            enable = true,
            disable = function (lang, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 5000
            end,
            additional_vim_regex_highlighting = false,
        },
    })
    return ts
end

return ts
