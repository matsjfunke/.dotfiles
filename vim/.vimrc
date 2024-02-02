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

syntax enable

" Autocomplete suggestions
set wildmenu
set wildmode=list:longest,full

" Status line
set showmode
set statusline=%F\ %m%r%h%w
set laststatus=2

"disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" Search
set incsearch
set nohlsearch
