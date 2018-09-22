"----------------------------------------------
" Initialization settings
"----------------------------------------------

" Specify a directory for plugins
call plug#begin('~/.config/nvim/plugged')

" Theme
Plug 'https://github.com/joshdick/onedark.vim.git'

" General plugins
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Language support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Initialize plugin system
call plug#end()
