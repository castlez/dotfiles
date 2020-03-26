"scriptencoding utf-8
"set encoding=utf-8

"*****************************************************************************
"" Vim-PLug core (plugin stuff from matts vimrc)
" to install:
" :so ~/.vimrc
" :PlugInstall
"*****************************************************************************
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')
let g:vim_bootstrap_langs = "c,go,html,javascript,python,rust,typescript"
let g:vim_bootstrap_editor = "vim"             " nvim or vim

if !filereadable(vimplug_exists)
    echo "Installing Vim-Plug..."
    echo ""
    silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let g:not_finish_vimplug = "yes"
    autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

" fancy status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax Checking
" need pylint for python syntax (pip install pylint)
" updates on write
Plug 'scrooloose/syntastic'

call plug#end()
" *****************************************************************************

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab

" line numbers
set number

" enable mouse for everything
set mouse=a

" colorscheme
colorscheme slate

" auto indent
set autoindent

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Move between panes
noremap <Home> <C-W>k
inoremap <Home> <Esc> <C-W>k i
noremap <End> <C-W>j
inoremap <End> <Esc> <C-W>j i

" go to tag, put result in new tab if only one, or vsplit if more than one (id
" prefer just going to a new tab, but this macro cant handle if there are 
" multiple options properly. if its vsplit, is <C-W><S-T> to put it into a tab)
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR> <C-W><S-T>

" Syntax on
syntax on

" whitespace highlighting for lone spaces and tabs
set list
set listchars=tab:➞\ ,extends:›,precedes:‹,nbsp:·,trail:•

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Syntax for asciidoc files
autocmd BufRead,BufNewFile *.txt,*.asciidoc,README,TODO,CHANGELOG,NOTES,ABOUT
        \ setlocal autoindent expandtab tabstop=8 softtabstop=2 shiftwidth=2 filetype=asciidoc
        \ textwidth=70 wrap formatoptions=tcqn
        \ formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*<\\d\\+>\\s\\+\\\\|^\\s*[a-zA-Z.]\\.\\s\\+\\\\|^\\s*[ivxIVX]\\+\\.\\s\\+
        \ comments=s1:/*,ex:*/,://,b:#,:%,:XCOMM,fb:-,fb:*,fb:+,fb:.,fb:>


