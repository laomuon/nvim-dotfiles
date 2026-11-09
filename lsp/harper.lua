-- Not enabled by default: add 'harper' to the list in after/plugin/lsp.lua to use it
return {
    cmd = { 'harper-ls', '--stdio' },
    filetypes = {'tex', 'latex', 'markdown', 'text', 'typst' },
}
