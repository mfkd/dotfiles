colo gruvbox
set bg=dark

let mapleader = ","

nmap <SPACE> ,

noremap <C-q> :confirm qall<CR>
nnoremap <leader>s :!%:p
nnoremap <leader>S :!%:p<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :FZF<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>t :!cargo test<CR>
nnoremap <C-p> :Files<CR>
nnoremap <C-n> :Rg<CR>

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

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

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

" Quickly move around (and into) command mode
imap jk <Esc>
imap kj <Esc>:

" Give :terminal Esc behavior
tnoremap <Esc> <C-\><C-n>

" centre cursor on screen
nnoremap <C-l> <C-l>zz

highlight TrailingWhitespace ctermbg=red
call matchadd('TrailingWhitespace', '\s\+$')

" minpac
packadd minpac
let s:plugins = exists('*minpac#init')
if !s:plugins "{{{
  fun! InstallPlug() " Bootstrap plugin manager on new systems.
    exe '!git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac'
  endfun
else
call minpac#init({'verbose': 3})
" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Additional plugins here.
call minpac#add('junegunn/fzf.vim')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-endwise')
call minpac#add('tpope/vim-fugitive')
call minpac#add('gruvbox-community/gruvbox')
call minpac#add('fatih/vim-go')
call minpac#add('rust-lang/rust.vim')
call minpac#add('dense-analysis/ale')

" minpac utility commands
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()
command! PackStatus call minpac#status()

endif
