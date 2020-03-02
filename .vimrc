let mapleader=' '

" General
syntax on
au! BufWritePre	* %s/\s\+$//e

set nocompatible
set backspace=indent,start,eol
set scrolloff=2
set path=.,**

set wildmenu
set wildignore+=*.pyc
set wildmode=longest:full

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

nnoremap <Leader>p :find<space>
