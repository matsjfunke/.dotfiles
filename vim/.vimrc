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

" Syntax and filetype colorscheme
syntax enable
colorscheme habamax

" Automatically detect file type and apply syntax highlighting
filetype on
filetype indent on
filetype plugin on

" Define file types for specific file extensions
for ext in ['py', 'Dockerfile', 'docker-compose', 'html', 'css', 'json', 'csv', 'md', 'yaml', 'yml', 'sql']
  execute 'autocmd BufNewFile,BufRead *.' . ext . ' set filetype=' . ext
endfor

"disable arrow keys
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
