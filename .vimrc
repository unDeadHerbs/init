set nocompatible               " This is Vim not Vi.

set backspace=indent,eol,start " Allow backspace while in insert mode.

if has("vms")                  " if in a vcs
  set nobackup                 "   Don't keep backp files
else                           " otherwise
  set backup                   "   one backup file
  set undofile                 "   save undo history
endif

set incsearch                  " enable incremental search

set mouse=                     " disable all mouse interactions

                               " also disable all of the arrow keys
                               " // this leaves them on in insert mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

syntax on                      " enable syntax hilighting

if has("autocmd")              " if compiled with autocommands
  filetype plugin indent on    "  enable filetype detection and indent

  autocmd FileType text setlocal textdith=78
                               " if a text file set the max width
  autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \  exe "normal! g`\"" |
  \ endif                      " jump to position of last file open
else                           " if no autocmd
  set autoindent               " use default indenting
endif


colorscheme elflord            " a nice colour scheem

set number                     " Show current line number
set relativenumber             " Show relative line numbers
set autoread
au CursorHold,CursorHoldI * checktime
