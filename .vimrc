let mapleader=' '

" General
syntax on
set nocompatible
set backspace=indent,start,eol
set scrolloff=2

set wildignore+=*.pyc

" Appearence
set numberwidth=4
set relativenumber
set ruler
set cursorline


" Indentation
set shiftwidth=4
set tabstop=4


" Disable backup files
set nobackup
set noswapfile
set nowritebackup


" Incremental search
set hlsearch
set incsearch


" Key Mappings 
nnoremap <silent> <CR> :nohl<CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap <Leader><Tab> :30Lexplore<cr>
