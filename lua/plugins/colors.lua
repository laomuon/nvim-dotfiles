return {
    {
        "rebelot/kanagawa.nvim", 
        -- 'shaunsingh/nord.nvim',
        lazy=false,
        priority = 1000,
        config = function ()
            vim.cmd("colorscheme kanagawa-wave")
            -- vim.cmd("colorscheme nord")
        end
    }
}
