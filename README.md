# NEOVIM Config

## Introduction

This is my personal configuration for [**neovim**](https://neovim.io/).
The idea of this **README.MD** is to track all the plugins and custom configs, forcing myself to keep it up to date, i should be able to dig into vim, neovim and custom configurations.

## Plugins

List of plugins installed, using [**packer**](https://github.com/wbthomason/packer.nvim) as plugin manager

| Plugin | Git Repo |
| --- | --- |
| telescope | [URL](https://github.com/nvim-telescope/telescope.nvim) |
| onedark | [URL](https://github.com/navarasu/onedark.nvim?tab=readme-ov-file) |
| treesitter | [URL](https://github.com/nvim-treesitter/nvim-treesitter) |
| treesitter playground | [URL](https://github.com/nvim-treesitter/playground?tab=readme-ov-file) |
| undotree | [URL](https://github.com/mbbill/undotree) |
| fugitive | [URL](https://github.com/tpope/vim-fugitive) |
| lsp-zero | [URL](https://github.com/VonHeikemen/lsp-zero.nvim) |

## Options

Custom options can be found inside `set.lua`, for a list of available options check [Nvim docs](https://neovim.io/doc/user/quickref.html)

| Option | Set Value |
| --- | --- |
| nu | true |
| relativenumber | true |
| tabstop | 2 |
| softtabstop | 2 |
| shiftwidth | 2 |
| expandtab | true |
| smartindent | true |
| swapfile | false |
| backup | false |
| undofile | true |
| undodir | os.getenv("HOME") .. "/.config/nvim/undodir" |
| hlsearch | false |
| incsearch | true |
| vim.scrolloff | 10 |
| clipboard | unnamed |
