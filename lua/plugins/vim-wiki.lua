return {
        "vimwiki/vimwiki",
        event = "BufEnter *.md",
        keys = { "<leader>ww", "<leader>wt" },
        init = function()
            vim.g.vimwiki_global_ext = 0
            vim.g.vimwiki_list = {
                {
                    path = "~/note",
                    syntax = "markdown",
                    ext = ".md",
                },
            }
            vim.g.vimwiki_ext2syntax = {
                [".md"] = "markdown",
                [".markdown"] = "markdown",
                [".mdown"] = "markdown",
            }
        end,
        config = function ()
            vim.cmd([[
                function! VimwikiLinkHandler(link)
                let link = a:link
                if link !~# '^https:'
                    return 0
                endif
                try
                    execute '!firefox --new-window ' . a:link
                    return 1
                catch
                    echo "This can happen for a variety of reasons ..."
                endtry
                return 0
                endfunction
            ]])

        end
}
