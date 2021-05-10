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

