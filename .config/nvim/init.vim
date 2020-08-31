" =/ init.vim ale-cci /=
set nocompatible
set title

let mapleader=" "

" Top 10 typos {{{
ia fucntion function
ia cosnt const
ia heigth height
ia widht width
" }}}

" No backup files {{{
set noswapfile
set nobackup
set nowritebackup
set shada="NONE"
" }}}

" Indent with spaces instead of tabs {{{
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
" }}}

" Plugins {{{
call plug#begin()
Plug 'ale-cci/aqua-vim'
" Plug 'ale-cci/vimdoc'
Plug 'junegunn/seoul256.vim'

" Jsx syntax {{{
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
" }}}

nnoremap <leader>P :CtrlPClearCache<cr>
let g:ctrlp_map = '<leader>p'
Plug 'https://github.com/kien/ctrlp.vim.git' " Fuzzy file search

" Latex {{{
let g:tex_flavor='latex'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:tex_conceal='abdmg'
Plug 'lervag/vimtex'
" }}}

" Language specific compilers for TDD {{{
Plug 'haginaga/vim-compiler-phpunit'        " Phpunit compiler
" }}}

Plug 'tpope/vim-unimpaired'         " encodng/quickfix/buffer navigation shortcuts
Plug 'tpope/vim-dispatch'           " Async execution of programs
Plug 'tpope/vim-eunuch'             " Unix integration
Plug 'tpope/vim-fugitive'           " Git integration
Plug 'tpope/vim-rhubarb'            " github preview
Plug 'tpope/vim-surround'           " -
Plug 'tpope/vim-git'                " -

Plug 'turbio/bracey.vim'            " Static site preview

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

" Plug 'christoomey/vim-tmux-navigator'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
" inoremap <silent><expr> <c-space> coc#refresh()

Plug 'lepture/vim-jinja'            " Jinja syntax highlight
Plug 'fatih/vim-go'

call plug#end()
" }}}

" Appearance {{{
syntax enable
" colorscheme aqua-vim
set notermguicolors
let g:seoul256_background=233
colorscheme seoul256

set relativenumber
set notermguicolors

" Add Fugitive to status line
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set cursorline
set laststatus=1

" Show invisible characters
set showbreak=↪\
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set list

" Highlight java primitives
let java_highlight_java_lang_ids=1
" }}}

" Transparent editing of GPG encrypted files {{{
augroup encrypted
    au!
    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg set bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
    autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
    autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg set nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg set bin
    autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
    autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
    autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --encrypt --default-recipient-self 2>/dev/null
    autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost  *.gpg silent u
    autocmd BufWritePost,FileWritePost  *.gpg set nobin
augroup END
" }}}

" Custom functions {{{

" Run command in a dedicated terminal window {{{
function! RunCommand(name)
    let l:bufname = "[ NEOTERM ]"
    let win_nr = bufwinnr(l:bufname)
    if win_nr > 0
        let bnr = bufnr(l:bufname)
        :exe win_nr."wincmd w"
        :exe "e term://".a:name
        :exe bnr."bd!"
    else
        " Create new Terminal if the other one is not found
        silent exe 'aboveleft 15sp term://'.a:name
    endif
    :exe "file ".l:bufname
    exe winnr("#")."wincmd w"
endfunction
" }}}

" Buffer for temporary notes {{{
function! SwBuffer()
    let l:filename="NOTE.md"

    let win_nr = bufwinnr(l:filename)
    if  win_nr > 0
        :exe win_nr."wincmd w"
    else
        :rightbelow vert 80new
        let bnr = bufnr(l:filename)
        echom bnr
        if bnr > 0
            :exe "buffer ".bnr
        else
            :exe "file ".l:filename
        endif
    endif
endfunction
"}}}

" Resize vertical window with percentage
command! -nargs=1 Vpresize :exec 'vert resize '.string(&columns * <args> / 100)
"}}}

" Custom Key Mappings {{{
" noremap <F9> :call RunCommand('')<left><left>
" noremap <leader> :call RunCommand("compiler ".expand("%"))<cr>

nnoremap <Esc> :w<cr>

" nnoremap <leader><tab> :call SwBuffer()<cr>
nnoremap <leader>t :TestNearest<CR>
nnoremap <leader>T :TestSuite<CR>
nnoremap <silent> <leader>a :A<CR>
nnoremap <silent> <leader>A :AV<CR>

nnoremap <leader>c :Make<cr>

" Center matches
map n nzz
map N Nzz

" map escape sequence for terminal buffer
tmap <esc> <C-\><C-n>

" Incremental search

nnoremap <silent> <cr> :nohlsearch<CR>
vnoremap < <gv
vnoremap > >gv

" Copy to primary clipboard
vnoremap + "+y

" Faster Scrolling
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>


nnoremap <M-w> :bd!<cr>

" Close quickfix list
nnoremap <silent> <leader>q :ccl<cr>:lcl<cr>

" Function keys {{{
" <F1>  Current vim Syntax tag, Maybe should be in a easily callable command?
" <F2>
" <F3>
" <F4>
" <F5>
" <F5>
" <F6>
" <F7>
" <F8>  Debugger/Test
" <F9>  Compile & Run
" <F10> Compile / Package
" <F11> Rebuild tags for current type of file
" <F12> TODO list

