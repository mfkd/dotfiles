" vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'gruvbox-community/gruvbox'
Plug 'rust-lang/rust.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

call plug#end()

colo gruvbox
set bg=dark

let mapleader = ","
nmap <SPACE> ,

noremap <C-q> :confirm qall<CR>
nnoremap <Leader>w :w<CR>

nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-n> <cmd>Telescope live_grep<cr>
"
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

let g:netrw_banner = 0

" markdown file linewidth rule
augroup filetype_settings
  " Clear this autocmd group so that the settings won't get loaded over and
  " over again
  autocmd!

  au BufRead,BufNewFile *.md setlocal textwidth=80 spell spelllang=en_us complete+=kspell
  "au BufRead,BufNewFile *.tex setlocal spell spelllang=en_us complete+=kspell
  autocmd BufNewFile,BufReadPost aliasrc,ctl* setlocal filetype=sh
  autocmd BufNewFile,BufReadPost spec setlocal filetype=yaml
  autocmd FileType make setlocal noexpandtab
  autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
  autocmd BufNewFile,BufReadPost *.md,README setlocal filetype=markdown
  "autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet
  "--start-dir=" . expand('%:p:h') . "&" | redraw!

  for filetype in ['tex', 'plaintex', 'mail']
    exe 'autocmd FileType ' . filetype . ' setlocal spell'
  endfo

  for filetype in ['yaml', 'sql', 'ruby', 'html', 'css', 'xml', 'php', 'vim']
    exe 'autocmd FileType ' . filetype . ' setlocal sw=2 sts=2 ts=2'
  endfor

  for filetype in ['go']
    exe 'autocmd FileType ' . filetype . ' setlocal textwidth=99'
  endfor

augroup END

augroup modechange_settings
  autocmd!

  " Clear search context when entering insert mode, which implicitly stops the
  " highlighting of whatever was searched for with hlsearch on. It should also
  " not be persisted between sessions.
  autocmd InsertEnter * let @/ = ''
  autocmd BufReadPre,FileReadPre * let @/ = ''

  autocmd InsertLeave * setlocal nopaste

  " Jump to last position in file
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

  " Balance splits on window resize
  autocmd VimResized * wincmd =
augroup END

filetype plugin indent on
syntax on

set display=truncate
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line
set history=200		" keep 200 lines of command line history
set clipboard=unnamed
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set undofile
set splitright
set number
set autoindent
set relativenumber
set incsearch
set ignorecase
set linebreak
set smartcase
set cursorcolumn
set cursorline
set pastetoggle=<F2>
set shortmess=I
set backspace=indent,eol,start
set scrolloff=10
set hlsearch
set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key
set textwidth=79
set colorcolumn=+1
set spell

" centre cursor on screen
nnoremap <C-l> <C-l>zz

lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

highlight TrailingWhitespace ctermbg=red
call matchadd('TrailingWhitespace', '\s\+$')

lua require'lspconfig'.gopls.setup{on_attach=require'completion'.on_attach}
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" Avoid showing message extra message when using completion
set shortmess+=c

nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vsd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <leader>vn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>vll :lua vim.lsp.diagnostic.set_loclist()<CR>
