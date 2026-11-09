vim.filetype.add({ filename = { Jenkinsfile = 'groovy' } })
-- Completion capabilities for every server
vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })

-- Keymaps for buffers with a language server ([d and ]d are Neovim defaults)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf }) end
        map('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end)
        map('n', 'gs', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end)
        map('n', 'gl', vim.diagnostic.open_float)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'gi', vim.lsp.buf.implementation)
        map('n', 'go', vim.lsp.buf.type_definition)
        map('n', '<F2>', vim.lsp.buf.rename)
        map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end)
        map({ 'n', 'x' }, '<F4>', vim.lsp.buf.code_action)
    end,
})

-- Per-server settings live in after/lsp/<server>.lua
vim.lsp.enable({
    'pylsp', 'ruff', 'lua_ls', 'clangd', 'robotframework_ls',
    'groovyls', 'ltex_plus', 'cmake', 'texlab',
})

vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '▲',
            [vim.diagnostic.severity.HINT] = '⚑',
            [vim.diagnostic.severity.INFO] = '',
        },
    },
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = {
        style = 'minimal',
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
    },
})
