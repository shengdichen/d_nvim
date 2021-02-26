" shortcut to bring up a terminal running bash in full screen
cnoremap TER terminal /bin/bash <ENTER>

" start terminal in a split window
" the prefix-"+" is required to prevent editing a new file named "terminal"
cnoremap T split +terminal /bin/bash

" make good for what has been done with "T"
cnoremap TT T

" a quick detour to autocommands:
"{{{
" the comprehensive syntax:
"       :au[tocmd] [group] {event} {pat} [++once] [++nested] {cmd}
" to view existing autocommands:
"       :autocmd
" to avoid duplication of loading autocommands when the .vim-file containing
" the autocommand is sourced multiple time, the recommended practice is to
" always enclose autocommands in an autogroup and pre-undo all the autocommands
" of this particular autogroup with |autocmd!|, which would otherwise require
" specifying a group name, but can be comfortably omitted when surrouded in
" an autogroup, in which case the name of the surrouding group is assumed:
"       augroup <my_group>
"           autocmd!
"           autocmd [<some_group>] {event} <pattern> {cmd}
" where if the argument <some_group> is omitted, the name of the enclosing
" augroup is assumed, i.e., in the augroup <my_group> surrounding, the
" following autocommands are equivalent:
"           autocmd <event> ...
"           <=> autocmd <my_group> <event> ...
" an example from the help page: |autocmd.txt
"           :au BufNewFile,BufRead *.html so <sfile>:h/html.vim
"}}}
"
" a group for terminal-mode related commands:
augroup TermMode
    " remove all
    autocmd!

    " start inserting immediately when a terminal session is opened
    autocmd TermOpen * startinsert
augroup END

" the default keybinding <C-\><C-n> is clunky to say the least, use a (much
" more) convenient shortcut
" Note: "jj" has been replaced by "JJ" to avoid collision with bindings of
" terminal applications using vi-style navigations
tnoremap JJ <C-\><C-n>

