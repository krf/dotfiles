" {{{ Syntax highlighting settings
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
" }}}

" {{{ Terminal fixes
if &term ==? "xterm"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif

if &term ==? "gnome" && has("eval")
  " Set useful keys that vim doesn't discover via termcap but are in the
  " builtin xterm termcap. See bug #122562. We use exec to avoid having to
  " include raw escapes in the file.
  exec "set <C-Left>=\eO5D"
  exec "set <C-Right>=\eO5C"
endif
" }}}

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
if has("autocmd")
  filetype indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes) in terminals

" Fix PgUp/PgDown, see
" http://vimrc-dissection.blogspot.com/2009/02/fixing-pageup-and-pagedown.html
noremap <silent> <PageUp> 1000<C-U>
noremap <silent> <PageDown> 1000<C-D>
inoremap <silent> <PageUp> <C-O>1000<C-U>
inoremap <silent> <PageDown> <C-O>1000<C-D>

" Make vim act a bit like nano
map <C-O> <Esc>:w<CR>
"imap <C-O> <Esc>:w<CR>
map <C-X> <Esc>:q<CR>
"imap <C-X> <Esc>:q<CR>
map <C-X><C-X> <Esc>:q!<CR>
"imap <C-X><C-X> <Esc>:q!<CR>
map <C-K> <Esc>dd
imap <C-K> <Esc>dd<Esc>i
map <C-U> <Esc>p
imap <C-U> <Esc>p<Esc>i

" More bindings
map <F3> :NERDTreeToggle<CR>

" Netrw
let g:netrw_altv = 1

" Make backspace act normal
set backspace=indent,eol,start

" Make Shift-Tab work
inoremap <S-Tab> <Esc><0<Esc>i

" Keep column on buffer changing commands (line up, down)
set nostartofline

" Map a `svn blame` shortcut
vmap gl :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Remove all trailing whitespaces at EOL
map <F5> :%s/\s\+$//<CR>

" Some more options
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set smarttab

" Show/hide line numbers
set number
map <F2> :set number!<CR>

" Stop auto indenting (important for copy&paste)
set pastetoggle=<F11>

" Color fixes
highlight PmenuSel ctermbg=6
highlight LineNr cterm=bold

" Highlight whitespaces at EOL
highlight WhitespaceEOL ctermbg=darkgreen guibg=darkgreen
match WhitespaceEOL /\s\+$/

" Compile current file
map <F9> :make<CR>

" Omnicppcomplete
set nocp
filetype plugin on
set completeopt=menu

let OmniCpp_ShowScopeInAbbr = 1
let OmniCpp_NamespaceSearch = 2
let OmniCpp_DisplayMode = 3
let OmniCpp_ShowPrototypeInAbbr = 1

inoremap <Nul> <C-x><C-o>

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#CompleteCpp

" Ctags
set tags+=~/.vim/tags/c++.ctags
set tags+=~/.vim/tags/python.ctags
map <silent><C-Left> <C-T>
map <silent><C-Right> <C-]>

" Cpp: Switch between source and header file
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" Cpp: Don't indent access modifiers
set cino=g0

" Compiler
autocmd BufRead *.java set makeprg=javac\ %
autocmd BufRead *.java map <F10> :make
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
 autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Colorscheme
colorscheme ansi_blows

" Move cursor by display line when wrapping.
" See: http://vim.wikia.com/wiki/Move_cursor_by_display_lines_when_wrapping
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
nnoremap <Home> g<Home>
nnoremap <End> g<End>
vnoremap <Down> gj
vnoremap <Up> gk
vnoremap <Home> g<Home>
vnoremap <End> g<End>
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
inoremap <Home> <C-o>g<Home>
inoremap <End> <C-o>g<End>

" wrap words
set wrap lbr
