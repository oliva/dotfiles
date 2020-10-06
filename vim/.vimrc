" .vimrc
" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details
" vim: undofile

source /etc/vimrc

" For multi-byte character support (CJK support, for example):
"set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1

set tabstop=4       " Number of spaces that a <Tab> in the file counts for.

set shiftwidth=0    " Number of spaces to use for each step of (auto)indent.

set noexpandtab     " Use the appropriate number of spaces to insert a <Tab>.
                    " Spaces are used in indents with the '>' and '<' commands
                    " and when 'autoindent' is on. To insert a real tab when
                    " 'expandtab' is on, use CTRL-V <Tab>.

set smarttab        " When on, a <Tab> in front of a line inserts blanks
                    " according to 'shiftwidth'. 'tabstop' is used in other
                    " places. A <BS> will delete a 'shiftwidth' worth of space
                    " at the start of the line.

set showcmd         " Show (partial) command in status line.

"set number         " Show line numbers.

set showmatch       " When a bracket is inserted, briefly jump to the matching
                    " one. The jump is only done if the match can be seen on the
                    " screen. The time to show the match can be set with
                    " 'matchtime'.

set hlsearch        " When there is a previous search pattern, highlight all
                    " its matches.

set incsearch       " While typing a search command, show immediately where the
                    " so far typed pattern matches.

set ignorecase      " Ignore case in search patterns.

set smartcase       " Override the 'ignorecase' option if the search pattern
                    " contains upper case characters.

set backspace=2     " Influences the working of <BS>, <Del>, CTRL-W
                    " and CTRL-U in Insert mode. This is a list of items,
                    " separated by commas. Each item allows a way to backspace
                    " over something.

set autoindent      " Copy indent from current line when starting a new line
                    " (typing <CR> in Insert mode or when using the "o" or "O"
                    " command).

"set textwidth=79    " Maximum width of text that is being inserted. A longer
                    " line will be broken after white space to get this width.

  " For all text files set 'textwidth' to 78 characters.
"  autocmd FileType text setlocal textwidth=78

set formatoptions=c,q,r,t " This is a sequence of letters which describes how
                    " automatic formatting is to be done.
                    "
                    " letter    meaning when present in 'formatoptions'
                    " ------    ---------------------------------------
                    " c         Auto-wrap comments using textwidth, inserting
                    "           the current comment leader automatically.
                    " q         Allow formatting of comments with "gq".
                    " r         Automatically insert the current comment leader
                    "           after hitting <Enter> in Insert mode.
                    " t         Auto-wrap text using textwidth (does not apply
                    "           to comments)

set ruler           " Show the line and column number of the cursor position,
                    " separated by a comma.

set background=dark " When set to "dark", Vim will try to use colors that look
                    " good on a dark background. When set to "light", Vim will
                    " try to use colors that look good on a light background.
                    " Any other value is illegal.

set mouse=a         " Enable the use of the mouse.

filetype detect
filetype plugin on
filetype indent on
syntax on

"autocmd FileType text ab \n \newline

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

"if has("vms")
"  set nobackup     " do not keep a backup file, use versions instead
"else
"  set backup       " keep a backup file
"endif
set history=256  " keep 65536 lines of command line history


" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Not-so copypasted options

"52 for dim red, 235 for dim gray
highlight ColorColumn NONE ctermbg=52
call matchadd('ColorColumn', '\%81v', 100)
call matchadd('ColorColumn', '\%73v', 100)

set listchars=tab:»\ ,nbsp:~,trail:·

hi SpecialKey ctermfg=darkgrey
set list

"set spell
set spelllang=en,hu
hi spellBad cterm=undercurl ctermfg=red ctermbg=none

"line number colouring
hi LineNr ctermfg=gray

" vimdiff colors for bg=dark
"TODO for gui
hi DiffText NONE ctermbg=88
hi DiffAdd NONE ctermbg=53
hi DiffChange NONE ctermbg=17
hi DiffDelete NONE ctermbg=52 ctermfg=Red

"" generic markup
"autocmd FileType *sh  :call matchadd('Type', '^##.*', 100)
if (&ft!='markdown')
  :call matchadd('Type', '^\s*\([#;!"]\)\1.*', 100) "
  :call matchadd('Type', '/\*\*.*\*\*/', 100) "TODO more comment denotators?
endif
autocmd Filetype text :call matchadd('Type', '^\[[^\]]*\]', 100)

"" folding
set foldnestmax=4
set foldminlines=8
set foldlevel=0
set foldcolumn=1
if &diff
  set foldmethod diff
endif
autocmd BufReadPre * setlocal foldmethod=syntax
"autocmd BufWinEnter * if &fdm == 'syntax' | setlocal foldmethod=manual | endif

"" view
set viewoptions-=options
autocmd BufWritePost,BufLeave,WinLeave ?* if &fdm == 'manual' | silent mkview | endif
autocmd BufWinEnter ?* if &fdm == 'manual' | silent loadview | endif

"" simple remaps
 "saving
inoremap <C-w> :wa
nnoremap <C-w> :w
 "quitting
inoremap <C-q> :q
vnoremap <C-q> :q
nnoremap <C-q> :q
 "making
inoremap <C-s> :make!:make! cleana
nnoremap <C-s> :make!:make! clean
  "delete word
inoremap <Char-0x00> aa

""" Cut here for root """

set undofile

" gvim settings
if has('gui_running')
  set guifont=Inconsolata\ Medium\ 12
  "cterm-like colors
  set background=dark
  hi SpecialKey guifg=Blue
  hi MoreMsg guifg=Green
  "hi Visual guifg=NONE guibg=NONE
  hi Folded ctermbg=4 guibg=Blue
  hi FoldColumn ctermbg=7
  "must be set explicitly, bg=dark doesn't help
  hi Normal guifg=White guibg=Black
"[above are  uncorrected]
  "CursorColumn, Cursorline omitted, as they are logical
  hi ColorColumn guibg=#262626 "#5f0000
  hi Cursor guibg=fg guifg=bg
  hi lCursor guibg=fg guifg=bg
  hi Comment guifg=Cyan
  hi Constant guifg=Magenta
  hi Special guifg=#ffdfdf
  hi Identifier gui=bold guifg=Cyan
  hi Statement guifg=Yellow
  hi PreProc guifg=#5fd7ff
  hi Type guifg=#87ffaf
  hi Underlined guifg=#5fd7ff
  hi Todo guifg=Black
endif

" dragvisuals package
runtime plugin/dragvisuals.vim
vmap  <expr>  <S-LEFT>   DVB_Drag('left')
vmap  <expr>  <S-RIGHT>  DVB_Drag('right')
vmap  <expr>  <S-DOWN>   DVB_Drag('down')
vmap  <expr>  <S-UP>     DVB_Drag('up')
vmap  <expr>  D          DVB_Duplicate()
