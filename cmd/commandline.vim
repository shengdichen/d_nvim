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

