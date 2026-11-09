Dotfiles for my neovim config

Plugins are managed by lazy.nvim and pinned in `lazy-lock.json`.

Requires Neovim 0.12 or later, because the `main` branch of nvim-treesitter does not support older versions.

## Setup

`setup.sh` installs `ripgrep` and `tree-sitter-cli`. It needs `cargo`.

```bash
chmod +x setup.sh
./setup.sh
```

## LSP server installation

Default server configs come from nvim-lspconfig. My overrides are in `after/lsp/<server>.lua`, and the list of enabled servers is in `after/plugin/lsp.lua`.

### Python (with `pylsp` and `ruff`)

```bash
pip install python-lsp-server
pip install pylsp-mypy
pip install ruff
```
If you get an error similar to `install_requires` must be a string or list of strings
```bash
pip install -U setuptools
```

### C/C++ (with `clangd`)

```bash
sudo apt-get install clangd-18
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-18 100
```

### Robotframework (with `robotframework_lsp`)

```bash
pip install robotframework-lsp
```

### Lua (with `lua_ls`)

```bash
git clone https://github.com/LuaLS/lua-language-server
cd lua-language-server
./make.sh
```

Then add `lua-language-server` in `bin` folder to `PATH`

### Latex
```bash
sudo apt install latexmk
cargo install --git https://github.com/latex-lsp/texlab --locked --tag v5.21.0
```

Grammar checking uses `ltex-ls-plus`, which needs to be on `PATH`.
