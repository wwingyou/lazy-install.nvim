# lazy-install.nvim

A Neovim plugin to make installing other plugins with `lazy.nvim` even easier.

## About

`lazy-install.nvim` provides a `:LazyInstall` command that takes a GitHub URL for a Neovim plugin. It automatically:

1.  Fetches the plugin's `README.md` file from GitHub.
2.  Searches the README for the `lazy.nvim` installation instructions.
3.  Creates a new Lua file in your `lua/plugins/` directory with the correct installation code.

If it can't find a specific code block, it will create a minimal working configuration for you.

## Installation

Install `lazy-install.nvim` using `lazy.nvim`:

```lua
{
  "wwingyou/lazy-install.nvim",
  -- Optional: configure options for the plugin
  opts = {}
}
```

## Usage

To install a new plugin, simply run the `:LazyInstall` command with the GitHub URL of the plugin you want to install.

For example:

```
:LazyInstall https://github.com/folke/tokyonight.nvim
```

This will create a new file, `~/.config/nvim/lua/plugins/tokyonight.lua` (or equivalent based on your OS), containing the necessary installation code found in the plugin's README.

You can then restart Neovim, and `lazy.nvim` will pick up the new plugin.
