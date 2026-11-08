vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"Jenkinsfile"},
    command = "set filetype=groovy",
})
local lsp = require('lsp-zero')
local robot_auto_test_dir = os.getenv("ROBOT_AUTO_TEST_DIR")
local home_dir = os.getenv("HOME")

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr, exclude = {"gd", "gr", "C-p"},})
end)

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

-- C/C++ (clangd)
vim.lsp.config("clangd",{
    filetypes = {'c', 'cpp', 'objc', 'cuda'},
    on_new_config = function (config, root_dir)
        local oai_path = '/home/dmmuon/openairinterface5g'
        if vim.startswith(root_dir, oai_path) then
            config.cmd = {'clangd', '--compile-commands-dir=/home/dmmuon/openairinterface5g/cmake_targets/ran_build/build/'}
        end
    end
})
vim.lsp.enable('clangd')

-- robotframework (robotframework_lsp)
vim.lsp.config("robotframework_ls",{
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
vim.cmd('highlight Comment cterm=italic')
