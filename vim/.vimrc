if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Use :help 'option' to see the documentation for the given option.

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

set ttimeout
set ttimeoutlen=100

" Show search results as we type
set incsearch

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Show the command as it's being typed
set showcmd

" Set up replacement characters for trailing spaces, tabs, and linebreaks
set list listchars=tab:>\ ,trail:_,extends:>,precedes:<,nbsp:~

" Change the timeout delay between pressing a key and waiting for next input
set ttimeout ttimeoutlen=100

" Show line / column information, always
set ruler
set laststatus=2
set colorcolumn=84

" VIM command completion menu
set wildmenu

" Show line numbers in the gutter, relative to the line the caret is on
set number relativenumber

" Automatically re-read a file if it changed externally
set autoread

if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags^=./tags;
endif

set fileformats+=mac

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif


" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

inoremap <C-U> <C-G>u<C-U>

" Open FZF with the Ctrl-P mapping
noremap <C-P> :FZF<CR>

set background=dark
colorscheme solarized
let g:solarized_termcolors=256

let $FZF_DEFAULT_COMMAND = 'find . -type f'

let g:ale_open_list = 1
let g:ale_keep_list_window_open = 1
