Dotfiles for my neovim config

Total plugins: 27 (by Lazy)

Note: If on Ubuntu 18.04 or lower, build neovim from source to have neovim >= 0.9

## Setup

```bash
chmod +x setup.sh
./setup.sh
```

## LSP server installation

### Python (with `pylsp`)

```bash
pip install python-lsp-server
pip install pylsp-mypy
pip install python-lsp-ruff
```
If you get an error similar to `install_requires` must be a string or list of strings
```bash
pip install -U setuptools
```

### C/C++ (with `clangd`)

```bash
sudo apt-get install clangd-12
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
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
