#!/bin/sh
# Tools Neovim needs beyond its plugins:
# ripgrep for Telescope, tree-sitter-cli to build treesitter parsers
sudo apt-get install ripgrep
cargo install tree-sitter-cli --locked
