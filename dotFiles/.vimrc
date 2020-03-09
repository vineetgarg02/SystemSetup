
" pathogen
execute pathogen#infect()
syntax on
set nocompatible
filetype plugin indent on

set hlsearch
set number
set ignorecase
set smartcase
" colorscheme morning 
" colorscheme slate 

syntax enable
set background=dark
colorscheme solarized

set wrap

set cursorline

au BufRead,BufNewFile *.q set filetype=sql
" set runtimepath^=~/.vim/bundle/ctrlp.vim

" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2

" Convert slashes to backslashes for Windows.
if has('win32')
  nmap ,cs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap ,cl :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>

  " This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap ,c8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  nmap ,cs :let @*=expand("%")<CR>
  nmap ,cl :let @*=expand("%:p")<CR>
endif

set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
