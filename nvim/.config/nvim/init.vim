" init.vim
" vim: undofile

" source /etc/vimrc

set tabstop=4       " Number of spaces that a <Tab> in the file counts for.
set shiftwidth=0    " Number of spaces to use for each step of (auto)indent.
set noexpandtab     " Do not use the appropriate number of spaces to insert a <Tab>.
set showmatch       " When a bracket is inserted, briefly jump to the matching
set ignorecase      " Ignore case in search patterns.
set smartcase       " Override 'ignorecase' if the pattern contains upper case

set background=dark
set mouse=a         " Enable the use of the mouse.
set laststatus=1    " Only show statusline when change
"Does not feel safe for root
set modeline        " Enable in-file "modeline" configuration
set number

set cmdheight=2

syntax on
filetype indent plugin on

let g:tex_flavor='latex'

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
hi DiffText NONE ctermbg=88
hi DiffAdd NONE ctermbg=18
hi DiffChange NONE ctermbg=17
hi DiffDelete NONE ctermfg=124

hi Tab NONE ctermfg=237

"" generic markup
"autocmd FileType *sh  :call matchadd('Type', '^##.*', 100)
call matchadd('Tab', '	', 1000) "TODO more comment denotators?
if (&ft!='markdown')
	:call matchadd('Type', '^\s*\([#;!"]\)\1.*', 100) "
	:call matchadd('Type', '/\*\*.*\*\*/', 100) "TODO more comment denotators?
endif

"" filetype specifics
autocmd Filetype text :call matchadd('Type', '^\[[^\]]*\]', 100)
autocmd Filetype yaml set shiftwidth=2 expandtab
autocmd Filetype python set tabstop=3 noexpandtab

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
autocmd BufWritePost,BufLeave,WinLeave ?* if &fdm == 'manual' | silent! mkview | endif
autocmd BufWinEnter ?* if &fdm == 'manual' | silent! loadview | endif

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
inoremap <M-BS> <C-w>

set undofile
