call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'tpope/vim-rhubarb'
Plug 'gruvbox-community/gruvbox'
Plug 'rust-lang/rust.vim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'sbdchd/neoformat'
Plug 'ntpeters/vim-better-whitespace'
Plug 'glepnir/lspsaga.nvim'

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
nnoremap <leader>fb :lua require'telescope.builtin'.buffers{ show_all_buffers = true }<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <silent> <Leader>E :set wrap<CR>:setlocal formatoptions-=t<CR>:set textwidth=0<CR>
nnoremap <silent> <Leader>e :set nowrap<CR>:setlocal formatoptions+=t<CR>:set textwidth=79<CR>

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

let g:netrw_banner = 0

augroup filetype_settings
  " Clear this autocmd group so that the settings won't get loaded over and
  " over again
  autocmd!

  autocmd BufNewFile,BufReadPost aliasrc,ctl* setlocal filetype=sh
  autocmd BufNewFile,BufReadPost spec setlocal filetype=yaml
  autocmd BufNewFile,BufReadPost *.md,README setlocal filetype=markdown
  autocmd BufRead,BufNewFile ~/.local/share/nota/* setlocal filetype=markdown

  for filetype in ['yaml', 'sql', 'ruby', 'html', 'css', 'xml', 'php', 'vim']
    exe 'autocmd FileType ' . filetype . ' setlocal sw=2 sts=2 ts=2'
  endfor

  for filetype in ['go']
    exe 'autocmd FileType ' . filetype . ' setlocal textwidth=99 shiftwidth=8'
  endfor

  for filetype in ['rs']
    exe 'autocmd FileType ' . filetype . ' setlocal textwidth=99 shiftwidth=4 tabstop=4 expandtab'
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
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " Balance splits on window resize
  autocmd VimResized * wincmd =
augroup END

filetype plugin indent on
syntax on

set shiftwidth=4
set shiftround
set undofile
set number
set autoindent
set relativenumber
set incsearch
set ignorecase
set linebreak
set smartcase
set nowrap
set cursorcolumn
set cursorline
set shortmess=I
set backspace=indent,eol,start
set scrolloff=15
set hlsearch
set textwidth=79
set colorcolumn=+1
set spell
set synmaxcol=1000

" centre cursor on screen
nnoremap <C-l> <C-l>zz

lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

lua require('telescope').load_extension('fzy_native')

lua require'lspconfig'.gopls.setup{}
lua require'lspconfig'.rust_analyzer.setup{}
lua require'lspconfig'.ccls.setup{}

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" nvim-compe configuration
set completeopt=menuone,noselect

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
