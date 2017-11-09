call plug#begin('~/.config/nvim/plugged')
Plug 'joshdick/onedark.vim'
Plug 'b4b4r07/vim-hcl'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'bling/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'neomake/neomake'
Plug 'digitaltoad/vim-pug'
call plug#end()


map <F3> :NERDTreeToggle<CR>

syntax on
colorscheme onedark
let vim_markdown_preview_github=1
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set relativenumber
set number
