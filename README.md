## VSCode

Backup your current `settings.json` and `keybindings.json` before run the following command.

```sh
ln -sv ~/dotfiles/VSCode/settings.json /<vscode-path>/settings.json
ln -sv ~/dotfiles/VSCode/keybindings.json /<vscode-path>/keybindings.json
```

## AstroNvim

Install AstroNvim then run:

- For Neovim 0.8+ (NOT including nightlty) and AstroNvim v3 (Maybe somewhere around `v3.3x.x`):

  ```sh
  ln -sv ~/dotfiles/astroNvim/.config/nvim/lua/user  ~/.config/nvim/lua/user
  ```

### ColorScheme

- [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)

### Plugins

- [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)

## Vim

If the italic does not work.

Please see: https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/ and https://stackoverflow.com/questions/3494435/vimrc-make-comments-italic.

In some cases, when type <backspace> will produce a space. It's seems that the $TERM causing the issue. I don't know how to fix it yet.

```sh
ln -b -S '.backup' -sv ~/dotfiles/.vimrc ~/.vimrc
mv ~/.vim ~/.vim.backup
ln -sv ~/dotfiles/.vim/ ~/.vim
```

### Plugins

- YouCompleteMe

Please follow the [Installation document](https://github.com/ycm-core/YouCompleteMe#installation) to install.
