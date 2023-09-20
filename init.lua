--vim.opt.guicursor = ""
local vim = vim
vim.opt.termguicolors = true
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.list = true

vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appear/become resolved.
vim.opt.signcolumn = "yes"

vim.opt.scrolloff = 8

vim.g.netrw_banner = 0

vim.cmd [[packadd packer.nvim]]
vim.cmd('syntax enable')

require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- A file tree written in lua
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use{
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/plenary.nvim'} }
    }

    use({
        'nvim-lualine/lualine.nvim',
    })
    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })
    use 'nvim-treesitter/nvim-treesitter-context'
    use("junegunn/fzf")
    use("junegunn/fzf.vim")
    use 'xiyaowong/nvim-transparent'
    use 'lewis6991/gitsigns.nvim'
    use ({'rebelot/kanagawa.nvim', commit = 'fc2e308'})
    use 'lukas-reineke/indent-blankline.nvim'
    use 'numToStr/Comment.nvim'
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',

        requires = {
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
        },
    }
    use 'mbbill/undotree'
end)

require("Comment").setup()

require('kanagawa').setup({transparent=true,})
vim.cmd("colorscheme kanagawa")

require('indent_blankline').setup()
require('gitsigns').setup{
    current_line_blame = true,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, {expr=true})

        -- Actions
        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line{full=true} end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
}
require'nvim-treesitter.configs'.setup {
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
}

require'treesitter-context'.setup()

require("lualine").setup({
    sections = sections,
    options = {
        icons_enabled = true,
        theme = 'kanagawa',
    }
})

require('telescope').setup({
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
require('nvim-tree').setup ({
    actions={
        open_file = {
            resize_window = true
        }
    },
    view = {
        float = {
            enable = true,
            open_win_config = {
                width = 60,
                height = 40,
            }
        }
    }
})
require("transparent").setup({
    extra_groups = { -- table/string: additional groups that should be cleared
        -- In particular, when you set it to 'all', that means all available groups

        -- example of akinsho/nvim-bufferline.lua
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected"
    },
    exclude_groups = {}, -- table: groups you don't want to clear
})

vim.g.mapleader = " "

local function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

local nmap = bind("n", {noremap = false})
local nnoremap = bind("n")
local vnoremap = bind("v")
local xnoremap = bind("x")
local inoremap = bind("i")

nnoremap("<leader>fp", ":echo @%<CR>")
nnoremap("<leader>ft", ":NvimTreeFindFileToggle<CR>")
nnoremap("<Esc>", ":noh<CR>")
nnoremap("<leader>pw", function()
    require('telescope.builtin').grep_string{ search = vim.fn.input("Grep For > ")}
end)
nnoremap("<Leader>ff", function()
    require('telescope.builtin').find_files()
end)

nnoremap("<leader>fs", function()
    require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
end)
nnoremap("<leader>pb", function()
    require('telescope.builtin').buffers()
end)
nnoremap("<leader>vh", function()
    require('telescope.builtin').help_tags()
end)
nnoremap("gr", function()
    require('telescope.builtin').lsp_references()
end)
nnoremap("gd", function()
    require('telescope.builtin').lsp_definitions()
end)
nnoremap("<leader>sd", function()
    require('telescope.builtin').diagnostics({bufnr=0})
end)
nnoremap("<leader><F5>", vim.cmd.UndotreeToggle)

nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-w>v", "<C-w>v<C-w>l")
nnoremap("<C-w>s", "<C-w>s<C-w>j")

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local lsp = require('lsp-zero')

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr, exclude = {"gd", "gr", "C-p"},})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    },
})
lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = ''
})
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = {
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})
local cmp = require('cmp')
local cmp_action = lsp.cmp_action()
local cmp_format = lsp.cmp_format()

require('luasnip.loaders.from_vscode').lazy_load()

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

cmp.setup({
    formatting = cmp_format,
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    window = {
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        {name = 'path'},
        {name = 'nvim_lsp'},
        {name = 'nvim_lua'},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
    },
    mapping = {
        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({select = true}),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),

        -- tab complete
        ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }
})

