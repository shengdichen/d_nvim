" automated filetype detection
"   |on|:
"       enable filetype detection
"   |plugin|:
"       load the plugin files for specific file types
"   |indent|:
"       enable filetype-specific indentation, indispensable for drafting
"       makefiles
filetype plugin indent on
" related operations:
" {{{
" (re)detect filetype:
"       :filetype detect
" to check currently detected filetype:
"       set filetype?

" }}}

" default behavior of vim & nvim, just reinforcing
syntax on

colorscheme shrakula_theme

" show linenumber on the left "gutter" relative to the current line
set number relativenumber

" set the width of the "gutter" column for displaying line numbers to a total
" of 4 by default, i.e., 3 digits for the actual number, the right-most
" character always left blank
set numberwidth=4

" highlight the line that the cursor is currently on
set cursorline

" decide when the statusline will be visible:
"   0: never
"   1: if there are at least two panes visible at the same time
"   2: always
" set default to 0, i.e., always off
set laststatus=2


" |ruler| displays information about line and cursor position
" default to off
set noruler

" display incomplete commands in operator-pending mode
set showcmd

" |scrolloff| is the offset amount of lines maintained visible during
" bidirectional scrolling
"   ~> set default to 1
set scrolloff=2

" |showmode| determines whether or not the current mode is displayed
"   ~> set default to OFF
set noshowmode

set visualbell

" use RGB color if available
set termguicolors


" NOTE: this relies on setting the highlight group:
"       Cursor
" prior to sourcing this unit, typically done in the color-scheme.
"
" Accordingly, Shrakula performs this setting.
set guicursor=
    "\ set default for [a]ll modes to horizontal with a few options to be
    "\ overwritten below
    "\ note that the blink options will be overwritten by terminals that
    "\ has explicit cursor blinking options set
    "\      \a:hor100-blinkwait100-blinkon75-blinkoff75,
    "\      \n:hor100-myCursor-blinkon050-blinkoff050,
    \n:block-Cursor,
    "\ in insert and commandline modes, use the more ubiquitous vertical
    "\ line cursor
    "\      \i-c:ver100-blinkon200-blinkoff200,
    \i-c:ver100-Cursor,
    "\ use the more conspicuous block cursor for visual and
    "\ operator-pending mode
    "\      \v-o:block-blinkwait0
    \v-o:hor100-Cursor,


" restore cursor to steady, Beam-shape upon exit
autocmd VimLeave *
    \ set guicursor=a:ver100-blinkon0

