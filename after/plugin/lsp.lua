local lsp = require('lsp-zero')
local robot_auto_test_dir = os.getenv("ROBOT_AUTO_TEST_DIR")

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr, exclude = {"gd", "gr", "C-p"},})
end)

-- python (python-lsp-server + ruff_lsp)
require('lspconfig').pylsp.setup({
    root_dir = function(fname, _)
        local ret = require('lspconfig').util.find_git_ancestor(fname)
        return ret
    end,
    settings = {
        pylsp = {
            plugins = {
                -- formatter options
                black = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                -- linter options
                pylint = {
                    enabled = false,
                    args = {
                        '--max-line-length=120',
                        '--enable=useless-suppression',
                        '--disable=bad-option-value,duplicate-code,invalid-name, fixme, \
                                missing-docstring,\
                                protected-access,\
                                too-few-public-methods,\
                                too-many-arguments,\
                                too-many-instance-attributes,\
                                import-error,\
                                consider-using-f-string,\
                                logging-fstring-interpolation',
                        '--extension-pkg-allow-list=cv2,PySide2,PyQt5',
                    }
                },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
                ruff = { enabled = false },
                -- type checker
                pylsp_mypy = {
                    enabled = true,
                    live_mode = false,
                    overrides = {'--check-untyped-defs', '--always-false=PYQT5', '--always-true=PYSIDE2', '--always-false=PYQT4', '--always-false=PYSIDE', true},
                },
                -- auto-completion options
                jedi_completion = { fuzzy = true },
            },
        },
    },
})

require('lspconfig').ruff_lsp.setup({
    root_dir = function(fname, _)
        local ret = require('lspconfig').util.find_git_ancestor(fname)
        return ret
    end,
    configs = {
        ruff_lsp = {
            default_config = {
                cmd = { 'ruff-lsp' },
                filetypes = { 'python' },
                init_options = {
                    settings = {
                        args = {}
                    }
                }
            }
        }
    }
})
-- lua (lua_ls)
local lua_opts = lsp.nvim_lua_ls()
require('lspconfig').lua_ls.setup(lua_opts)

-- C/C++ (clangd)
require('lspconfig').clangd.setup({
    filetypes = {'c', 'cpp', 'objc', 'cuda'},
    on_new_config = function (config, root_dir)
        local stm32_project_path = '/home/muon/bare_metal_stm32'
        if vim.startswith(root_dir, stm32_project_path) then
            config.cmd = {'clangd', '--query-driver=/usr/bin/arm-none-eabi-gcc'}
        end
    end
})

-- robotframework (robotframework_lsp)
require('lspconfig').robotframework_ls.setup({
    on_new_config = function (config, root_dir)
        local auto_test_dir = '/home/muon/automated-testing'
        if vim.startswith(root_dir, auto_test_dir) then
            config.settings = {
                robot = {
                    python = {
                        executable = os.getenv("ROBOT_TEST_ENV_EXE")
                    }
                }
            }
        end
    end
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
        -- ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }
})