" Print syntax group of word under the cursor
nnoremap <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


nnoremap <F8> :Make test<cr>
nnoremap <F9> :Make clean package<cr>
nnoremap <F10> :Make compile<cr>
nnoremap <F11> :!ctags **/*.%:e<cr>
nnoremap <F12> :grep TODO **/*.*<cr>
" }}}

" }}}

" AutoCmds & File Type AutoCmds {{{
augroup aug
    au!

    " Reload folds previously saved with mkview
    au BufWinEnter * silent! loadview

    au BufWritePost init.vim source %
    au BufWritePost .tmux.conf :!tmux source-file %

    au FileType asm set ft=nasm
    au FileType asm set expandtab

    au FileType vim nnoremap <buffer> <leader>c :PlugClean<cr>
    au FileType vim nnoremap <buffer> <leader>i :PlugInstall<cr>
    au FileType vim nnoremap <buffer> <leader>u :PlugUpdate<cr>
    au FileType vim setlocal foldmethod=marker

    au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    au FileType html setlocal ts=2 sts=2 sw=2
    au FileType css setlocal ts=2 sts=2 sw=2
    au FileType javascript setlocal ts=2 sts=2 sw=2 expandtab

    au FileType php nmap <leader>c :Dispatch php -l %<cr>

    au FileType java nnoremap <leader>c :Dispatch mvn compile<cr>
    au FileType java nnoremap <leader>s :Dispatch mvn checkstyle:check<cr>
    au FileType java setlocal fmr=/**,*/ fdm=marker
    au FileType java setlocal makeprg=mvn
    au FileType java set cinoptions=j1,(s,m1,ks,l1,U1,w1,W4
    au FileType java nnoremap <leader>t :Dispatch mvn test<cr>
    au FileType pom nnoremap <leader>t :Dispatch mvn test<cr>
    au FileType pom setlocal makeprg=mvn


    au FileType haskell setlocal makeprg=ghc\ -dynamic
    au FileType haskell nnoremap <buffer> <leader>c :Make %<cr>

    " Run unittest on the current file
    au FileType python nnoremap <leader>t :!python -m unittest %<cr>
    au FileType python nnoremap <leader>s :!pylint\ --reports=n\ --output-format=parseable\ %:p
    au FileType python set makeprg=python\ -m\ doctest\ %
    au FileType python set errorformat=%f:%l:\ %m
    au FileType python setlocal foldmethod=expr foldexpr=getline(v:lnum)=~'^\s*#'

    " au FileType rust :setlocal makeprg=rustc

    au FileType sh nnoremap <leader>s :Dispatch shellcheck %<cr>

    " Markdown preview
    au FileType markdown nnoremap <leader>md :MarkdownPreview<cr>

    au BufNewFile *.html :.!cat ~/.config/nvim/templates/html.skel

    au FileType tex nnoremap <leader>c :VimtexCompile<cr>
    au FileType tex setlocal spell
    au FileType tex setlocal spelllang=it_it,en_us
    au FileType tex setlocal conceallevel=1
    au FileType tex setlocal colorcolumn=120

    au FileType scss nnoremap <leader>c :execute('!sass % '.substitute(expand('%'), 'scss', 'min.css', ''))<cr>

    au FileType go nnoremap <leader>d :GoDoc<cr>
    au FileType go nnoremap <leader>o :GoCoverageToggle<cr>
    au FileType go nnoremap <leader>c :GoTestBuild<cr>
    au FileType go nnoremap <leader>t :GoTest<cr>
    au FileType go nnoremap <M-b> :GoDebugBreakpoint<cr>
    au FileType go nnoremap <F9> :GoDebugTest<cr>
    au FileType go nnoremap <M-n> :GoDebugNext<cr>
    au FileType go nnoremap <M-t> :GoDebugStep<cr>
    au FileType go nnoremap <M-x> :GoDebugStop<cr>
    au FileType go nnoremap <M-c> :GoDebugContinue<cr>

    " Hide numbers on terminal
    au TermOpen * setlocal nonumber norelativenumber

    " Remove trailing whitespaces
    au BufWritePre	* %s/\s\+$//e
augroup END
" }}}

" Custom Settings {{{
set mouse=a
set clipboard=unnamed
set scrolloff=2

" Indentation preferences
set cinoptions=j1,(s,m1,ks,l1,U1,w1,W4

set hlsearch
set incsearch
set smartcase

set hidden

set exrc
set secure


" Find files recursively under current directory
set path=$PWD/**

" Recognize alias
set shellcmdflag=-ic
" set signcolumn=yes:1
" }}}

" Latex precompiled
set wildignore+=*.aux,*.log,*.fls,*.synctex.gz,*.sinctex(busy),*fdb_latexmk,*.out,*.toc,*.ilg,*.ind,*.idx,*.xdv,*.pdf
set wildignore+=*.pyc,*.obj,*.o,*.git,*.class,tags,*.lock,*.jar
set wildignore+=*/node_modules/*,*/vendor/*
