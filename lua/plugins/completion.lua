return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local cmp = require('cmp')

        require('luasnip.loaders.from_vscode').lazy_load()

        vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = {'abbr', 'menu', 'kind'},
                format = function(entry, item)
                    local names = {nvim_lsp = 'LSP', nvim_lua = 'nvim'}
                    item.menu = string.format('[%s]', names[entry.source.name] or entry.source.name)
                    return item
                end,
            },
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
                ['<C-y>'] = cmp.mapping.confirm({select = false}),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
                ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
                ['<C-p>'] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_prev_item({behavior = 'insert'})
                    else
                        cmp.complete()
                    end
                end),
                ['<C-n>'] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_next_item({behavior = 'insert'})
                    else
                        cmp.complete()
                    end
                end),
                -- `Enter` key to confirm completion
                ['<CR>'] = cmp.mapping.confirm({select = true}),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-k>'] = cmp.mapping.select_prev_item(),

                -- tab complete
                -- ['<Tab>'] = cmp_action.tab_complete(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            }
        })
    end,
}
