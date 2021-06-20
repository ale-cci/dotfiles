" =/ neovimrc /=
set nocompatible
set title

let mapleader=" "
let maplocalleader="\\"

set noswapfile nobackup nowritebackup

set et sw=4 sts=4 ts=4

call plug#begin()
Plug 'w0ng/vim-hybrid'
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall', { 'branch': 'main'}

Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'Vimjas/vim-python-pep8-indent'
call plug#end()

" Telescope bindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

nnoremap <leader>` :lua vim.lsp.buf.code_action()<cr>
nnoremap <leader>c :lua vim.lsp.buf.formatting()<cr>
nnoremap <leader>rn :lua vim.lsp.buf.rename()<cr>
nnoremap gd :lua vim.lsp.buf.definition()<cr>

set termguicolors
colorscheme hybrid

set mouse=a clipboard=unnamed scrolloff=2
set hlsearch incsearch smartcase
set hidden

set cursorline
set showbreak=↪\
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set list
set rnu
set colorcolumn=80

lua <<END
-- Language server config
require'lspinstall'.setup()
local completion = require'completion'

local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{ on_attach=completion.on_attach }
end
END

nnoremap n nzz
nnoremap N Nzz
nnoremap <silent> <M-cr> :nohlsearch<CR>

augroup aug
    au!
    au BufWritePre	* %s/\s\+$//e
    au FileType javascript setlocal et ts=2 sw=2 sts=2
    au FileType typescriptreact setlocal et ts=2 sw=2 sts=2
    au FileType html setlocal et ts=2 sw=2 sts=2
    au FileType yaml setlocal et ts=2 sw=2 sts=2
    au FileType go setlocal noet ts=4 sw=4 sts=4
augroup END

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

" Latex precompiled
set wildignore+=*.aux,*.log,*.fls,*.synctex.gz,*.sinctex(busy),*fdb_latexmk,*.out,*.toc,*.ilg,*.ind,*.idx,*.xdv,*.pdf
" Binaries
set wildignore+=*.pyc,*.obj,*.o,*.git,*.class,tags,*.lock,*.jar
" External libraries or modules
set wildignore+=*/node_modules/*,*/vendor/*
