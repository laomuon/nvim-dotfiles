return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- the main branch does not support lazy-loading
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-context" },
    config = function()
        require("nvim-treesitter").install({
            "c", "bash", "lua", "python", "vim", "query", "cpp",
            "markdown", "markdown_inline", "vimdoc",
        })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "c", "cpp", "sh", "bash", "lua", "python", "vim", "query", "markdown", "help" },
            callback = function(ev)
                if vim.api.nvim_buf_line_count(ev.buf) <= 2000 then
                    pcall(vim.treesitter.start, ev.buf)
                end
            end,
        })
    end,
}
