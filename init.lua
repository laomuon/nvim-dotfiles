--vim.opt.guicursor = ""
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

  -- Gruvbox colortheme
  use 'morhetz/gruvbox'
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'arcticicestudio/nord-vim'
 
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
  use {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    }
    use 'numToStr/Comment.nvim'
    use {
  'VonHeikemen/lsp-zero.nvim',
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

    -- Linting
    {'jose-elias-alvarez/null-ls.nvim'},
    {'jay-babu/mason-null-ls.nvim'},

    -- Markdown
    use {'iamcco/markdown-preview.nvim'}
  }
}
end)
-- Set colortheme
vim.g.gruvbox_transparent_bg = '1'
vim.g.gruvbox_invert_selection = '0'
vim.g.gruvbox_contrast_dark = 'hard'

require("Comment").setup()

require("catppuccin").setup({
    flavour = "latte", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "macchiato",
    },
    transparent_background = true,
    term_colors = true,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    styles = {
        comments = {},
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {
        mocha = {
            base = "#000000",
        },
    },
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
    },
})
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
    ensure_installed = {"c", "bash", "lua", "python", "vim", "help", "query", "cpp", "markdown"},
    sync_install = false,
    indent = {
        enable = true,
    },

    highlight = {
        enable = true,
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
  enable = true, -- boolean: enable transparent
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
  exclude = {}, -- table: groups you don't want to clear
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
"                                                                                                ",
              "                                                                                                ",
              "                                                                                                ",
              "                                                                                                ",
              "                                                                                                ",
              "         -╲         '-                                                                          ",
              "       -' :╲        │ '-                                                                        ",
              "     -'   : ╲       │   '-                          │MMM│                                       ",
              "   -'·    :  ╲      │     '-                        │WWW│                                       ",
              "  '.-.·   :   ╲     │       │                                                                   ",
              "  │. .-·  :    ╲    │       │    MMM=         =MMM  │MMM│  │M│  +===+   +====+                  ",
              "  │ . .-· :     ╲   │       │    ╲HHB`       'BHH╱  │HHH│  │H│╲╱sMMMs╲_╱sMMMMs╲                 ",
              "  │. . .-·;      ╲  │       │     ╲HHH╲     ╱HHH╱   │HHH│  │HBBWWWWWHMMMHWWWW:B╲                ",
              "  │ . . .-│       ╲ │       │      ╲HHH╲   ╱HHH╱    │HHH│  │HK╱     ╲KYK╱    ╲KH│               ",
              "  │. . . .│╲       ╲│       │       ╲HHH╲ ╱HHH╱     │HHH│  │H│       │H│      │H│               ",
              "  │ . . . │ ╲       ;-      │        ╲HHHVHHH╱      │HHH│  │H│       │H│      │H│               ",
              "  │. . . .│  ╲      :·-     │         ╲HHHHH╱       │HHH│  │H│       │H│      │H│               ",
              "  │ . . . │   ╲     : .-    │          ╲HHH╱        │HHH│  │H│       │H│      │H│               ",
              "  │. . . .│    ╲    :. .-   │           ╲W╱         │WWW│  │W│       │W│      │W│               ",
              "  `- . . .│     ╲   : . .- -'                                                                   ",
              "    `- . .│      ╲  :. ..-'                                                                     ",
              "      `-. │       ╲ :..-'                                                                       ",
              "         `│        ╲;-'                                                                         ",
              "                                                                                                ",
              "                                                                                                ",
}

-- Set menu
dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "f", "  > Find file", ":cd /home/muon/eureka | Telescope find_files<CR>"),
    dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
}

-- Set footer
 local fortune = require("alpha.fortune") 
 dashboard.section.footer.val = fortune()

-- Send config to alpha
alpha.setup(dashboard.opts)

vim.cmd [[
let g:mkdp_auto_start = 0

let g:mkdp_auto_close = 1

let g:mkdp_refresh_slow = 0

let g:mkdp_command_for_global = 0

let g:mkdp_open_to_the_world = 0

let g:mkdp_open_ip = ''

let g:mkdp_browser = 'firefox'

let g:mkdp_echo_preview_url = 0
  function OpenMarkdownPreview (url)
    execute "silent ! firefox --new-window " . a:url
  endfunction
  let g:mkdp_browserfunc = 'OpenMarkdownPreview'

let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }

let g:mkdp_markdown_css = 'expand("~/github-markdown.css")'

let g:mkdp_highlight_css = 'expand("~/highlight.css")'

let g:mkdp_port = ''

let g:mkdp_page_title = '「${name}」'

let g:mkdp_filetypes = ['markdown']

let g:mkdp_theme = 'dark'
]]
-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])
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
nnoremap("<C-p>", ":Telescope")
nnoremap("<leader>pw", function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})
end)
nnoremap("<C-p>", function()
    require('telescope.builtin').git_files()
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

nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-w>v", "<C-w>v<C-w>l")
nnoremap("<C-w>s", "<C-w>s<C-w>j")
nnoremap("<leader>mp", ":MarkdownPreviewToggle<CR>")


local lsp = require('lsp-zero')

lsp.preset('recommended')
local cmp = require('cmp')
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
})
lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})
lsp.setup_nvim_cmp({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 3},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  }
})
lsp.setup()
null_ls = require("null-ls")
lsp_config = require("lspconfig")
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
-- local null_ls = require("null-ls").setup()
local mason_null = require("mason-null-ls")
mason_null.setup({
        automatic_installation = true,
        automatic_setup = true,

    })
mason_null.setup_handlers({})
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = {border = "single"},
})
-- vim.opt.foldlevel = 20
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
