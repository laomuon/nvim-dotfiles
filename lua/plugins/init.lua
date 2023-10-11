local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        {
            'nvim-tree/nvim-tree.lua',
            dependencies = {
                'nvim-tree/nvim-web-devicons', -- optional, for file icons
            },
            version = "nightly" -- optional, updated every week. (see issue #1193)
        },
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {{'nvim-lua/plenary.nvim'} }
        },
        'nvim-lualine/lualine.nvim',
        {
            "nvim-treesitter/nvim-treesitter", 
            build = ":TSUpdate"
        },
        'nvim-treesitter/nvim-treesitter-context',
        "junegunn/fzf",
        "junegunn/fzf.vim",
        "xiyaowong/nvim-transparent",
        "lewis6991/gitsigns.nvim",
        {"rebelot/kanagawa.nvim", commit = 'fc2e308', lazy=true},
        {"lukas-reineke/indent-blankline.nvim", main="ibl", opts={}},
        "numToStr/Comment.nvim",
        {"VonHeikemen/lsp-zero.nvim", branch = 'v3.x'},

        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-nvim-lua'},

        -- Snippets
        {'L3MON4D3/LuaSnip'},
        {'rafamadriz/friendly-snippets'},
        'mbbill/undotree',
    }
)
