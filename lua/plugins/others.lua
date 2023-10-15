return {
    {"lukas-reineke/indent-blankline.nvim", main="ibl", opts={scope = {enabled=false}}},
    {"numToStr/Comment.nvim", lazy=false, opts={}},
    {
        'mbbill/undotree',
        init = function()
            vim.keymap.set("n", "<leader><F5>", vim.cmd.UndotreeToggle)
        end
    }
}
