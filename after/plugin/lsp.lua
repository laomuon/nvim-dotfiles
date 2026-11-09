vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"Jenkinsfile"},
    command = "set filetype=groovy",
})
local robot_auto_test_dir = os.getenv("ROBOT_AUTO_TEST_DIR")
local home_dir = os.getenv("HOME")

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

-- python (python-lsp-server + ruff_lsp)
vim.lsp.config('pylsp', {
    -- root_dir = function(fname, _)
    --     local ret = require('lspconfig').util.find_git_ancestor(fname)
    --     return ret
    -- end,
    root_markers = {'.git'},
    settings = {
        pylsp = {
            plugins = {
                -- formatter options
                black = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = { enabled = false },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                ruff = { enabled = false },
                -- type checker
                pylsp_mypy = {
                    enabled = true,
                    live_mode = false,
                    overrides = {'--check-untyped-defs', '--always-false=PYQT5', '--always-false=PYSIDE2', '--always-false=PYQT4', '--always-true=PYSIDE', true},
                },
                -- auto-completion options
                jedi_completion = {
                    fuzzy = true,
                },
            },
        },
    },
})
vim.lsp.enable('pylsp')

vim.lsp.config('ruff',{
    root_markers = {'.git'},
    configs = {
        ruff_lsp = {
            default_config = {
                cmd = { 'ruff-lsp' },
                filetypes = { 'python' },
                init_options = {
                    settings = {
                        args = {
                            lint = {run = "onSave"}
                        }
                    }
                }
            }
        }
    }
})
vim.lsp.enable('ruff')
-- lua (lua_ls)
vim.lsp.config("lua_ls", {})
vim.lsp.enable('lua_ls')

-- C/C++ (clangd). OAI's compile_commands path is set in ~/openairinterface5g/.clangd
vim.lsp.config("clangd",{
    filetypes = {'c', 'cpp', 'objc', 'cuda'},
})
vim.lsp.enable('clangd')

-- robotframework (robotframework_lsp)
vim.lsp.config("robotframework_ls",{
    settings = {
        robot = {
            python = {
                executable = os.getenv("ROBOT_TEST_ENV_EXE")
            }
        }
    }
})
vim.lsp.enable('robotframework_ls')

-- Groovy (groovyls)
vim.lsp.config("groovyls",{
    cmd = {"java", "-jar", home_dir .. "/groovy-language-server/build/libs/groovy-language-server-all.jar"},
    filetypes = {"groovy", "Jenkinsfile"}
})
vim.lsp.enable('groovyls')

local lt_email = os.getenv("LGT_USERNAME")
local lt_key = os.getenv("LGT_KEY")
-- ltex (language-tool)
vim.lsp.config("ltex_plus",{
  settings = {
    ltex = {
      -- dictionary = {
      --   ['en-US'] = {'embb', 'urllc', 'mmtc', 'Duc', 'mIoT', 'MIoT', 'MEAR', 'GeCode', 'VNF-FGE', 'QoS', 'Qos', 'gNB', 'gNBs', 'MILP'}
      -- }
      enabled=true,
      language="en-GB",
      languageToolOrg = {
        username = lt_email,
        apiKey = lt_key,
      },
      languageToolHttpServerUri = "https://api.languagetoolplus.com",
      checkFrequency="save",
      -- additionalRules = {
      --      languageModel = '~/ngrams/',
      --    },
    },
  },
  filetypes = {"tex", "bib"},
})
vim.lsp.enable('ltex_plus')

vim.lsp.config("cmake", {})
vim.lsp.enable('cmake')

vim.lsp.config("texlab", {})
vim.lsp.enable('texlab')
-- vim.lsp.config('*', {
-- 	capabilities = {
-- 		textDocument = {
-- 			semanticTokens = { multilineTokenSupport = true }
-- 		}
-- 	},
-- 	root_markers = { '.git' },
-- })
vim.lsp.config('harper', {
	cmd = { 'harper-ls', '--stdio' },
	filetypes = {'tex', 'latex', 'markdown', 'text', 'typst' },
})
-- vim.lsp.enable("harper")

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
vim.cmd('highlight Comment cterm=italic')
