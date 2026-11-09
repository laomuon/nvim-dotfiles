-- python (python-lsp-server, with ruff as a separate server)
return {
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
}
