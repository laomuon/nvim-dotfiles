return {
        "vimwiki/vimwiki",
        event = "BufEnter *.md",
        keys = { "<leader>ww", "<leader>wt" },
        init = function()
            vim.g.vimwiki_global_ext = 0
            vim.g.vimwiki_list = {
                {
                    path = "~/notes_these",
                },
                {
                    path = "~/personal_note/",
                },
            }
            vim.g.vimwiki_hl_headers = 1
            vim.g.vimwiki_hl_cb_checked = 1
        end,
        config = function ()
            vim.cmd([[
                function! VimwikiLinkHandler(link)
                let link = a:link
                if link !~# '^https:'
                    return 0
                endif
                try
                    execute 'silent !firefox --new-window ' . a:link
                    return 1
                catch
                    echo "This can happen for a variety of reasons ..."
                endtry
                return 0
                endfunction
            ]])

        end
}
