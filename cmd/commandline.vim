" enable commandline completion
set wildmenu

" completion strategy: when multiple matches exist, prompt and complete until
" the longest common string
set wildmode=list:longest

" shortcut to save all
cnoremap :W wa! <Enter>

" everything about Vifm
cnoremap :V Vifm
cnoremap :S SplitVifm
cnoremap :H VsplitVifm
cnoremap :T TabVifm

" mapping to Backspace also clears existing input at command-line
cnoremap JJ <C-U><BS>
