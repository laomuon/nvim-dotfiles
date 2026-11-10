-- python (python-lsp-server, with ruff as a separate server)
local mypy_overrides = {'--check-untyped-defs', '--always-false=PYQT5', '--always-false=PYSIDE2', '--always-false=PYQT4', '--always-true=PYSIDE', true}

-- The project's venv: .venv if there is one, otherwise any folder in the root with a pyvenv.cfg
local function find_venv(root)
    if not root then return nil end
    local found
    for name, kind in vim.fs.dir(root) do
        if kind == 'directory' and vim.uv.fs_stat(root .. '/' .. name .. '/pyvenv.cfg') then
            if name == '.venv' then return root .. '/.venv' end
            found = found or root .. '/' .. name
        end
    end
    return found
end

return {
    root_markers = {'.git'},
    -- pylsp and mypy are uv tools, so they need to be pointed at the project's packages.
    -- An activated venv takes priority over the one in the project.
    before_init = function(_, config)
        local venv = vim.env.VIRTUAL_ENV or find_venv(config.root_dir)
        local plugins = config.settings.pylsp.plugins
        plugins.jedi = venv and { environment = venv } or nil
        plugins.pylsp_mypy.overrides = venv
            and vim.list_extend({'--python-executable', venv .. '/bin/python'}, mypy_overrides)
            or mypy_overrides
    end,
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
                    overrides = mypy_overrides,
                },
                -- auto-completion options
                jedi_completion = {
                    fuzzy = true,
                },
            },
        },
    },
}
