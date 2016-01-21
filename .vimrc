execute pathogen#infect()
syntax on
filetype plugin indent on

colorscheme elflord

set encoding=utf-8
set ts=4
"set number
"set ruler
set autoindent
set showmatch

set hlsearch 	    "Highlight search results
set ignorecase		"When doing a search, ignore the case of letters
set smartcase		"Override the ignorecase option if the search pattern contains upper case letters
"Clear the search highlight by pressing ENTER when in Normal mode (Typing commands)
:nnoremap <CR> :nohlsearch<CR>/<BS><CR>


"-- Tabbed Editing --
""Open a new (empty) tab by pressing CTRL-T. Prompts for name of file to edit
map <C-T> :tabnew<CR>:edit 
"Open a file in a new tab by pressing CTRL-O. Prompts for name of file to edit
"map <C-O> :tabfind 
""Switch between tabs by pressing Shift-Tab
map <S-Tab> gt

"-- Tweaks --
""Add tweak for better backspace support
set backspace=indent,eol,start
