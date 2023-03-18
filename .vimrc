set cursorline
set number relativenumber
set hlsearch
set tabstop=2
set softtabstop=2
set shiftwidth=2
set scrolloff=999
set nocompatible
set encoding=UTF-8 "for vim-devicons
set nofoldenable
set foldmethod=indent

"""""""""""""""""""""""""""""""""""""""""""""""""
" Statusline
set laststatus=2
set noshowmode
"let g:lightline = {
"  \ 'colorscheme': 'onedark',
"  \ }
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
call plug#begin()
Plug 'scrooloose/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot' " for better hightlight
Plug 'itchyny/lightline.vim'
"Plug 'joshdick/onedark.vim'
Plug 'rakr/vim-one'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'terryma/vim-multiple-cursors'
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" true color setting
" source: https://github.com/rakr/vim-one#true-color-support
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme
syntax on
set bg=dark
"colorscheme risto
"colorscheme onedark
" let g:one_allow_italics=1
colorscheme one
" highlight Comment cterm=italic
"""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
" Keymaps
let mapleader = " "
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>e :NERDTreeToggle<CR>
nnoremap <Leader>ff :Files<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""

