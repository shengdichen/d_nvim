" enable commandline completion
set wildmenu

" completion strategy: when multiple matches exist, prompt and complete until
" the longest common string
set wildmode=list:longest

" shortcut to save all
cnoremap :W wa! <Enter>

" everything about Vifm
cnoremap :V packadd vifm <bar> Vifm
cnoremap :S packadd vifm <bar> SplitVifm
cnoremap :H packadd vifm <bar> VsplitVifm
cnoremap :T packadd vifm <bar> TabVifm

" mapping to Backspace also clears existing input at command-line
cnoremap JJ <C-U><BS>

" statusline {{{
set laststatus=0

" coloring {{{
"       highlight! link StatusLine Normal

"       highlight Folded gui=NONE guifg=#9779a7 guibg=#000000
"       highlight! link StatusLineNC Folded

highlight User1 gui=NONE guibg=#000000 guifg=#ede3f7

" warning color
highlight User2 gui=inverse guibg=#000000 guifg=#ff0000 ctermbg=000 ctermfg=23
highlight User3 gui=NONE guibg=#000000 guifg=#ff0000
highlight StatusInvert gui=NONE guibg=#ede3f7 guifg=#000000
" }}}

" start from scratch
set statusline=""

" on the left {{{
set statusline+=%.37F

" the first space is consumed by Vim, so this really is just one space
set statusline+=%{\"\ \ \"}

set statusline+=
    \~%{
        \&filetype!=\"\"
        \?
            \&filetype
        \:
            \\"voidType\"
    \}

set statusline+=
    \%{
        \&readonly==0
        \?
            \&modifiable!=0
            \?
                \\"\"
            \:
                \\"\|!W\"
        \:
            \&modifiable!=0
            \?
                \\"\|RO\"
            \:
                \\"\|RO!W\"
    \}
" }}}

" separator in the middle
set statusline+=%=

" on the right {{{
set statusline+=
    "\ highlighting holds for both active and inactive windows
    \%#StatusInvert#%{
        \&modified==\"\"
        \?
            \\"\"
        \:
            \\"!Pending!\ \ \"
    \}

" the positional numbers
set statusline+=%2*(%02c,\ %03l/%03L)
" }}}
" }}}


" toggling visibility of status-line {{{
augroup toggle_statusline
    autocmd!

    " unconditionally hide after these {{{
    autocmd
        \ FileWritePost,BufWritePost,CmdlineLeave
        \ *
        \ set laststatus=0 | redraw
    " }}}

    " hide after these events only if buffer has not changed
    autocmd
        \ InsertLeave,CmdLineLeave,TextChanged,TextChangedI,TextChangedP
        \ *
        \ if &modified != 0
            \ | set laststatus=2
        \ | else
            \ | set laststatus=0
        \ | endif

    " unconditionally show after these {{{
    autocmd
        \ InsertEnter
        \ *
        \ set laststatus=2

    " a redrawstatus is required here for statusline to actually show
    autocmd
        \ CmdlineEnter
        \ *
        \ set laststatus=2 | redrawstatus
    " }}}
augroup END
" }}}

