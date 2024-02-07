" Stop pretinding to be VI
set nocompatible

" Line numbers
set number
set relativenumber

" Automatic indentaion & line wrapping
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set wrap

" Enable mouse
set mouse=a

" Autocomplete suggestions
set wildmenu
set wildmode=list:longest,full

" Status line
set showmode
set statusline=%F\ %r%h%w
set laststatus=2

" Search
set incsearch
set nohlsearch

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Remap escape
inoremap kj <Esc>
vnoremap kj <Esc>
cnoremap kj <Esc>
